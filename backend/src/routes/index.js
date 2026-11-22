import { Router } from 'express';
import authRoutes from './authroutes.js';
import chatbotRoutes from './chatbotRoutes.js';
import lecturerRoutes from './lecturerroutes.js';

const router = Router();

// Health check
router.get('/health', (req, res) => {
    res.status(200).json({
        success: true,
        message: 'Backend API is running.',
        timestamp: new Date().toISOString()
    });
});

// Authentication
router.use('/auth', authRoutes);

router.use('/lecturer', lecturerRoutes);

// Chatbot
router.use('/chatbot', chatbotRoutes);

export default router;