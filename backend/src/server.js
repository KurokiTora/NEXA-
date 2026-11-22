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

const GROQ_API_URL = 'https://api.groq.com/openai/v1/chat/completions';
const GROQ_MODEL = process.env.GROQ_MODEL || 'openai/gpt-oss-20b';
const GROQ_TIMEOUT_MS = 30000;

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

// ---------------------------------------------------------------------------
// NEXA AI chatbot (Groq)
// ---------------------------------------------------------------------------

const CHATBOT_SYSTEM_PROMPT = `
Kamu adalah NEXA AI, asisten akademik resmi di aplikasi NEXA.

IDENTITAS DAN RUANG LINGKUP:
1. Bantu pengguna hanya untuk topik akademik (nilai, IPK, absensi, mata kuliah, tugas, feedback dosen, performa) dan cara memakai fitur NEXA.
2. Gunakan data akademik dari backend hanya untuk pengguna yang sedang login.
3. Jangan mengarang nilai, IPK, absensi, mata kuliah, tugas, atau data akademik lain.
4. Jangan mengungkapkan data milik pengguna lain dan jangan meminta password/token.
5. Tolak pertanyaan di luar topik akademik/NEXA dengan sopan dan singkat.

GAYA:
6. Gunakan bahasa Indonesia yang jelas dan profesional.
7. Jawab ringkas, maksimal tiga kalimat, dan langsung ke inti.
8. Jika data tidak tersedia, katakan belum bisa diakses. Jangan menebak.

Perintah yang tersedia di aplikasi:
- /feedback   : analisis feedback dosen dan tindak lanjutnya
- /attendance : analisis kehadiran dan saran perbaikan
- /studyplan  : saran belajar dan target nilai
- /performance: tren nilai dan mata kuliah yang perlu perhatian
`;

const CHATBOT_COMMAND_PROMPTS = {
    '/feedback':
        'Pengguna memilih perintah /feedback. Berikan analisis feedback dosen dari data akademik, lalu sarankan tindak lanjut yang konkret.',
    '/attendance':
        'Pengguna memilih perintah /attendance. Analisis persentase dan rekap kehadiran, lalu berikan saran agar kehadiran tetap aman.',
    '/studyplan':
        'Pengguna memilih perintah /studyplan. Berikan rencana belajar singkat dan target nilai yang realistis berdasarkan data akademik.',
    '/performance':
        'Pengguna memilih perintah /performance. Analisis tren nilai dan sebutkan mata kuliah yang perlu perhatian beserta alasannya.'
};

/// Read-only academic context for the signed-in student. Returns null for
/// accounts without a student profile (e.g. lecturers).
const buildAcademicContext = async (userId) => {
    const student = await findStudentByUserId(userId);
    if (!student) return null;

    const [courseRows, feedbackRows] = await Promise.all([
        sequelize.query(
            `SELECT c.course_code, c.course_name, c.credits,
                    e.status AS enrollment_status,
                    cr.final_score, cr.grade_point,
                    COUNT(ar.id) AS total_sessions,
                    SUM(CASE WHEN ar.status IN ('present', 'late') THEN 1 ELSE 0 END) AS present_count,
                    SUM(CASE WHEN ar.status = 'excused' THEN 1 ELSE 0 END) AS excused_count,
                    SUM(CASE WHEN ar.status = 'absent' THEN 1 ELSE 0 END) AS absent_count
             FROM enrollments e
             JOIN classes cl ON cl.id = e.class_id
             JOIN courses c ON c.id = cl.course_id
             LEFT JOIN (
                 SELECT enrollment_id, MAX(id) AS id
                 FROM course_results
                 GROUP BY enrollment_id
             ) latest ON latest.enrollment_id = e.id
             LEFT JOIN course_results cr ON cr.id = latest.id
             LEFT JOIN attendance_records ar ON ar.enrollment_id = e.id
             WHERE e.student_id = :studentId
             GROUP BY e.id, c.course_code, c.course_name, c.credits,
                      e.status, cr.final_score, cr.grade_point
             ORDER BY c.course_name
             LIMIT 30`,
            {
                replacements: { studentId: student.id },
                type: QueryTypes.SELECT
            }
        ),
        sequelize.query(
            `SELECT c.course_name, a.title, sc.feedback
             FROM assessment_scores sc
             JOIN assessments a ON a.id = sc.assessment_id
             JOIN enrollments e ON e.id = sc.enrollment_id
             JOIN classes cl ON cl.id = a.class_id
             JOIN courses c ON c.id = cl.course_id
             WHERE e.student_id = :studentId
               AND sc.feedback IS NOT NULL
               AND TRIM(sc.feedback) <> ''
             ORDER BY a.id
             LIMIT 30`,
            {
                replacements: { studentId: student.id },
                type: QueryTypes.SELECT
            }
        )
    ]);

    const courses = courseRows.map((row) => {
        const total = asNumber(row.total_sessions);
        const present = asNumber(row.present_count);
        const excused = asNumber(row.excused_count);
        const absent = asNumber(row.absent_count);
        const counted = present + excused;
        return {
            code: row.course_code,
            name: row.course_name,
            credits: asNumber(row.credits),
            status: row.enrollment_status,
            finalScore:
                row.final_score === null || row.final_score === undefined
                    ? null
                    : round2(row.final_score),
            gradePoint:
                row.grade_point === null || row.grade_point === undefined
                    ? null
                    : round2(row.grade_point),
            attendance: {
                totalSessions: total,
                present,
                excused,
                absent,
                percent: total ? Math.round((counted / total) * 100) : null
            }
        };
    });

    return {
        student: { nim: student.student_id, name: student.full_name },
        courses,
        feedback: feedbackRows.map((row) => ({
            course: row.course_name,
            title: row.title,
            feedback: row.feedback
        }))
    };
};

const generateChatbotReply = async (message, context) => {
    const apiKey = process.env.GROQ_API_KEY;
    if (!apiKey) {
        throw new HttpError(
            503,
            'GROQ_API_KEY belum diatur di backend/.env. Tambahkan API key Groq lalu restart backend.'
        );
    }

    const commandPrompt = CHATBOT_COMMAND_PROMPTS[message.toLowerCase()];
    const userContent = commandPrompt
        ? `${commandPrompt}\n\nPesan pengguna: ${message}`
        : message;
    const contextContent = context
        ? `DATA AKADEMIK PENGGUNA (JSON, hanya untuk pengguna ini):\n${JSON.stringify(context)}`
        : 'DATA AKADEMIK PENGGUNA: tidak tersedia untuk akun ini. Jangan menebak datanya.';

    let response;
    try {
        response = await fetch(GROQ_API_URL, {
            method: 'POST',
            signal: AbortSignal.timeout(GROQ_TIMEOUT_MS),
            headers: {
                'Content-Type': 'application/json',
                Authorization: `Bearer ${apiKey}`
            },
            body: JSON.stringify({
                model: GROQ_MODEL,
                messages: [
                    { role: 'system', content: CHATBOT_SYSTEM_PROMPT },
                    { role: 'system', content: contextContent },
                    { role: 'user', content: userContent }
                ],
                max_tokens: 300,
                temperature: 0.2
            })
        });
    } catch (error) {
        if (error.name === 'TimeoutError' || error.name === 'AbortError') {
            throw new HttpError(504, 'NEXA AI melewati batas waktu. Coba lagi.');
        }
        throw new HttpError(502, 'Tidak dapat terhubung ke layanan NEXA AI.');
    }

    let result;
    try {
        result = await response.json();
    } catch {
        throw new HttpError(502, 'Respons NEXA AI tidak valid.');
    }

    if (!response.ok) {
        if (response.status === 429) {
            throw new HttpError(429, 'Layanan NEXA AI sedang mencapai batas permintaan.');
        }
        throw new HttpError(
            502,
            result.error?.message || 'Permintaan ke layanan NEXA AI gagal.'
        );
    }

    const reply = result.choices?.[0]?.message?.content?.trim();
    if (!reply) {
        throw new HttpError(502, 'NEXA AI tidak menghasilkan jawaban.');
    }
    return reply;
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
// Chatbot
// ---------------------------------------------------------------------------

const chatbotMessageHandler = route(async (req, res) => {
    const raw = req.body?.message;
    if (typeof raw !== 'string' || !raw.trim()) {
        throw new HttpError(400, 'message is required');
    }

    const message = raw.trim();
    if (message.length > 2000) {
        throw new HttpError(400, 'message maksimal 2000 karakter');
    }

    const context = await buildAcademicContext(req.auth.sub);
    const reply = await generateChatbotReply(message, context);

    // `reply` is what the current mobile app reads. `data.reply` keeps older
    // clients (the fawwaz-work contract) working too.
    res.json({
        success: true,
        reply,
        data: { role: 'assistant', reply }
    });
});

app.post('/chatbot/message', authRequired, chatbotMessageHandler);
// Alias for clients built against the fawwaz-work backend.
app.post('/api/chatbot/message', authRequired, chatbotMessageHandler);

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
            'POST /chatbot/message',
            'POST /api/chatbot/message',
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
        // HttpError messages are written for the client; unexpected 5xx
        // errors must not leak stack traces or SQL details.
        error:
            error instanceof HttpError
                ? error.message
                : status >= 500
                  ? 'Internal server error'
                  : error.message
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
