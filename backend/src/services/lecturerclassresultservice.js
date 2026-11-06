import {
    Lecturer,
    Class,
    Enrollment,
    Student,
    CourseResult
} from '../models/index.js';

export async function getLecturerClassResults(userId, classId) {
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

    // Retrieve active and completed enrollments.
    const enrollments = await Enrollment.findAll({
        where: {
            classId: classRecord.id,
            status: ['active', 'completed']
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
        ],
        order: [['id', 'ASC']]
    });

    if (enrollments.length === 0) {
        return [];
    }

    // Retrieve calculated course results.
    const enrollmentIds = enrollments.map(
        enrollment => enrollment.id
    );

    const results = await CourseResult.findAll({
        where: {
            enrollmentId: enrollmentIds
        },
        attributes: [
            'id',
            'enrollmentId',
            'gradingConfigurationId',
            'finalScore',
            'gradePoint',
            'calculatedAt'
        ],
        order: [['calculatedAt', 'DESC']]
    });

    // Group results by enrollment.
    const resultMap = new Map();

    for (const result of results) {
        const key = String(result.enrollmentId);

        if (!resultMap.has(key)) {
            resultMap.set(key, []);
        }

        resultMap.get(key).push({
            resultId: result.id,
            gradingConfigurationId: result.gradingConfigurationId,
            finalScore: result.finalScore,
            gradePoint: result.gradePoint,
            calculatedAt: result.calculatedAt
        });
    }

    // Combine student information and calculated results.
    return enrollments.map(enrollment => {
        const data = enrollment.toJSON();
        const student = data.Student;

        return {
            enrollmentId: data.id,
            enrollmentStatus: data.status,

            student: {
                id: student.id,
                studentId: student.studentId,
                fullName: student.fullName
            },

            results: resultMap.get(String(data.id)) || []
        };
    });
}