import 'dotenv/config';
import bcrypt from 'bcryptjs';
import { QueryTypes } from 'sequelize';

import sequelize from './config/database.js';

const DEMO_STUDENT_ID = '253100000000';
const DEMO_STUDENT_EMAIL = '253100000000@nexa.test';
const DEMO_PASSWORD = 'password123';
const DEMO_LECTURER_EMAIL = 'dosen@nexa.test';

const COURSES = [
    { code: 'IF301', name: 'Pemrograman Mobile', credits: 3, score: 88 },
    { code: 'IF302', name: 'Jaringan Komputer', credits: 3, score: 86 },
    { code: 'IF303', name: 'Kecerdasan Buatan', credits: 3, score: 92 },
    { code: 'IF304', name: 'Basis Data', credits: 3, score: 82 },
    { code: 'IF305', name: 'Sistem Operasi', credits: 2, score: 78 },
    { code: 'IF306', name: 'Pemrograman Web', credits: 3, score: 90 },
    { code: 'IF307', name: 'Statistika', credits: 2, score: 84 }
];

const ASSESSMENTS = [
    { title: 'Meeting 1 Assignment', type: 'assignment', offset: -6 },
    { title: 'Meeting 2 Assignment', type: 'assignment', offset: 2 },
    { title: 'Meeting 3 Assignment', type: 'assignment', offset: -4 },
    { title: 'Meeting 4 Assignment', type: 'assignment', offset: 0 },
    { title: 'UTS', type: 'exam', offset: 3 },
    { title: 'UAS', type: 'exam', offset: -1 }
];

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

const dateOnly = (date) => {
    const y = date.getFullYear();
    const m = String(date.getMonth() + 1).padStart(2, '0');
    const d = String(date.getDate()).padStart(2, '0');
    return `${y}-${m}-${d}`;
};

const dateTime = (date) => {
    const hours = String(date.getHours()).padStart(2, '0');
    const minutes = String(date.getMinutes()).padStart(2, '0');
    return `${dateOnly(date)} ${hours}:${minutes}:00`;
};

const weeksAgo = (weeks, extraDays = 0) => {
    const date = new Date();
    date.setDate(date.getDate() - weeks * 7 + extraDays);
    date.setHours(9, 0, 0, 0);
    return date;
};

const insert = async (sql, replacements, transaction) => {
    const [id] = await sequelize.query(sql, {
        replacements,
        type: QueryTypes.INSERT,
        transaction
    });
    return id;
};

const ensureStudent = async (transaction) => {
    const existing = await sequelize.query(
        `SELECT s.id, s.user_id, s.student_id, s.full_name
         FROM students s
         JOIN users u ON u.id = s.user_id
         WHERE s.student_id = ? OR u.email = ?
         ORDER BY s.id
         LIMIT 1`,
        {
            replacements: [DEMO_STUDENT_ID, DEMO_STUDENT_EMAIL],
            type: QueryTypes.SELECT,
            transaction
        }
    );
    if (existing[0]) return existing[0];

    const passwordHash = await bcrypt.hash(DEMO_PASSWORD, 10);
    const userId = await insert(
        `INSERT INTO users (email, password_hash, role, created_at, updated_at)
         VALUES (?, ?, 'student', NOW(), NOW())`,
        [DEMO_STUDENT_EMAIL, passwordHash],
        transaction
    );
    const studentId = await insert(
        `INSERT INTO students (user_id, student_id, full_name)
         VALUES (?, ?, 'Nexa Test Student')`,
        [userId, DEMO_STUDENT_ID],
        transaction
    );
    return {
        id: studentId,
        user_id: userId,
        student_id: DEMO_STUDENT_ID,
        full_name: 'Nexa Test Student'
    };
};

const ensureLecturer = async (transaction) => {
    const existingUser = await sequelize.query(
        'SELECT id FROM users WHERE email = ? LIMIT 1',
        {
            replacements: [DEMO_LECTURER_EMAIL],
            type: QueryTypes.SELECT,
            transaction
        }
    );

    let userId = existingUser[0]?.id;
    if (!userId) {
        const passwordHash = await bcrypt.hash(DEMO_PASSWORD, 10);
        userId = await insert(
            `INSERT INTO users (email, password_hash, role, created_at, updated_at)
             VALUES (?, ?, 'lecturer', NOW(), NOW())`,
            [DEMO_LECTURER_EMAIL, passwordHash],
            transaction
        );
    }

    const existingLecturer = await sequelize.query(
        'SELECT id FROM lecturers WHERE user_id = ? LIMIT 1',
        {
            replacements: [userId],
            type: QueryTypes.SELECT,
            transaction
        }
    );
    if (existingLecturer[0]) return existingLecturer[0].id;

    return insert(
        `INSERT INTO lecturers (user_id, lecturer_id, full_name)
         VALUES (?, 'L001', 'Dosen NEXA')`,
        [userId],
        transaction
    );
};

const ensurePeriod = async (transaction) => {
    const rows = await sequelize.query(
        'SELECT id FROM academic_periods ORDER BY id DESC LIMIT 1',
        { type: QueryTypes.SELECT, transaction }
    );
    if (rows[0]) return rows[0].id;

    return insert(
        `INSERT INTO academic_periods
             (academic_year, semester, start_date, end_date)
         VALUES ('2026/2027', 'odd', '2026-08-01', '2026-12-31')`,
        [],
        transaction
    );
};

const seedCourse = async ({
    course,
    index,
    student,
    lecturerId,
    periodId,
    transaction
}) => {
    const courseId = await insert(
        'INSERT INTO courses (course_code, course_name, credits) VALUES (?, ?, ?)',
        [course.code, course.name, course.credits],
        transaction
    );

    const classId = await insert(
        `INSERT INTO classes
             (course_id, lecturer_id, academic_period_id, class_code, join_code)
         VALUES (?, ?, ?, ?, ?)`,
        [
            courseId,
            lecturerId,
            periodId,
            `${course.code}-A`,
            `NEXA${1000 + index}`
        ],
        transaction
    );

    const enrollmentId = await insert(
        `INSERT INTO enrollments (student_id, class_id, status, enrolled_at)
         VALUES (?, ?, 'active', NOW())`,
        [student.id, classId],
        transaction
    );

    const gradingConfigId = await insert(
        `INSERT INTO grading_configurations
             (class_id, version, created_by)
         VALUES (?, 1, ?)`,
        [classId, lecturerId],
        transaction
    );

    await insert(
        `INSERT INTO course_results
             (enrollment_id, grading_configuration_id, final_score, grade_point)
         VALUES (?, ?, ?, ?)`,
        [
            enrollmentId,
            gradingConfigId,
            course.score,
            gradePointForScore(course.score)
        ],
        transaction
    );

    for (let i = 0; i < ASSESSMENTS.length; i += 1) {
        const assessment = ASSESSMENTS[i];
        const dueDate = weeksAgo(ASSESSMENTS.length - i, 2);

        const assessmentId = await insert(
            `INSERT INTO assessments
                 (class_id, title, description, type, max_score, due_at)
             VALUES (?, ?, ?, ?, 100, ?)`,
            [
                classId,
                assessment.title,
                `Demo assessment for ${course.name}`,
                assessment.type,
                dateTime(dueDate)
            ],
            transaction
        );

        let assignmentId = null;
        if (assessment.type === 'assignment') {
            assignmentId = await insert(
                'INSERT INTO assignments (assessment_id) VALUES (?)',
                [assessmentId],
                transaction
            );
        }

        // One intentionally missing score so the mobile detail page can show
        // the "missing" state.
        const isMissing = index === 3 && i === 3;
        if (isMissing) continue;

        if (assignmentId) {
            const submittedLate = index === 1 && i === 2;
            const submittedAt = new Date(dueDate);
            submittedAt.setDate(submittedAt.getDate() + (submittedLate ? 2 : -1));

            await insert(
                `INSERT INTO submissions
                     (assignment_id, enrollment_id, submitted_at)
                 VALUES (?, ?, ?)`,
                [assignmentId, enrollmentId, dateTime(submittedAt)],
                transaction
            );
        }

        const score = Math.max(
            0,
            Math.min(100, course.score + assessment.offset)
        );
        const feedback =
            assessment.title === 'UTS'
                ? 'Solid understanding of the core concepts. Watch submission timing and double-check edge cases.'
                : assessment.title === 'UAS'
                  ? 'Well structured final work and a clear improvement from the mid-term. Keep this consistency.'
                  : null;

        await insert(
            `INSERT INTO assessment_scores
                 (assessment_id, enrollment_id, score, graded_at, feedback)
             VALUES (?, ?, ?, ?, ?)`,
            [assessmentId, enrollmentId, score, dateTime(dueDate), feedback],
            transaction
        );
    }

    const attendanceStatuses = [
        'present',
        'present',
        'present',
        'excused',
        'present',
        'present',
        'present',
        index === 3 ? 'absent' : 'present'
    ];

    for (let i = 0; i < attendanceStatuses.length; i += 1) {
        const sessionDate = weeksAgo(attendanceStatuses.length - i);
        const sessionId = await insert(
            `INSERT INTO attendance_sessions (class_id, session_date)
             VALUES (?, ?)`,
            [classId, dateOnly(sessionDate)],
            transaction
        );
        await insert(
            `INSERT INTO attendance_records
                 (attendance_session_id, enrollment_id, status, recorded_at)
             VALUES (?, ?, ?, ?)`,
            [sessionId, enrollmentId, attendanceStatuses[i], dateTime(sessionDate)],
            transaction
        );
    }
};

const run = async () => {
    await sequelize.authenticate();
    console.log('Connected to the database.');

    const existingCourses = await sequelize.query(
        'SELECT COUNT(*) AS total FROM courses',
        { type: QueryTypes.SELECT }
    );
    if (Number(existingCourses[0].total) > 0) {
        console.log('Courses already exist, seed skipped (nothing was changed).');
        console.log(`Demo student: ${DEMO_STUDENT_ID} / ${DEMO_PASSWORD}`);
        return;
    }

    await sequelize.transaction(async (transaction) => {
        const student = await ensureStudent(transaction);
        const lecturerId = await ensureLecturer(transaction);
        const periodId = await ensurePeriod(transaction);

        for (let i = 0; i < COURSES.length; i += 1) {
            await seedCourse({
                course: COURSES[i],
                index: i,
                student,
                lecturerId,
                periodId,
                transaction
            });
        }

        console.log(
            `Seeded ${COURSES.length} courses for ${student.full_name} (${student.student_id}).`
        );
    });

    console.log('Seed complete.');
    console.log(`Login mobile: NIM ${DEMO_STUDENT_ID} / password ${DEMO_PASSWORD}`);
};

run()
    .catch((error) => {
        console.error('Seed failed:', error);
        process.exitCode = 1;
    })
    .finally(async () => {
        await sequelize.close();
    });
