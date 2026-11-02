
import { Router } from 'express';

import { authenticate } from '../middleware/authenticate.js';

import {
    generateChatbotReply
} from '../services/chatbotService.js';

import {
    getStudentAcademicOverview
} from '../services/chatbotAcademicService.js';

import {
    getLecturerAcademicOverview
} from '../services/chatbotLecturerService.js';

const router = Router();

/**
 * Detect common prompt injection and data extraction attempts.
 *
 * This is an additional backend security layer.
 * It is not a replacement for authorization or data isolation.
 */
function containsUnsafeInstruction(message) {
    const normalizedMessage = message
        .toLowerCase()
        .normalize('NFKC')
        .replace(/\s+/g, ' ')
        .trim();

    const unsafePatterns = [
        // Attempts to override system instructions.
        /abaikan.{0,40}(instruksi|aturan|prompt)/i,
        /ignore.{0,40}(previous|prior|system|instructions)/i,
        /forget.{0,40}(previous|system|instructions)/i,
        /bypass.{0,30}(aturan|instruksi|security|keamanan)/i,

        // Attempts to change chatbot identity.
        /mulai sekarang.{0,60}(bukan nexa|bukan chatbot|jadi ai lain)/i,
        /you are no longer.{0,40}(nexa|assistant)/i,
        /berpura-pura menjadi.{0,40}(admin|administrator)/i,

        // Attempts to expose internal instructions.
        /tampilkan.{0,40}(system prompt|instruksi sistem|prompt sistem)/i,
        /show.{0,40}(system prompt|developer message|hidden instructions)/i,
        /reveal.{0,40}(system prompt|hidden instructions)/i,

        // Attempts to dump academic context or database contents.
        /tampilkan.{0,50}(seluruh|semua).{0,50}(data|informasi).{0,50}(akademik|database|mahasiswa)/i,
        /dump.{0,40}(database|data|academic context)/i,
        /export.{0,40}(seluruh|semua|database|data)/i,
        /berikan.{0,50}(seluruh|semua).{0,50}(isi database|data akademik)/i
    ];

    return unsafePatterns.some(pattern =>
        pattern.test(normalizedMessage)
    );
}

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

        // 2. Reject common prompt injection attempts.
        if (containsUnsafeInstruction(cleanMessage)) {
            return res.status(200).json({
                success: true,
                message: 'Permintaan ditolak oleh kebijakan keamanan NEXA.',
                data: {
                    role: 'assistant',
                    reply: 'Maaf, saya tidak dapat memenuhi permintaan tersebut. Saya hanya dapat membantu pertanyaan akademik dan penggunaan aplikasi NEXA.'
                }
            });
        }

        // 3. Get authenticated user identity.
        const { id: userId, role } = req.user;

        // 4. Retrieve academic context based on authenticated role.
        let academicContext;

        if (role === 'student') {
            academicContext = await getStudentAcademicOverview(userId);
        } else if (role === 'lecturer') {
            academicContext = await getLecturerAcademicOverview(userId);
        } else {
            return res.status(403).json({
                success: false,
                message: 'Role pengguna tidak memiliki akses chatbot.',
                data: null
            });
        }

        // 5. Generate response using authenticated academic context.
        const reply = await generateChatbotReply(
            cleanMessage,
            academicContext,
            role
        );

        // 6. Return chatbot response.
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
