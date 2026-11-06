import {
    Lecturer,
    Class,
    AttendanceSession
} from '../models/index.js';

export async function createAttendanceSession(
    userId,
    classId,
    sessionDate
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

    // Check whether a session already exists for this date.
    const existingSession = await AttendanceSession.findOne({
        where: {
            classId: classRecord.id,
            sessionDate
        }
    });

    if (existingSession) {
        throw new Error(
            'An attendance session already exists for this date.'
        );
    }

    // Create the attendance session.
    const session = await AttendanceSession.create({
        classId: classRecord.id,
        sessionDate
    });

    return {
        sessionId: session.id,
        classId: session.classId,
        sessionDate: session.sessionDate
    };
}