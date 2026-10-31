import { Router } from 'express';

import { loginUser } from '../services/authservice.js';
import { authenticate } from '../middleware/authenticate.js';

import {
    User,
    Lecturer,
    Student
} from '../models/index.js';

const router = Router();

// Login
router.post('/login', async (req, res) => {
    try {
        const { email, password } = req.body;

        const result = await loginUser(email, password);

        res.status(200).json({
            success: true,
            message: 'Login successful.',
            data: result
        });

    } catch (error) {
        const isInvalidCredentials =
            error.message === 'Invalid email or password.' ||
            error.message === 'Email and password are required.';

        res.status(isInvalidCredentials ? 401 : 500).json({
            success: false,
            message: isInvalidCredentials
                ? error.message
                : 'An error occurred during login.',
            data: null
        });
    }
});

// Get authenticated user's profile
router.get('/me', authenticate, async (req, res) => {
    try {
        const user = await User.findByPk(req.user.id, {
            attributes: ['id', 'email', 'role']
        });

        if (!user) {
            return res.status(401).json({
                success: false,
                message: 'User account no longer exists.',
                data: null
            });
        }

        let profile = null;

        if (user.role === 'lecturer') {
            profile = await Lecturer.findOne({
                where: { userId: user.id },
                attributes: ['lecturerId', 'fullName']
            });
        }

        if (user.role === 'student') {
            profile = await Student.findOne({
                where: { userId: user.id },
                attributes: ['studentId', 'fullName']
            });
        }

        return res.status(200).json({
            success: true,
            message: 'User profile retrieved successfully.',
            data: {
                id: user.id,
                email: user.email,
                role: user.role,
                profile
            }
        });

    } catch (error) {
        console.error('Profile retrieval error:', error);

        return res.status(500).json({
            success: false,
            message: 'Unable to retrieve user profile.',
            data: null
        });
    }
});

export default router;