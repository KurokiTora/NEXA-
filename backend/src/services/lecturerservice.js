import { fn, col, QueryTypes } from 'sequelize';

import sequelize from '../config/database.js';

import {
    Lecturer,
    Class,
    Course,
    Enrollment,
    Student,
    Assessment,
    Assignment,
    Submission,
    AssessmentScore,
    AttendanceSession,
    AttendanceRecord
} from '../models/index.js';

import { calculateAttendancePercentage } from './attendanceservice.js';

/* ------------------------------------------------------------------ */
/* Helpers                                                             */
/* ------------------------------------------------------------------ */

function round(value, digits = 1) {
    const factor = 10 ** digits;
    return Math.round(value * factor) / factor;
}

function toPercent(score, maxScore) {
    const max = Number(maxScore);
    return max > 0 ? (Number(score) / max) * 100 : null;
}

export async function findLecturerByUserId(userId) {
    return Lecturer.findOne({ where: { userId } });
}

/* ------------------------------------------------------------------ */
/* Schedule (class_schedules table)                                    */
/* ------------------------------------------------------------------ */

const DAY_NAMES = [
    '', 'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'
];

async function getSchedule(classIds) {
    try {
        const rows = await sequelize.query(
            `SELECT cs.id,
                    cs.day_of_week AS dayOfWeek,
                    c.class_code AS classCode,
                    cs.room,
                    TIME_FORMAT(cs.start_time, '%H.%i') AS startTime,
                    TIME_FORMAT(cs.end_time, '%H.%i') AS endTime
               FROM class_schedules cs
               JOIN classes c ON c.id = cs.class_id
              WHERE cs.class_id IN (:classIds)
              ORDER BY cs.day_of_week ASC, cs.start_time ASC`,
            { replacements: { classIds }, type: QueryTypes.SELECT }
        );

        return rows.map(row => ({
            id: Number(row.id),
            day: DAY_NAMES[row.dayOfWeek] ?? '',
            classCode: row.classCode,
            room: row.room,
            time: `${row.startTime} - ${row.endTime}`
        }));
    } catch (error) {
        // Table not created yet: show an empty schedule instead of a 500
        if (error?.original?.code === 'ER_NO_SUCH_TABLE') return [];
        throw error;
    }
}

/* ------------------------------------------------------------------ */
/* Dashboard                                                           */
/* ------------------------------------------------------------------ */

export async function getDashboard(lecturerId) {
    const classes = await Class.findAll({
        where: { lecturerId },
        attributes: ['id'],
        raw: true
    });

    const classIds = classes.map(item => item.id);

    if (classIds.length === 0) {
        return {
            stats: {
                attendancePercentage: null,
                studentCount: 0,
                averageGrade: null
            },
            schedule: []
        };
    }

    // Distinct active students across all of the lecturer's classes
    const studentCount = await Enrollment.count({
        where: { classId: classIds, status: 'active' },
        distinct: true,
        col: 'student_id'
    });

    // Attendance across all sessions of the lecturer's classes
    const attendanceRows = await AttendanceRecord.findAll({
        attributes: ['status'],
        include: [
            {
                model: AttendanceSession,
                as: 'attendanceSession',
                attributes: [],
                where: { classId: classIds },
                required: true
            },
            {
                model: Enrollment,
                as: 'enrollment',
                attributes: [],
                where: { status: 'active' },
                required: true
            }
        ],
        raw: true
    });

    const attendancePercentage = attendanceRows.length
        ? calculateAttendancePercentage(attendanceRows.map(row => row.status))
        : null;

    // Average grade = mean of (score / max_score * 100)
    const scoreRows = await AssessmentScore.findAll({
        attributes: ['score'],
        include: [
            {
                model: Assessment,
                as: 'assessment',
                attributes: ['maxScore'],
                where: { classId: classIds },
                required: true
            }
        ],
        raw: true
    });

    const percentages = scoreRows
        .map(row => toPercent(row.score, row['assessment.maxScore']))
        .filter(value => value !== null);

    const averageGrade = percentages.length
        ? round(percentages.reduce((a, b) => a + b, 0) / percentages.length)
        : null;

    return {
        stats: { attendancePercentage, studentCount, averageGrade },
        schedule: await getSchedule(classIds)
    };
}

/* ------------------------------------------------------------------ */
/* Classes                                                             */
/* ------------------------------------------------------------------ */

export async function getClasses(lecturerId) {
    const classes = await Class.findAll({
        where: { lecturerId },
        include: [
            { model: Course, as: 'course', attributes: ['courseName'] }
        ],
        order: [['id', 'ASC']]
    });

    if (classes.length === 0) return [];

    const counts = await Enrollment.findAll({
        // group/col use real column names: Sequelize does not map them
        attributes: [
            ['class_id', 'classId'],
            [fn('COUNT', col('id')), 'total']
        ],
        where: { classId: classes.map(item => item.id), status: 'active' },
        group: ['class_id'],
        raw: true
    });

    const countByClass = new Map(
        counts.map(row => [Number(row.classId), Number(row.total)])
    );

    return classes.map(item => ({
        id: Number(item.id),
        courseName: item.course.courseName,
        classCode: item.classCode,
        studentCount: countByClass.get(Number(item.id)) ?? 0
    }));
}

async function findOwnedClass(lecturerId, classId) {
    return Class.findOne({
        where: { id: classId, lecturerId },
        include: [
            { model: Course, as: 'course', attributes: ['courseName'] }
        ]
    });
}

export async function getClassDetail(lecturerId, classId) {
    const classItem = await findOwnedClass(lecturerId, classId);

    if (!classItem) return null;

    const enrollments = await Enrollment.findAll({
        where: { classId, status: 'active' },
        include: [
            {
                model: Student,
                as: 'student',
                attributes: ['id', 'studentId', 'fullName'],
                required: true
            }
        ],
        order: [[{ model: Student, as: 'student' }, 'fullName', 'ASC']]
    });

    return {
        id: Number(classItem.id),
        courseName: classItem.course.courseName,
        classCode: classItem.classCode,
        students: enrollments.map(item => ({
            id: Number(item.student.id),
            fullName: item.student.fullName,
            studentNumber: item.student.studentId
        }))
    };
}

/* ------------------------------------------------------------------ */
/* Student detail inside a class                                       */
/* ------------------------------------------------------------------ */

export async function getStudentDetail(lecturerId, classId, studentId) {
    const classItem = await findOwnedClass(lecturerId, classId);

    if (!classItem) return null;

    const enrollment = await Enrollment.findOne({
        where: { classId, studentId, status: 'active' },
        include: [
            {
                model: Student,
                as: 'student',
                attributes: ['id', 'studentId', 'fullName'],
                required: true
            }
        ]
    });

    if (!enrollment) return null;

    const assignments = await Assignment.findAll({
        include: [
            {
                model: Assessment,
                as: 'assessment',
                attributes: ['id', 'title', 'maxScore'],
                where: { classId },
                required: true
            }
        ],
        order: [['id', 'ASC']]
    });

    const assignmentIds = assignments.map(item => item.id);
    const assessmentIds = assignments.map(item => item.assessmentId);

    const submissions = assignmentIds.length
        ? await Submission.findAll({
              where: { enrollmentId: enrollment.id, assignmentId: assignmentIds },
              attributes: ['assignmentId'],
              raw: true
          })
        : [];

    const scores = assessmentIds.length
        ? await AssessmentScore.findAll({
              where: { enrollmentId: enrollment.id, assessmentId: assessmentIds },
              attributes: ['assessmentId', 'score'],
              raw: true
          })
        : [];

    const submitted = new Set(submissions.map(row => Number(row.assignmentId)));
    const scoreByAssessment = new Map(
        scores.map(row => [Number(row.assessmentId), row.score])
    );

    return {
        id: Number(enrollment.student.id),
        fullName: enrollment.student.fullName,
        studentNumber: enrollment.student.studentId,
        assignments: assignments.map(item => {
            const rawScore = scoreByAssessment.get(Number(item.assessmentId));
            const percent =
                rawScore === undefined
                    ? null
                    : toPercent(rawScore, item.assessment.maxScore);

            return {
                id: Number(item.id),
                title: item.assessment.title,
                status: submitted.has(Number(item.id))
                    ? 'Completed'
                    : 'Not Completed',
                grade: percent === null ? null : round(percent)
            };
        })
    };
}

/* ------------------------------------------------------------------ */
/* Student feedback (needs the student_feedback table, see API_SPEC)   */
/* ------------------------------------------------------------------ */

const FEEDBACK_STATUS = {
    new: 'New',
    reviewed: 'Reviewed',
    resolved: 'Resolved'
};

export async function getFeedback(lecturerId) {
    try {
        const rows = await sequelize.query(
            `SELECT f.id,
                    s.id AS studentId,
                    s.full_name AS studentName,
                    c.id AS classId,
                    co.course_name AS subject,
                    f.message,
                    f.created_at AS createdAt,
                    f.status
               FROM student_feedback f
               JOIN enrollments e ON e.id = f.enrollment_id
               JOIN students s ON s.id = e.student_id
               JOIN classes c ON c.id = e.class_id
               JOIN courses co ON co.id = c.course_id
              WHERE c.lecturer_id = :lecturerId
              ORDER BY f.created_at DESC`,
            { replacements: { lecturerId }, type: QueryTypes.SELECT }
        );

        return rows.map(row => ({
            id: Number(row.id),
            studentId: Number(row.studentId),
            studentName: row.studentName,
            classId: Number(row.classId),
            subject: row.subject,
            message: row.message,
            createdAt: new Date(row.createdAt).toISOString(),
            status: FEEDBACK_STATUS[row.status] ?? 'New'
        }));
    } catch (error) {
        // Table not created yet: behave as "no feedback" instead of a 500
        if (error?.original?.code === 'ER_NO_SUCH_TABLE') return [];
        throw error;
    }
}