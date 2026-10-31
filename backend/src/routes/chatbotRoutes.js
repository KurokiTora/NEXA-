
import { Router } from 'express';
import { authenticate } from '../middleware/authenticate.js';
import { generateChatbotReply } from '../services/chatbotService.js';

const router = Router();

// POST /api/chatbot/message
router.post('/message', authenticate, async (req, res) => {
    try {
        // Ambil pesan dari request body
        const message = req.body?.message;

        // Validasi tipe dan isi pesan
        if (typeof message !== 'string' || !message.trim()) {
            return res.status(400).json({
                success: false,
                message: 'Pesan tidak boleh kosong.',
                data: null
            });
        }

        // Bersihkan spasi di awal dan akhir pesan
        const cleanMessage = message.trim();

        // Validasi panjang pesan setelah dibersihkan
        if (cleanMessage.length > 2000) {
            return res.status(400).json({
                success: false,
                message: 'Pesan maksimal 2000 karakter.',
                data: null
            });
        }

        // Kirim pesan ke Groq melalui chatbot service
        const reply = await generateChatbotReply(cleanMessage);

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
