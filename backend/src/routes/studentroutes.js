import { Router } from 'express';

import { authenticate } from '../middleware/authenticate.js';
import { authorize } from '../middleware/authorize.js';

const router = Router();

// All student endpoints require authentication and student role.
router.use(authenticate, authorize('student'));

router.get('/dashboard', (req, res) => {
    res.status(200).json({
        success: true,
        message: 'Student dashboard access granted.',
        data: {
            studentId: req.user.id
        }
    });
});

export default router;