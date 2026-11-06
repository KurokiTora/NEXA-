import { Router } from 'express';

import { authenticate } from '../middleware/authenticate.js';
import { authorize } from '../middleware/authorize.js';

import {
    getLecturerDashboard
} from '../services/lecturerdashboardservice.js';

import {
    getLecturerClasses
} from '../services/lecturerclassservice.js';

import {
    getLecturerClassDetail
} from '../services/lecturerclassdetailservice.js';

import {
    getLecturerClassStudents
} from '../services/lecturerclassstudentservice.js';

import {
    getLecturerClassAssessments
} from '../services/lecturerclassassessmentservice.js';

import {
    getLecturerAssessmentSubmissions
} from '../services/lecturerassessmentsubmissionservice.js';

import {
    saveAssessmentGrade
} from '../services/lecturergradingservice.js';

import {
    getLecturerClassAttendance
} from '../services/lecturerattendanceservice.js';

import {
    createAttendanceSession
} from '../services/lecturerattendancesessionservice.js';

import {
    saveAttendanceRecords
} from '../services/lecturerattendancerecordservice.js';

import {
    getLecturerClassResults
} from '../services/lecturerclassresultservice.js';

const router = Router();

// Protect all lecturer endpoints
router.use(authenticate, authorize('lecturer'));

// Lecturer dashboard
router.get('/dashboard', async (req, res) => {
    try {
        const dashboard = await getLecturerDashboard(req.user.id);

        return res.status(200).json({
            success: true,
            message: 'Lecturer dashboard retrieved successfully.',
            data: dashboard
        });

    } catch (error) {
        console.error('Lecturer dashboard error:', error);

        return res.status(
            error.message === 'Lecturer profile not found.' ? 404 : 500
        ).json({
            success: false,
            message: error.message === 'Lecturer profile not found.'
                ? error.message
                : 'Unable to retrieve lecturer dashboard.',
            data: null
        });
    }
});

// Get lecturer's classes
router.get('/classes', async (req, res) => {
    try {
        const classes = await getLecturerClasses(req.user.id);

        return res.status(200).json({
            success: true,
            message: 'Classes retrieved successfully.',
            data: classes
        });

    } catch (error) {
        console.error('Lecturer classes error:', error);

        return res.status(
            error.message === 'Lecturer profile not found.' ? 404 : 500
        ).json({
            success: false,
            message: error.message === 'Lecturer profile not found.'
                ? error.message
                : 'Unable to retrieve lecturer classes.',
            data: null
        });
    }
});

router.get('/classes/:classId', async (req, res) => {
    try {
        const classId = Number(req.params.classId);

        if (!Number.isInteger(classId) || classId <= 0) {
            return res.status(400).json({
                success: false,
                message: 'Invalid class ID.',
                data: null
            });
        }

        const classDetail = await getLecturerClassDetail(
            req.user.id,
            classId
        );

        if (!classDetail) {
            return res.status(404).json({
                success: false,
                message: 'Class not found.',
                data: null
            });
        }

        return res.status(200).json({
            success: true,
            message: 'Class details retrieved successfully.',
            data: classDetail
        });

    } catch (error) {
        console.error('Lecturer class detail error:', error);

        return res.status(
            error.message === 'Lecturer profile not found.' ? 404 : 500
        ).json({
            success: false,
            message: error.message === 'Lecturer profile not found.'
                ? error.message
                : 'Unable to retrieve class details.',
            data: null
        });
    }
});

router.get('/classes/:classId/students', async (req, res) => {
    try {
        const classId = Number(req.params.classId);

        if (!Number.isInteger(classId) || classId <= 0) {
            return res.status(400).json({
                success: false,
                message: 'Invalid class ID.',
                data: null
            });
        }

        const students = await getLecturerClassStudents(
            req.user.id,
            classId
        );

        if (students === null) {
            return res.status(404).json({
                success: false,
                message: 'Class not found.',
                data: null
            });
        }

        return res.status(200).json({
            success: true,
            message: 'Class students retrieved successfully.',
            data: students
        });

    } catch (error) {
        console.error('Lecturer class students error:', error);

        return res.status(
            error.message === 'Lecturer profile not found.' ? 404 : 500
        ).json({
            success: false,
            message: error.message === 'Lecturer profile not found.'
                ? error.message
                : 'Unable to retrieve class students.',
            data: null
        });
    }
});

router.get('/classes/:classId/assessments', async (req, res) => {
    try {
        const classId = Number(req.params.classId);

        if (!Number.isInteger(classId) || classId <= 0) {
            return res.status(400).json({
                success: false,
                message: 'Invalid class ID.',
                data: null
            });
        }

        const assessments = await getLecturerClassAssessments(
            req.user.id,
            classId
        );

        if (assessments === null) {
            return res.status(404).json({
                success: false,
                message: 'Class not found.',
                data: null
            });
        }

        return res.status(200).json({
            success: true,
            message: 'Class assessments retrieved successfully.',
            data: assessments
        });

    } catch (error) {
        console.error('Lecturer class assessments error:', error);

        return res.status(
            error.message === 'Lecturer profile not found.' ? 404 : 500
        ).json({
            success: false,
            message: error.message === 'Lecturer profile not found.'
                ? error.message
                : 'Unable to retrieve class assessments.',
            data: null
        });
    }
});

router.get(
    '/classes/:classId/assessments/:assessmentId/submissions',
    async (req, res) => {
        try {
            const classId = Number(req.params.classId);
            const assessmentId = Number(req.params.assessmentId);

            if (
                !Number.isInteger(classId) ||
                classId <= 0 ||
                !Number.isInteger(assessmentId) ||
                assessmentId <= 0
            ) {
                return res.status(400).json({
                    success: false,
                    message: 'Invalid class ID or assessment ID.',
                    data: null
                });
            }

            const submissions = await getLecturerAssessmentSubmissions(
                req.user.id,
                classId,
                assessmentId
            );

            if (submissions === null) {
                return res.status(404).json({
                    success: false,
                    message: 'Class or assessment not found.',
                    data: null
                });
            }

            return res.status(200).json({
                success: true,
                message: 'Assessment submissions retrieved successfully.',
                data: submissions
            });

        } catch (error) {
            console.error('Assessment submissions error:', error);

            const isProfileError =
                error.message === 'Lecturer profile not found.';

            const isAssignmentError =
                error.message === 'This assessment does not have an assignment.';

            return res.status(
                isProfileError ? 404 :
                isAssignmentError ? 400 : 500
            ).json({
                success: false,
                message: isProfileError || isAssignmentError
                    ? error.message
                    : 'Unable to retrieve assessment submissions.',
                data: null
            });
        }
    }
);

router.put(
    '/classes/:classId/assessments/:assessmentId/students/:studentId/grade',
    async (req, res) => {
        try {
            const classId = Number(req.params.classId);
            const assessmentId = Number(req.params.assessmentId);
            const studentId = Number(req.params.studentId);

            const { score, feedback } = req.body;

            if (
                !Number.isInteger(classId) || classId <= 0 ||
                !Number.isInteger(assessmentId) || assessmentId <= 0 ||
                !Number.isInteger(studentId) || studentId <= 0
            ) {
                return res.status(400).json({
                    success: false,
                    message: 'Invalid class, assessment, or student ID.',
                    data: null
                });
            }

            if (
                typeof score !== 'number' ||
                !Number.isFinite(score)
            ) {
                return res.status(400).json({
                    success: false,
                    message: 'Score must be a valid number.',
                    data: null
                });
            }

            if (
                feedback !== undefined &&
                feedback !== null &&
                typeof feedback !== 'string'
            ) {
                return res.status(400).json({
                    success: false,
                    message: 'Feedback must be a string or null.',
                    data: null
                });
            }

            const result = await saveAssessmentGrade(
                req.user.id,
                classId,
                assessmentId,
                studentId,
                score,
                feedback
            );

            if (!result) {
                return res.status(404).json({
                    success: false,
                    message: 'Class or assessment not found.',
                    data: null
                });
            }

            return res.status(200).json({
                success: true,
                message: 'Assessment grade saved successfully.',
                data: result
            });

        } catch (error) {
            console.error('Assessment grading error:', error);

            const isProfileError =
                error.message === 'Lecturer profile not found.';

            const isEnrollmentError =
                error.message === 'Active student enrollment not found.';

            const isScoreError =
                error.message.startsWith('Score must be between');

            return res.status(
                isProfileError ? 404 :
                isEnrollmentError ? 404 :
                isScoreError ? 400 : 500
            ).json({
                success: false,
                message:
                    isProfileError ||
                    isEnrollmentError ||
                    isScoreError
                        ? error.message
                        : 'Unable to save assessment grade.',
                data: null
            });
        }
    }
);

router.get('/classes/:classId/attendance', async (req, res) => {
    try {
        const classId = Number(req.params.classId);

        if (!Number.isInteger(classId) || classId <= 0) {
            return res.status(400).json({
                success: false,
                message: 'Invalid class ID.',
                data: null
            });
        }

        const attendance = await getLecturerClassAttendance(
            req.user.id,
            classId
        );

        if (attendance === null) {
            return res.status(404).json({
                success: false,
                message: 'Class not found.',
                data: null
            });
        }

        return res.status(200).json({
            success: true,
            message: 'Class attendance retrieved successfully.',
            data: attendance
        });

    } catch (error) {
        console.error('Lecturer attendance error:', error);

        const isProfileError =
            error.message === 'Lecturer profile not found.';

        return res.status(isProfileError ? 404 : 500).json({
            success: false,
            message: isProfileError
                ? error.message
                : 'Unable to retrieve class attendance.',
            data: null
        });
    }
});

router.post(
    '/classes/:classId/attendance/sessions',
    async (req, res) => {
        try {
            const classId = Number(req.params.classId);
            const { sessionDate } = req.body;

            if (!Number.isInteger(classId) || classId <= 0) {
                return res.status(400).json({
                    success: false,
                    message: 'Invalid class ID.',
                    data: null
                });
            }

            // Validate YYYY-MM-DD and reject impossible dates.
            const validDate =
                typeof sessionDate === 'string' &&
                /^\d{4}-\d{2}-\d{2}$/.test(sessionDate) &&
                (() => {
                    const date = new Date(
                        `${sessionDate}T00:00:00.000Z`
                    );

                    return !Number.isNaN(date.getTime()) &&
                        date.toISOString().slice(0, 10) === sessionDate;
                })();

            if (!validDate) {
                return res.status(400).json({
                    success: false,
                    message: 'A valid session date in YYYY-MM-DD format is required.',
                    data: null
                });
            }

            const result = await createAttendanceSession(
                req.user.id,
                classId,
                sessionDate
            );

            if (!result) {
                return res.status(404).json({
                    success: false,
                    message: 'Class not found.',
                    data: null
                });
            }

            return res.status(201).json({
                success: true,
                message: 'Attendance session created successfully.',
                data: result
            });

        } catch (error) {
            console.error('Attendance session creation error:', error);

            const isProfileError =
                error.message === 'Lecturer profile not found.';

            const isDuplicateError =
                error.message ===
                'An attendance session already exists for this date.';

            return res.status(
                isProfileError ? 404 :
                isDuplicateError ? 409 : 500
            ).json({
                success: false,
                message:
                    isProfileError || isDuplicateError
                        ? error.message
                        : 'Unable to create attendance session.',
                data: null
            });
        }
    }
);

router.put(
    '/classes/:classId/attendance/sessions/:sessionId',
    async (req, res) => {
        try {
            const classId = Number(req.params.classId);
            const sessionId = Number(req.params.sessionId);

            const { records } = req.body;

            if (
                !Number.isInteger(classId) || classId <= 0 ||
                !Number.isInteger(sessionId) || sessionId <= 0
            ) {
                return res.status(400).json({
                    success: false,
                    message: 'Invalid class ID or session ID.',
                    data: null
                });
            }

            if (!Array.isArray(records) || records.length === 0) {
                return res.status(400).json({
                    success: false,
                    message: 'Attendance records must be a non-empty array.',
                    data: null
                });
            }

            const enrollmentIds = records.map(
                record => record?.enrollmentId
            );

            const validRecords = records.every(record =>
                record &&
                Number.isInteger(record.enrollmentId) &&
                record.enrollmentId > 0 &&
                typeof record.status === 'string'
            );

            if (!validRecords) {
                return res.status(400).json({
                    success: false,
                    message: 'Each record must contain a valid enrollmentId and status.',
                    data: null
                });
            }

            if (new Set(enrollmentIds).size !== enrollmentIds.length) {
                return res.status(400).json({
                    success: false,
                    message: 'Duplicate enrollment IDs are not allowed.',
                    data: null
                });
            }

            const result = await saveAttendanceRecords(
                req.user.id,
                classId,
                sessionId,
                records
            );

            if (!result) {
                return res.status(404).json({
                    success: false,
                    message: 'Class or attendance session not found.',
                    data: null
                });
            }

            return res.status(200).json({
                success: true,
                message: 'Attendance records saved successfully.',
                data: result
            });

        } catch (error) {
            console.error('Attendance recording error:', error);

            const isProfileError =
                error.message === 'Lecturer profile not found.';

            const isEnrollmentError =
                error.message ===
                'One or more enrollments do not belong to this class.';

            const isStatusError =
                error.message.startsWith('Invalid attendance status:');

            return res.status(
                isProfileError ? 404 :
                isEnrollmentError ? 400 :
                isStatusError ? 400 : 500
            ).json({
                success: false,
                message:
                    isProfileError ||
                    isEnrollmentError ||
                    isStatusError
                        ? error.message
                        : 'Unable to save attendance records.',
                data: null
            });
        }
    }
);

router.get('/classes/:classId/results', async (req, res) => {
    try {
        const classId = Number(req.params.classId);

        if (!Number.isInteger(classId) || classId <= 0) {
            return res.status(400).json({
                success: false,
                message: 'Invalid class ID.',
                data: null
            });
        }

        const results = await getLecturerClassResults(
            req.user.id,
            classId
        );

        if (results === null) {
            return res.status(404).json({
                success: false,
                message: 'Class not found.',
                data: null
            });
        }

        return res.status(200).json({
            success: true,
            message: 'Class results retrieved successfully.',
            data: results
        });

    } catch (error) {
        console.error('Lecturer class results error:', error);

        const isProfileError =
            error.message === 'Lecturer profile not found.';

        return res.status(isProfileError ? 404 : 500).json({
            success: false,
            message: isProfileError
                ? error.message
                : 'Unable to retrieve class results.',
            data: null
        });
    }
});

export default router;