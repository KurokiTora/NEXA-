import {
    Lecturer,
    Class,
    AttendanceSession,
    Enrollment,
    AttendanceRecord
} from '../models/index.js';

import sequelize from '../config/database.js';

const VALID_STATUSES = [
    'present',
    'late',
    'absent',
    'excused'
];

export async function saveAttendanceRecords(
    userId,
    classId,
    sessionId,
    records
) {
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

    // Verify that the session belongs to this class.
    const session = await AttendanceSession.findOne({
        where: {
            id: sessionId,
            classId: classRecord.id
        }
    });

    if (!session) {
        return null;
    }

    // Validate attendance statuses.
    for (const record of records) {
        if (!VALID_STATUSES.includes(record.status)) {
            throw new Error(
                `Invalid attendance status: ${record.status}.`
            );
        }
    }

    // Verify that all enrollments belong to this class.
    const enrollmentIds = records.map(
        record => record.enrollmentId
    );

    const enrollments = await Enrollment.findAll({
        where: {
            id: enrollmentIds,
            classId: classRecord.id
        },
        attributes: ['id']
    });

    if (enrollments.length !== enrollmentIds.length) {
        throw new Error(
            'One or more enrollments do not belong to this class.'
        );
    }

    // Save all attendance records in one transaction.
    return await sequelize.transaction(async transaction => {
        const results = [];

        for (const record of records) {
            const [attendance, created] =
                await AttendanceRecord.findOrCreate({
                    where: {
                        attendanceSessionId: session.id,
                        enrollmentId: record.enrollmentId
                    },
                    defaults: {
                        status: record.status,
                        recordedAt: new Date()
                    },
                    transaction
                });

            if (!created) {
                await attendance.update({
                    status: record.status,
                    recordedAt: new Date()
                }, {
                    transaction
                });
            }

            results.push({
                enrollmentId: record.enrollmentId,
                status: attendance.status,
                recordedAt: attendance.recordedAt
            });
        }

        return {
            sessionId: session.id,
            records: results
        };
    });
}