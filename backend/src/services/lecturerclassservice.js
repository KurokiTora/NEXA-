import {
    Lecturer,
    Class,
    Course,
    AcademicPeriod,
    Enrollment
} from '../models/index.js';

export async function getLecturerClasses(userId) {
    // 1. Find lecturer profile
    const lecturer = await Lecturer.findOne({
        where: { userId }
    });

    if (!lecturer) {
        throw new Error('Lecturer profile not found.');
    }

    // 2. Retrieve lecturer's classes with course and academic period
    const classes = await Class.findAll({
        where: {
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
                attributes: ['id', 'courseCode', 'courseName', 'credits'],
                required: true
            },
            {
                model: AcademicPeriod,
                as: 'academicPeriod',
                attributes: ['id', 'academicYear', 'semester'],
                required: true
            }
        ],
        order: [['id', 'ASC']]
    });

    if (classes.length === 0) {
        return [];
    }

    // 3. Retrieve active enrollments for these classes
    const classIds = classes.map(item => item.id);

    const enrollments = await Enrollment.findAll({
        where: {
            classId: classIds,
            status: 'active'
        },
        attributes: ['classId', 'studentId'],
        raw: true
    });

    // 4. Count distinct students in each class
    const studentCounts = new Map();

    for (const enrollment of enrollments) {
        const classId = String(enrollment.classId);
        const studentId = String(enrollment.studentId);

        if (!studentCounts.has(classId)) {
            studentCounts.set(classId, new Set());
        }

        studentCounts.get(classId).add(studentId);
    }

    // 5. Format response for frontend
    return classes.map(item => {
        const classData = item.toJSON();

        return {
            id: classData.id,
            classCode: classData.classCode,
            joinCode: classData.joinCode,
            course: classData.course,
            academicPeriod: classData.academicPeriod,
            studentCount:
                studentCounts.get(String(classData.id))?.size || 0
        };
    });
}