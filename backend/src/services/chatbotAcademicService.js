
import {
    Student,
    Enrollment,
    Class,
    Course,
    AcademicPeriod,
    CourseResult,
    GradingConfiguration
} from '../models/index.js';

/**
 * Retrieves a student's academic overview.
 *
 * Data access is restricted to the authenticated user's student profile.
 * This function performs read-only database operations.
 *
 * @param {string|number} userId - Authenticated user ID from JWT.
 * @returns {Promise<object>} Student academic overview.
 */
export async function getStudentAcademicOverview(userId) {
    // 1. Validate authenticated user ID.
    if (!userId) {
        throw new Error('Authenticated user ID is required.');
    }

    // 2. Find the student profile using the authenticated user ID.
    const student = await Student.findOne({
        where: {
            userId
        },
        attributes: [
            'id',
            'studentId',
            'fullName'
        ]
    });

    if (!student) {
        throw new Error('Student profile not found.');
    }

    // 3. Retrieve the student's course enrollments and results.
    const enrollments = await Enrollment.findAll({
        where: {
            studentId: student.id
        },
        attributes: [
            'id',
            'classId',
            'status',
            'enrolledAt'
        ],
        include: [
            {
                model: Class,
                as: 'class',
                attributes: [
                    'id',
                    'classCode',
                    'academicPeriodId'
                ],
                required: true,
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
                            'academicYear',
                            'semester',
                            'startDate',
                            'endDate'
                        ],
                        required: false
                    }
                ]
            },
            {
                model: CourseResult,
                as: 'courseResults',
                attributes: [
                    'id',
                    'gradingConfigurationId',
                    'finalScore',
                    'gradePoint',
                    'calculatedAt'
                ],
                required: false,
                include: [
                    {
                        model: GradingConfiguration,
                        as: 'gradingConfiguration',
                        attributes: [
                            'id',
                            'version'
                        ],
                        required: false
                    }
                ]
            }
        ],
        order: [
            ['id', 'ASC']
        ]
    });

    // 4. Format the academic data for chatbot consumption.
    const courses = enrollments.map(enrollment => {
        const item = enrollment.get({
            plain: true
        });

        const course = item.class?.course;
        const academicPeriod = item.class?.academicPeriod;

        return {
            enrollmentId: item.id,
            enrollmentStatus: item.status,

            enrolledAt: item.enrolledAt,

            classCode: item.class?.classCode ?? null,

            course: course
                ? {
                    courseCode: course.courseCode,
                    courseName: course.courseName,
                    credits: course.credits
                }
                : null,

            academicPeriod: academicPeriod
                ? {
                    academicYear: academicPeriod.academicYear,
                    semester: academicPeriod.semester,
                    startDate: academicPeriod.startDate,
                    endDate: academicPeriod.endDate
                }
                : null,

            results: (item.courseResults ?? []).map(result => ({
                finalScore: result.finalScore,
                gradePoint: result.gradePoint,

                gradingVersion:
                    result.gradingConfiguration?.version ?? null,

                calculatedAt: result.calculatedAt
            }))
        };
    });

    // 5. Return the student's academic overview.
    return {
        student: {
            studentId: student.studentId,
            fullName: student.fullName
        },

        totalCourses: courses.length,

        courses
    };
}
