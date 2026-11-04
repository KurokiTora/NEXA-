import 'dotenv/config';
import cors from 'cors';
import express from 'express';
import bcrypt from 'bcryptjs';
import jwt from 'jsonwebtoken';
import { QueryTypes } from 'sequelize';

import sequelize from './config/database.js';

const app = express();
const PORT = Number(process.env.PORT || 3000);
const HOST = process.env.HOST || '0.0.0.0';
const JWT_SECRET = process.env.JWT_SECRET || 'nexa-local-dev-secret-change-me';
const ACCESS_TOKEN_TTL = process.env.ACCESS_TOKEN_TTL || '12h';
const REFRESH_TOKEN_TTL = process.env.REFRESH_TOKEN_TTL || '30d';

app.use(cors({ origin: true }));
app.use(express.json({ limit: '1mb' }));

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

class HttpError extends Error {
    constructor(status, message) {
        super(message);
        this.status = status;
    }
}

const route = (handler) => (req, res, next) =>
    Promise.resolve(handler(req, res, next)).catch(next);

const asNumber = (value, fallback = 0) => {
    const parsed = Number(value);
    return Number.isFinite(parsed) ? parsed : fallback;
};

const round2 = (value) => Math.round(asNumber(value) * 100) / 100;

const letterForScore = (score) => {
    if (score >= 85) return 'A';
    if (score >= 80) return 'A-';
    if (score >= 75) return 'B+';
    if (score >= 70) return 'B';
    if (score >= 65) return 'B-';
    if (score >= 60) return 'C+';
    if (score >= 55) return 'C';
    if (score >= 50) return 'D';
    return 'E';
};

const gradePointForScore = (score) => {
    if (score >= 85) return 4.0;
    if (score >= 80) return 3.7;
    if (score >= 75) return 3.3;
    if (score >= 70) return 3.0;
    if (score >= 65) return 2.7;
    if (score >= 60) return 2.3;
    if (score >= 55) return 2.0;
    if (score >= 50) return 1.0;
    return 0;
};

const average = (values, fallback = 0) => {
    if (!values.length) return fallback;
    return Math.round(values.reduce((sum, value) => sum + value, 0) / values.length);
};

const signTokens = (user) => {
    const accessToken = jwt.sign(
        {
            sub: String(user.user_id),
            role: user.role,
            type: 'access'
        },
        JWT_SECRET,
        { expiresIn: ACCESS_TOKEN_TTL }
    );
    const refreshToken = jwt.sign(
        {
            sub: String(user.user_id),
            type: 'refresh'
        },
        JWT_SECRET,
        { expiresIn: REFRESH_TOKEN_TTL }
    );
    return { accessToken, refreshToken };
};

const findAccount = async (login) => {
    const rows = await sequelize.query(
        `SELECT u.id AS user_id, u.email, u.password_hash, u.role,
                s.id AS student_id, s.student_id AS nim, s.full_name
         FROM users u
         LEFT JOIN students s ON s.user_id = u.id
         WHERE u.email = :login OR s.student_id = :login
         LIMIT 1`,
        {
            replacements: { login: String(login).trim() },
            type: QueryTypes.SELECT
        }
    );
    return rows[0] ?? null;
};

const findStudentByUserId = async (userId) => {
    const rows = await sequelize.query(
        `SELECT s.id, s.user_id, s.student_id, s.full_name
         FROM students s
         WHERE s.user_id = :userId
         LIMIT 1`,
        {
            replacements: { userId },
            type: QueryTypes.SELECT
        }
    );
    return rows[0] ?? null;
};

const authRequired = (req, res, next) => {
    const header = req.headers.authorization || '';
    if (!header.startsWith('Bearer ')) {
        return res.status(401).json({ error: 'Missing bearer token' });
    }

    try {
        const payload = jwt.verify(header.slice('Bearer '.length), JWT_SECRET);
        if (payload.type !== 'access') {
            throw new Error('Wrong token type');
        }
        req.auth = payload;
        next();
    } catch (_) {
        res.status(401).json({ error: 'Invalid or expired token' });
    }
};

// ---------------------------------------------------------------------------
// Auth
// ---------------------------------------------------------------------------

app.post(
    '/auth/login',
    route(async (req, res) => {
        const login = req.body?.nim ?? req.body?.email;
        const password = req.body?.password;

        if (!login || !password) {
            throw new HttpError(400, 'nim and password are required');
        }

        const account = await findAccount(login);
        if (!account) throw new HttpError(401, 'Invalid credentials');

        const valid = await bcrypt.compare(String(password), account.password_hash);
        if (!valid) throw new HttpError(401, 'Invalid credentials');

        res.json(signTokens(account));
    })
);

app.post(
    '/auth/refresh',
    route(async (req, res) => {
        const refreshToken = req.body?.refreshToken;
        if (!refreshToken) throw new HttpError(400, 'refreshToken is required');

        let payload;
        try {
            payload = jwt.verify(refreshToken, JWT_SECRET);
        } catch (_) {
            throw new HttpError(401, 'Invalid or expired refresh token');
        }
        if (payload.type !== 'refresh') {
            throw new HttpError(401, 'Invalid refresh token');
        }

        const rows = await sequelize.query(
            'SELECT id AS user_id, email, role FROM users WHERE id = :id LIMIT 1',
            {
                replacements: { id: payload.sub },
                type: QueryTypes.SELECT
            }
        );
        const account = rows[0];
        if (!account) throw new HttpError(401, 'Account no longer exists');

        res.json(signTokens(account));
    })
);

// ---------------------------------------------------------------------------
// Student snapshot
// ---------------------------------------------------------------------------

app.get(
    '/student/me',
    authRequired,
    route(async (req, res) => {
        const student = await findStudentByUserId(req.auth.sub);
        if (!student) throw new HttpError(403, 'This account has no student profile');

        const activeSksRows = await sequelize.query(
            `SELECT COALESCE(SUM(c.credits), 0) AS total
             FROM enrollments e
             JOIN classes cl ON cl.id = e.class_id
             JOIN courses c ON c.id = cl.course_id
             WHERE e.student_id = :studentId AND e.status = 'active'`,
            {
                replacements: { studentId: student.id },
                type: QueryTypes.SELECT
            }
        );
        const totalSksRows = await sequelize.query(
            `SELECT COALESCE(SUM(c.credits), 0) AS total
             FROM enrollments e
             JOIN classes cl ON cl.id = e.class_id
             JOIN courses c ON c.id = cl.course_id
             WHERE e.student_id = :studentId
               AND e.status IN ('active', 'completed')`,
            {
                replacements: { studentId: student.id },
                type: QueryTypes.SELECT
            }
        );

        const gradeQuery = (statusClause) =>
            sequelize.query(
                `SELECT COALESCE(
                            SUM(cr.grade_point * c.credits) / NULLIF(SUM(c.credits), 0),
                            0
                        ) AS ip
                 FROM enrollments e
                 JOIN classes cl ON cl.id = e.class_id
                 JOIN courses c ON c.id = cl.course_id
                 JOIN (
                     SELECT enrollment_id, MAX(id) AS id
                     FROM course_results
                     GROUP BY enrollment_id
                 ) latest ON latest.enrollment_id = e.id
                 JOIN course_results cr ON cr.id = latest.id
                 WHERE e.student_id = :studentId AND ${statusClause}`,
                {
                    replacements: { studentId: student.id },
                    type: QueryTypes.SELECT
                }
            );

        const [semesterIp, cumulativeIp] = await Promise.all([
            gradeQuery("e.status = 'active'"),
            gradeQuery("e.status IN ('active', 'completed')")
        ]);

        res.json({
            nim: student.student_id,
            name: student.full_name,
            sksSemester: asNumber(activeSksRows[0]?.total),
            sksTotal: asNumber(totalSksRows[0]?.total),
            ipSemester: round2(semesterIp[0]?.ip),
            ipCumulative: round2(cumulativeIp[0]?.ip)
        });
    })
);

app.get(
    '/student/courses',
    authRequired,
    route(async (req, res) => {
        const student = await findStudentByUserId(req.auth.sub);
        if (!student) throw new HttpError(403, 'This account has no student profile');

        const enrollments = await sequelize.query(
            `SELECT e.id AS enrollment_id, cl.id AS class_id,
                    c.id AS course_id, c.course_code, c.course_name, c.credits
             FROM enrollments e
             JOIN classes cl ON cl.id = e.class_id
             JOIN courses c ON c.id = cl.course_id
             WHERE e.student_id = :studentId
             ORDER BY c.course_name`,
            {
                replacements: { studentId: student.id },
                type: QueryTypes.SELECT
            }
        );

        const courses = await Promise.all(
            enrollments.map(async (enrollment) => {
                const [assessments, attendanceRows, resultRows] = await Promise.all([
                    sequelize.query(
                        `SELECT a.id, a.title, a.type, a.max_score, a.due_at,
                                sc.score, sc.feedback, sub.submitted_at
                         FROM assessments a
                         LEFT JOIN assessment_scores sc
                           ON sc.assessment_id = a.id
                          AND sc.enrollment_id = :enrollmentId
                         LEFT JOIN assignments asg ON asg.assessment_id = a.id
                         LEFT JOIN submissions sub
                           ON sub.assignment_id = asg.id
                          AND sub.enrollment_id = :enrollmentId
                         WHERE a.class_id = :classId
                         ORDER BY a.due_at IS NULL, a.due_at, a.id`,
                        {
                            replacements: {
                                enrollmentId: enrollment.enrollment_id,
                                classId: enrollment.class_id
                            },
                            type: QueryTypes.SELECT
                        }
                    ),
                    sequelize.query(
                        `SELECT ar.status, sess.session_date
                         FROM attendance_records ar
                         JOIN attendance_sessions sess
                           ON sess.id = ar.attendance_session_id
                         WHERE ar.enrollment_id = :enrollmentId
                         ORDER BY sess.session_date, sess.id`,
                        {
                            replacements: { enrollmentId: enrollment.enrollment_id },
                            type: QueryTypes.SELECT
                        }
                    ),
                    sequelize.query(
                        `SELECT final_score, grade_point
                         FROM course_results
                         WHERE enrollment_id = :enrollmentId
                         ORDER BY id DESC
                         LIMIT 1`,
                        {
                            replacements: { enrollmentId: enrollment.enrollment_id },
                            type: QueryTypes.SELECT
                        }
                    )
                ]);

                const mappedAssessments = assessments.map((assessment) => {
                    const maxScore = asNumber(assessment.max_score, 100) || 100;
                    const hasScore = assessment.score !== null && assessment.score !== undefined;
                    const percentage = hasScore
                        ? Math.min(
                              100,
                              Math.max(0, Math.round((asNumber(assessment.score) / maxScore) * 100))
                          )
                        : null;

                    let status = 'missing';
                    if (hasScore) {
                        status = 'onTime';
                        if (assessment.submitted_at && assessment.due_at) {
                            status =
                                new Date(assessment.submitted_at) >
                                new Date(assessment.due_at)
                                    ? 'late'
                                    : 'onTime';
                        }
                    }

                    return {
                        title: assessment.title,
                        status,
                        score: percentage,
                        feedback: assessment.feedback || null,
                        isUts: /(^|\b)UTS\b/i.test(assessment.title),
                        isUas: /(^|\b)UAS\b/i.test(assessment.title)
                    };
                });

                const percentages = mappedAssessments
                    .map((assessment) => assessment.score)
                    .filter((score) => score !== null);
                const taskScores = mappedAssessments
                    .filter((assessment) => !assessment.isUts && !assessment.isUas)
                    .map((assessment) => assessment.score)
                    .filter((score) => score !== null);
                const utsScores = mappedAssessments
                    .filter((assessment) => assessment.isUts)
                    .map((assessment) => assessment.score)
                    .filter((score) => score !== null);
                const uasScores = mappedAssessments
                    .filter((assessment) => assessment.isUas)
                    .map((assessment) => assessment.score)
                    .filter((score) => score !== null);

                const result = resultRows[0];
                const fallbackScore = average(percentages);
                const finalScore =
                    result?.final_score !== undefined && result?.final_score !== null
                        ? asNumber(result.final_score)
                        : fallbackScore;
                const grade = Math.round(finalScore);

                let attend = 0;
                let permit = 0;
                let sick = 0;
                let alpha = 0;
                const mappedAttendance = attendanceRows.map((row, index) => {
                    let status = 'attend';
                    if (row.status === 'absent') status = 'alpha';
                    else if (row.status === 'excused' || row.status === 'permit') status = 'permit';
                    else if (row.status === 'sick') status = 'sick';
                    else if (row.status === 'late') status = 'attend';

                    if (status === 'attend') attend += 1;
                    else if (status === 'permit') permit += 1;
                    else if (status === 'sick') sick += 1;
                    else alpha += 1;

                    return {
                        title: `Class Meeting ${index + 1}`,
                        status
                    };
                });

                const totalSessions = mappedAttendance.length;
                const attendPercent = totalSessions
                    ? Math.round(((attend + permit + sick) / totalSessions) * 100)
                    : 0;

                return {
                    id: asNumber(enrollment.course_id),
                    name: enrollment.course_name,
                    code: enrollment.course_code,
                    colorIndex: (asNumber(enrollment.course_id) - 1) % 6,
                    grade,
                    letter: letterForScore(grade),
                    taskScore: average(taskScores, grade),
                    attendScore: attendPercent,
                    utsScore: average(utsScores, grade),
                    uasScore: average(uasScores, grade),
                    attendPercent,
                    attendCount: attend,
                    permitCount: permit,
                    sickCount: sick,
                    alphaCount: alpha,
                    assessments: mappedAssessments.map(({ title, status, score }) => ({
                        title,
                        status,
                        score
                    })),
                    attendance: mappedAttendance,
                    feedback: mappedAssessments
                        .filter((assessment) => assessment.feedback)
                        .map((assessment) => ({
                            title: `Feedback ${assessment.title}`,
                            body: assessment.feedback
                        })),
                    // The current schema has no weekly timetable/room table.
                    // Keep the contract stable so reminders simply skip these.
                    schedule: []
                };
            })
        );

        res.json(courses);
    })
);

// ---------------------------------------------------------------------------
// Health + errors
// ---------------------------------------------------------------------------

app.get(
    '/health',
    route(async (_req, res) => {
        await sequelize.query('SELECT 1');
        res.json({ ok: true, database: process.env.DB_NAME || 'lecturer_assistant' });
    })
);

app.get('/', (_req, res) => {
    res.json({
        name: 'NEXA API',
        endpoints: [
            'POST /auth/login',
            'POST /auth/refresh',
            'GET /student/me',
            'GET /student/courses',
            'GET /health'
        ]
    });
});

app.use((_req, res) => {
    res.status(404).json({ error: 'Not found' });
});

app.use((error, _req, res, _next) => {
    const status = error.status || 500;
    if (status >= 500) console.error(error);
    res.status(status).json({
        error: status >= 500 ? 'Internal server error' : error.message
    });
});

// ---------------------------------------------------------------------------
// Boot
// ---------------------------------------------------------------------------

const start = async () => {
    await sequelize.authenticate();
    app.listen(PORT, HOST, () => {
        console.log(`NEXA API listening on http://localhost:${PORT}`);
        console.log(`Android emulator: http://10.0.2.2:${PORT}`);
        console.log(`Database: ${process.env.DB_NAME || 'lecturer_assistant'} @ ${process.env.DB_HOST || '127.0.0.1'}`);
    });
};

start().catch((error) => {
    console.error('Unable to start NEXA API:');
    console.error(error.message);
    process.exitCode = 1;
});
