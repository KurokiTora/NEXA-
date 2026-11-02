import {
    Student,
    Enrollment,
    Class,
    Course,
    AcademicPeriod,
    CourseResult,
    GradingConfiguration,
    AttendanceSession,
    AttendanceRecord,
    Assessment,
    Assignment,
    Submission
} from '../models/index.js';

import {
    calculateAttendancePercentage
} from './attendanceservice.js';

/**
 * Retrieves academic information for the authenticated student.
 *
 * All attendance and assignment records are restricted
 * to the student's own enrollment.
 */
export async function getStudentAcademicOverview(userId) {
    // 1. Validate authenticated user.
    if (!userId) {
        throw new Error('Authenticated user ID is required.');
    }

    // 2. Find student profile.
    const student = await Student.findOne({
        where: { userId },
        attributes: [
            'id',
            'studentId',
            'fullName'
        ]
    });

    if (!student) {
        throw new Error('Student profile not found.');
    }

    // 3. Retrieve student enrollments and course results.
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

    // 4. Retrieve attendance and assignment data
    // separately for each enrollment.
    const courses = await Promise.all(
        enrollments.map(async enrollment => {
            const item = enrollment.get({
                plain: true
            });

            const classData = item.class;
            const course = classData?.course;
            const academicPeriod = classData?.academicPeriod;

            // IMPORTANT:
            // Use enrollment.id, not student.id.
            const enrollmentId = item.id;

            // 5. Retrieve attendance sessions.
            const attendanceSessions =
                await AttendanceSession.findAll({
                    where: {
                        classId: item.classId
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
                                'status',
                                'recordedAt'
                            ],
                            where: {
                                enrollmentId
                            },
                            required: false
                        }
                    ],
                    order: [
                        ['sessionDate', 'ASC']
                    ]
                });

            // 6. Format attendance information.
            const attendanceDetails = attendanceSessions.map(
                session => {
                    const sessionData = session.get({
                        plain: true
                    });

                    const record =
                        sessionData.attendanceRecords?.[0] ?? null;

                    return {
                        sessionDate: sessionData.sessionDate,
                        status: record?.status ?? 'not_recorded',
                        recordedAt: record?.recordedAt ?? null
                    };
                }
            );

            // 7. Calculate attendance using recorded statuses only.
            const attendanceStatuses = attendanceDetails
                .map(session => session.status)
                .filter(status => status !== 'not_recorded');

            const attendancePercentage =
                attendanceStatuses.length > 0
                    ? calculateAttendancePercentage(
                        attendanceStatuses
                    )
                    : null;

            // 8. Build attendance summary.
            const attendanceSummary = {
                totalSessions: attendanceDetails.length,
                recordedSessions: attendanceStatuses.length,

                present: attendanceStatuses.filter(
                    status => status === 'present'
                ).length,

                late: attendanceStatuses.filter(
                    status => status === 'late'
                ).length,

                absent: attendanceStatuses.filter(
                    status => status === 'absent'
                ).length,

                excused: attendanceStatuses.filter(
                    status => status === 'excused'
                ).length,

                notRecorded: attendanceDetails.filter(
                    session => session.status === 'not_recorded'
                ).length,

                attendancePercentage
            };

            // 9. Retrieve assignment assessments.
            const assignmentAssessments =
                await Assessment.findAll({
                    where: {
                        classId: item.classId,
                        type: 'assignment'
                    },
                    attributes: [
                        'id',
                        'title',
                        'description',
                        'maxScore',
                        'dueAt'
                    ],
                    include: [
                        {
                            model: Assignment,
                            as: 'assignment',
                            attributes: [
                                'id'
                            ],
                            required: false,
                            include: [
                                {
                                    model: Submission,
                                    as: 'submissions',
                                    attributes: [
                                        'id',
                                        'submittedAt'
                                    ],
                                    where: {
                                        enrollmentId
                                    },
                                    required: false
                                }
                            ]
                        }
                    ],
                    order: [
                        ['dueAt', 'ASC']
                    ]
                });

            // 10. Format assignment information.
            const assignments = assignmentAssessments.map(
                assessment => {
                    const assessmentData = assessment.get({
                        plain: true
                    });

                    const assignment =
                        assessmentData.assignment;

                    const submission =
                        assignment?.submissions?.[0] ?? null;

                    let submissionStatus;

                    if (!assignment) {
                        submissionStatus = 'not_configured';
                    } else if (submission) {
                        submissionStatus = 'submitted';
                    } else {
                        submissionStatus = 'not_submitted';
                    }

                    return {
                        assessmentId: assessmentData.id,
                        assignmentId: assignment?.id ?? null,
                        title: assessmentData.title,
                        description: assessmentData.description,
                        maxScore: assessmentData.maxScore,
                        dueAt: assessmentData.dueAt,
                        submissionStatus,
                        submittedAt:
                            submission?.submittedAt ?? null
                    };
                }
            );

            // 11. Format course results.
            const results = (
                item.courseResults ?? []
            ).map(result => ({
                finalScore: result.finalScore,
                gradePoint: result.gradePoint,
                gradingVersion:
                    result.gradingConfiguration?.version ?? null,
                calculatedAt: result.calculatedAt
            }));

            return {
                enrollmentId,
                enrollmentStatus: item.status,
                enrolledAt: item.enrolledAt,

                classCode: classData?.classCode ?? null,

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

                results,

                attendance: {
                    summary: attendanceSummary,
                    sessions: attendanceDetails
                },

                assignments
            };
        })
    );

    // 12. Summarize enrollment statuses.
    const summary = {
        totalCourses: courses.length,

        activeCourses: courses.filter(
            course => course.enrollmentStatus === 'active'
        ).length,

        completedCourses: courses.filter(
            course => course.enrollmentStatus === 'completed'
        ).length,

        droppedCourses: courses.filter(
            course => course.enrollmentStatus === 'dropped'
        ).length
    };

    // 13. Return academic overview.
    return {
        student: {
            studentId: student.studentId,
            fullName: student.fullName
        },

        summary,

        courses
    };
}