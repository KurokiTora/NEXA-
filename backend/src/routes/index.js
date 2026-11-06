import { Router } from 'express';

import authRoutes from './authroutes.js';
import lecturerRoutes from './lecturerroutes.js';
import studentRoutes from './studentroutes.js';

const router = Router();

// Health check
router.get('/health', (req, res) => {
    res.status(200).json({
        success: true,
        message: 'Backend API is running.',
        timestamp: new Date().toISOString()
    });
});

// Shared authentication
router.use('/auth', authRoutes);

// Role-specific routes
router.use('/lecturer', lecturerRoutes);
router.use('/student', studentRoutes);

export default router;