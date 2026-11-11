
import { Router } from 'express';

import { authenticate } from '../middleware/authenticate.js';

import {
    generateChatbotReply,
    GROQ_MODEL
} from '../services/chatbotService.js';

import {
    getStudentAcademicOverview
} from '../services/chatbotAcademicService.js';

import {
    getLecturerAcademicOverview
} from '../services/chatbotLecturerService.js';

import {
    AIInteraction
} from '../models/index.js';

const router = Router();

const REJECTION_REPLY =
    'Maaf, saya tidak dapat memenuhi permintaan tersebut. Saya hanya dapat membantu pertanyaan akademik dan penggunaan aplikasi NEXA.';

/**
 * Detect common prompt injection and data extraction attempts.
 */
function containsUnsafeInstruction(message) {
    const normalizedMessage = message
        .toLowerCase()
        .normalize('NFKC')
        .replace(/\s+/g, ' ')
        .trim();

    const unsafePatterns = [
        /abaikan.{0,40}(instruksi|aturan|prompt)/i,
        /ignore.{0,40}(previous|prior|system|instructions)/i,
        /forget.{0,40}(previous|system|instructions)/i,
        /bypass.{0,30}(aturan|instruksi|security|keamanan)/i,

        /mulai sekarang.{0,60}(bukan nexa|bukan chatbot|jadi ai lain)/i,
        /you are no longer.{0,40}(nexa|assistant)/i,
        /berpura-pura menjadi.{0,40}(admin|administrator)/i,

        /tampilkan.{0,40}(system prompt|instruksi sistem|prompt sistem)/i,
        /show.{0,40}(system prompt|developer message|hidden instructions)/i,
        /reveal.{0,40}(system prompt|hidden instructions)/i,

        /tampilkan.{0,50}(seluruh|semua).{0,50}(data|informasi).{0,50}(akademik|database|mahasiswa)/i,
        /dump.{0,40}(database|data|academic context)/i,
        /export.{0,40}(seluruh|semua|database|data)/i,
        /berikan.{0,50}(seluruh|semua).{0,50}(isi database|data akademik)/i
    ];

    return unsafePatterns.some(pattern =>
        pattern.test(normalizedMessage)
    );
}

// GET /api/chatbot/history
router.get('/history', authenticate, async (req, res) => {
    try {
        const requestedLimit = Number.parseInt(req.query.limit, 10);

        const limit = Number.isInteger(requestedLimit)
            ? Math.min(Math.max(requestedLimit, 1), 50)
            : 20;

        const interactions = await AIInteraction.findAll({
            where: {
                userId: req.user.id
            },
            attributes: [
                'id',
                'userRole',
                'question',
                'responseJson',
                'model',
                'status',
                'createdAt'
            ],
            order: [['createdAt', 'DESC']],
            limit
        });

        return res.status(200).json({
            success: true,
            message: 'Riwayat chatbot berhasil diambil.',
            data: interactions
        });

    } catch (error) {
        console.error('Chatbot history error:', error.message);

        return res.status(500).json({
            success: false,
            message: 'Riwayat chatbot tidak dapat diambil.',
            data: null
        });
    }
});

// POST /api/chatbot/message
router.post('/message', authenticate, async (req, res) => {
    try {
        // 1. Validate user message.
        const message = req.body?.message;

        if (typeof message !== 'string' || !message.trim()) {
            return res.status(400).json({
                success: false,
                message: 'Pesan tidak boleh kosong.',
                data: null
            });
        }

        const cleanMessage = message.trim();

        if (cleanMessage.length > 2000) {
            return res.status(400).json({
                success: false,
                message: 'Pesan maksimal 2000 karakter.',
                data: null
            });
        }

        // 2. Get authenticated user identity.
        const { id: userId, role } = req.user;

        if (!['student', 'lecturer'].includes(role)) {
            return res.status(403).json({
                success: false,
                message: 'Role pengguna tidak memiliki akses chatbot.',
                data: null
            });
        }

        // 3. Detect and record unsafe requests.
        if (containsUnsafeInstruction(cleanMessage)) {
            await AIInteraction.create({
                userId,
                userRole: role,
                question: cleanMessage,
                responseJson: {
                    role: 'assistant',
                    reply: REJECTION_REPLY
                },
                model: GROQ_MODEL,
                status: 'rejected'
            });

            return res.status(200).json({
                success: true,
                message: 'Permintaan ditolak oleh kebijakan keamanan NEXA.',
                data: {
                    role: 'assistant',
                    reply: REJECTION_REPLY
                }
            });
        }

        // 4. Retrieve academic context by authenticated role.
        let academicContext;

        if (role === 'student') {
            academicContext =
                await getStudentAcademicOverview(userId);
        } else {
            academicContext =
                await getLecturerAcademicOverview(userId);
        }

        // 5. Generate AI response.
        const reply = await generateChatbotReply(
            cleanMessage,
            academicContext,
            role
        );

        // 6. Save interaction to database.
        await AIInteraction.create({
            userId,
            userRole: role,
            question: cleanMessage,
            responseJson: {
                role: 'assistant',
                reply
            },
            model: GROQ_MODEL,
            status: 'success'
        });

        // 7. Return response.
        return res.status(200).json({
            success: true,
            message: 'Chatbot berhasil memberikan respons.',
            data: {
                role: 'assistant',
                reply
            }
        });

    } catch (error) {
        console.error('Chatbot error:', error.message);

        return res.status(500).json({
            success: false,
            message: 'NEXA AI sedang mengalami kendala.',
            data: null
        });
    }
});

export default router;
