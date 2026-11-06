import {
    Lecturer,
    Class,
    AttendanceSession,
    AttendanceRecord,
    Enrollment,
    Student
} from '../models/index.js';

export async function getLecturerClassAttendance(userId, classId) {
    // Find the lecturer's profile.
    const lecturer = await Lecturer.findOne({
        where: { userId }
    });

    if (!lecturer) {
        throw new Error('Lecturer profile not found.');
    }

    // Verify class ownership.
    const classRecord = await Class.findOne({
        where: {
            id: classId,
            lecturerId: lecturer.id
        }
    });

    if (!classRecord) {
        return null;
    }

    // Retrieve all attendance sessions for this class.
    const sessions = await AttendanceSession.findAll({
        where: {
            classId: classRecord.id
        },
        attributes: [
            'id',
            'sessionDate'
        ],
        order: [['sessionDate', 'ASC']]
    });

    if (sessions.length === 0) {
        return [];
    }

    // Retrieve all enrollments and their student profiles.
    const enrollments = await Enrollment.findAll({
        where: {
            classId: classRecord.id
        },
        attributes: [
            'id',
            'studentId',
            'status'
        ],
        include: [
            {
                model: Student,
                attributes: [
                    'id',
                    'studentId',
                    'fullName'
                ],
                required: true
            }
        ]
    });

    // Retrieve attendance records for these sessions.
    const sessionIds = sessions.map(session => session.id);

    const records = await AttendanceRecord.findAll({
        where: {
            attendanceSessionId: sessionIds
        },
        attributes: [
            'id',
            'attendanceSessionId',
            'enrollmentId',
            'status',
            'recordedAt'
        ],
        raw: true
    });

    // Index attendance records by session and enrollment.
    const recordMap = new Map();

    for (const record of records) {
        const key = `${record.attendanceSessionId}-${record.enrollmentId}`;
        recordMap.set(key, record);
    }

    // Combine sessions, students, and attendance records.
    return sessions.map(session => {
        const sessionData = session.toJSON();

        const students = enrollments.map(enrollment => {
            const enrollmentData = enrollment.toJSON();

            const key = `${sessionData.id}-${enrollmentData.id}`;
            const attendance = recordMap.get(key);

            return {
                enrollmentId: enrollmentData.id,
                enrollmentStatus: enrollmentData.status,

                student: {
                    id: enrollmentData.Student.id,
                    studentId: enrollmentData.Student.studentId,
                    fullName: enrollmentData.Student.fullName
                },

                attendance: attendance
                    ? {
                        recordId: attendance.id,
                        status: attendance.status,
                        recordedAt: attendance.recordedAt
                    }
                    : null
            };
        });

        return {
            sessionId: sessionData.id,
            sessionDate: sessionData.sessionDate,
            students
        };
    });
}