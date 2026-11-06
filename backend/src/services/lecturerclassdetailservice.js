import {
    Lecturer,
    Class,
    Course,
    AcademicPeriod,
    Enrollment
} from '../models/index.js';

export async function getLecturerClassDetail(userId, classId) {
    // Find the lecturer's profile.
    const lecturer = await Lecturer.findOne({
        where: { userId }
    });

    if (!lecturer) {
        throw new Error('Lecturer profile not found.');
    }

    // Only retrieve a class assigned to this lecturer.
    const classRecord = await Class.findOne({
        where: {
            id: classId,
            lecturerId: lecturer.id
        },
        attributes: [
            'id',
            'classCode',
            'joinCode',
            'courseId',
            'academicPeriodId'
        ],
        include: [
            {
                model: Course,
                as: 'course',
                attributes: [
                    'id',
                    'courseCode',
                    'courseName',
                    'credits'
                ],
                required: true
            },
            {
                model: AcademicPeriod,
                as: 'academicPeriod',
                attributes: [
                    'id',
                    'academicYear',
                    'semester'
                ],
                required: true
            }
        ]
    });

    if (!classRecord) {
        return null;
    }

    // Count active students enrolled in this class.
    const studentCount = await Enrollment.count({
        where: {
            classId: classRecord.id,
            status: 'active'
        },
        distinct: true,
        col: 'studentId'
    });

    const data = classRecord.toJSON();

    return {
        id: data.id,
        classCode: data.classCode,
        joinCode: data.joinCode,
        course: data.course,
        academicPeriod: data.academicPeriod,
        studentCount
    };
}