import {
    Lecturer,
    Class,
    Enrollment,
    Student
} from '../models/index.js';

export async function getLecturerClassStudents(userId, classId) {
    // Find the lecturer's profile.
    const lecturer = await Lecturer.findOne({
        where: { userId }
    });

    if (!lecturer) {
        throw new Error('Lecturer profile not found.');
    }

    // Verify that this class belongs to the lecturer.
    const classRecord = await Class.findOne({
        where: {
            id: classId,
            lecturerId: lecturer.id
        }
    });

    if (!classRecord) {
        return null;
    }

    // Retrieve active enrollments and their student profiles.
    const enrollments = await Enrollment.findAll({
        where: {
            classId: classRecord.id,
            status: 'active'
        },
        attributes: [
            'id',
            'studentId',
            'status',
            'enrolledAt'
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
        ],
        order: [['id', 'ASC']]
    });

    return enrollments.map(enrollment => {
        const data = enrollment.toJSON();

        return {
            enrollmentId: data.id,
            status: data.status,
            enrolledAt: data.enrolledAt,
            student: {
                id: data.Student.id,
                studentId: data.Student.studentId,
                fullName: data.Student.fullName
            }
        };
    });
}