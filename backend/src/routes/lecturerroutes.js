import { Router } from 'express';

import { authenticate } from '../middleware/authenticate.js';
import { authorize } from '../middleware/authorize.js';

import {
    findLecturerByUserId,
    getDashboard,
    getClasses,
    getClassDetail,
    getStudentDetail,
    getFeedback
} from '../services/lecturerservice.js';

const router = Router();

/* ------------------------------------------------------------------ */
/* Helpers                                                             */
/* ------------------------------------------------------------------ */

function ok(res, data, message = 'OK') {
    return res.status(200).json({ success: true, message, data });
}

function fail(res, status, message) {
    return res.status(status).json({ success: false, message, data: null });
}

function parseId(value) {
    const id = Number(value);
    return Number.isInteger(id) && id > 0 ? id : null;
}

// Wraps an async handler so every error becomes a clean 500 response
function handle(fn) {
    return async (req, res) => {
        try {
            await fn(req, res);
        } catch (error) {
            console.error('Lecturer route error:', error);
            fail(res, 500, 'Unable to process the request.');
        }
    };
}

/* ------------------------------------------------------------------ */
/* Access control: every route below is lecturer-only                  */
/* ------------------------------------------------------------------ */

router.use(authenticate, authorize('lecturer'));

// Resolve the lecturer profile once; JWT "sub" is users.id, not lecturers.id
router.use(async (req, res, next) => {
    try {
        const lecturer = await findLecturerByUserId(req.user.id);

        if (!lecturer) {
            return fail(res, 403, 'Lecturer profile not found.');
        }

        req.lecturer = lecturer;
        next();
    } catch (error) {
        console.error('Lecturer lookup error:', error);
        fail(res, 500, 'Unable to process the request.');
    }
});

/* ------------------------------------------------------------------ */
/* Routes                                                              */
/* ------------------------------------------------------------------ */

// GET /api/lecturer/dashboard
router.get(
    '/dashboard',
    handle(async (req, res) => {
        ok(res, await getDashboard(req.lecturer.id));
    })
);

// GET /api/lecturer/classes
router.get(
    '/classes',
    handle(async (req, res) => {
        ok(res, await getClasses(req.lecturer.id));
    })
);

// GET /api/lecturer/classes/:classId
router.get(
    '/classes/:classId',
    handle(async (req, res) => {
        const classId = parseId(req.params.classId);

        if (!classId) return fail(res, 400, 'Invalid class id.');

        const data = await getClassDetail(req.lecturer.id, classId);

        if (!data) return fail(res, 404, 'Class not found.');

        ok(res, data);
    })
);

// GET /api/lecturer/classes/:classId/students/:studentId
router.get(
    '/classes/:classId/students/:studentId',
    handle(async (req, res) => {
        const classId = parseId(req.params.classId);
        const studentId = parseId(req.params.studentId);

        if (!classId || !studentId) {
            return fail(res, 400, 'Invalid class or student id.');
        }

        const data = await getStudentDetail(
            req.lecturer.id,
            classId,
            studentId
        );

        if (!data) return fail(res, 404, 'Student not found in this class.');

        ok(res, data);
    })
);

// GET /api/lecturer/feedback
router.get(
    '/feedback',
    handle(async (req, res) => {
        ok(res, await getFeedback(req.lecturer.id));
    })
);

export default router;