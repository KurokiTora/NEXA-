
import { Op } from 'sequelize';

import {
    Lecturer,
    Class,
    Course,
    AcademicPeriod,
    Enrollment,
    Student,
    Assessment,
    AssessmentScore,
    AttendanceSession,
    AttendanceRecord,
    CourseResult,
    GradingConfiguration
} from '../models/index.js';

/**
 * Retrieves academic information for an authenticated lecturer.
 *
 * Security:
 * - Classes are restricted to the authenticated lecturer.
 * - Students are restricted to enrollments in each lecturer's class.
 * - Assessment scores are restricted to the class enrollments.
 * - Attendance records are restricted to the class enrollments.
 *
 * All database operations are read-only.
 */
export async function getLecturerAcademicOverview(userId) {
    // 1. Validate authenticated user.
    if (!userId) {
        throw new Error('Authenticated user ID is required.');
    }

    // 2. Find lecturer profile using authenticated user ID.
    const lecturer = await Lecturer.findOne({
        where: { userId },
        attributes: ['id', 'lecturerId', 'fullName']
    });

    if (!lecturer) {
        throw new Error('Lecturer profile not found.');
    }

    // 3. Retrieve only classes assigned to this lecturer.
    const classes = await Class.findAll({
        where: {
            lecturerId: lecturer.id
        },
        attributes: ['id', 'classCode'],
        include: [
            {
                model: Course,
                as: 'course',
                attributes: [
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
            },
            {
                model: Enrollment,
                as: 'enrollments',
                attributes: [
                    'id',
                    'status',
                    'enrolledAt'
                ],
                required: false,
                include: [
                    {
                        model: Student,
                        as: 'student',
                        attributes: [
                            'id',
                            'studentId',
                            'fullName'
                        ],
                        required: true
                    },
                    {
                        model: CourseResult,
                        as: 'courseResults',
                        attributes: [
                            'finalScore',
                            'gradePoint',
                            'calculatedAt'
                        ],
                        required: false,
                        include: [
                            {
                                model: GradingConfiguration,
                                as: 'gradingConfiguration',
                                attributes: ['version'],
                                required: false
                            }
                        ]
                    }
                ]
            }
        ],
        order: [['id', 'ASC']]
    });

    // 4. Process each class independently.
    const formattedClasses = await Promise.all(
        classes.map(async classInstance => {
            const item = classInstance.get({
                plain: true
            });

            const enrollments = item.enrollments ?? [];

            // Only enrollment IDs belonging to this class.
            const enrollmentIds = enrollments.map(
                enrollment => enrollment.id
            );

            const enrollmentFilter = {
                enrollmentId: {
                    [Op.in]: enrollmentIds
                }
            };

            // 5. Retrieve assessments and scores.
            // Scores are restricted to enrollments in this class.
            const assessmentRecords = await Assessment.findAll({
                where: {
                    classId: item.id
                },
                attributes: [
                    'id',
                    'title',
                    'description',
                    'type',
                    'maxScore',
                    'dueAt'
                ],
                include: [
                    {
                        model: AssessmentScore,
                        as: 'scores',
                        attributes: [
                            'score',
                            'feedback',
                            'gradedAt',
                            'enrollmentId'
                        ],
                        where: enrollmentFilter,
                        required: false
                    }
                ],
                order: [['id', 'ASC']]
            });

            // 6. Retrieve attendance sessions and records.
            // Attendance records are restricted to enrollments
            // belonging to this specific class.
            const attendanceRecords = await AttendanceSession.findAll({
                where: {
                    classId: item.id
                },
                attributes: [
                    'id',
                    'sessionDate'
                ],
                include: [
                    {
                        model: AttendanceRecord,
                        as: 'attendanceRecords',
                        attributes: [
                            'enrollmentId',
                            'status',
                            'recordedAt'
                        ],
                        where: enrollmentFilter,
                        required: false
                    }
                ],
                order: [['sessionDate', 'ASC']]
            });

            // 7. Format student information.
            const students = enrollments.map(enrollment => ({
                enrollmentId: enrollment.id,
                enrollmentStatus: enrollment.status,
                enrolledAt: enrollment.enrolledAt,

                student: enrollment.student
                    ? {
                        studentId: enrollment.student.studentId,
                        fullName: enrollment.student.fullName
                    }
                    : null,

                results: (
                    enrollment.courseResults ?? []
                ).map(result => ({
                    finalScore: result.finalScore,
                    gradePoint: result.gradePoint,
                    gradingVersion:
                        result.gradingConfiguration?.version ?? null,
                    calculatedAt: result.calculatedAt
                }))
            }));

            // 8. Format assessment information.
            const assessments = assessmentRecords.map(
                assessment => {
                    const data = assessment.get({
                        plain: true
                    });

                    return {
                        id: data.id,
                        title: data.title,
                        description: data.description,
                        type: data.type,
                        maxScore: data.maxScore,
                        dueAt: data.dueAt,

                        scores: (data.scores ?? []).map(score => ({
                            enrollmentId: score.enrollmentId,
                            score: score.score,
                            feedback: score.feedback,
                            gradedAt: score.gradedAt
                        }))
                    };
                }
            );

            // 9. Format attendance information.
            const attendanceSessions = attendanceRecords.map(
                session => {
                    const data = session.get({
                        plain: true
                    });

                    return {
                        sessionDate: data.sessionDate,

                        records: (
                            data.attendanceRecords ?? []
                        ).map(record => ({
                            enrollmentId: record.enrollmentId,
                            status: record.status,
                            recordedAt: record.recordedAt
                        }))
                    };
                }
            );

            // 10. Calculate class student summary.
            const activeStudents = students.filter(
                student => student.enrollmentStatus === 'active'
            );

            const studentSummary = {
                totalStudents: students.length,

                activeStudents: activeStudents.length,

                completedStudents: students.filter(
                    student => student.enrollmentStatus === 'completed'
                ).length,

                droppedStudents: students.filter(
                    student => student.enrollmentStatus === 'dropped'
                ).length
            };

            // 11. Return class information.
            return {
                classId: item.id,
                classCode: item.classCode,

                course: item.course
                    ? {
                        courseCode: item.course.courseCode,
                        courseName: item.course.courseName,
                        credits: item.course.credits
                    }
                    : null,

                academicPeriod: item.academicPeriod
                    ? {
                        academicYear: item.academicPeriod.academicYear,
                        semester: item.academicPeriod.semester,
                        startDate: item.academicPeriod.startDate,
                        endDate: item.academicPeriod.endDate
                    }
                    : null,

                studentSummary,
                students,
                assessments,
                attendanceSessions
            };
        })
    );

    // 12. Calculate unique student totals across all classes.
    const allStudents = formattedClasses.flatMap(
        classItem => classItem.students
    );

    const uniqueStudentIds = new Set(
        allStudents
            .map(student => student.student?.studentId)
            .filter(Boolean)
    );

    const activeStudentIds = new Set(
        allStudents
            .filter(student => student.enrollmentStatus === 'active')
            .map(student => student.student?.studentId)
            .filter(Boolean)
    );

    const summary = {
        totalClasses: formattedClasses.length,
        totalStudents: uniqueStudentIds.size,
        totalActiveStudents: activeStudentIds.size
    };

    // 13. Return lecturer academic overview.
    return {
        lecturer: {
            lecturerId: lecturer.lecturerId,
            fullName: lecturer.fullName
        },

        summary,
        classes: formattedClasses
    };
}
