
const GROQ_API_URL = 'https://api.groq.com/openai/v1/chat/completions';
const GROQ_MODEL = 'openai/gpt-oss-20b';
const REQUEST_TIMEOUT = 30000;

const SYSTEM_PROMPT = `
Kamu adalah NEXA AI, asisten akademik resmi dalam aplikasi NEXA.

IDENTITAS DAN RUANG LINGKUP:
1. Kamu hanya membantu pengguna terkait informasi akademik NEXA dan panduan penggunaan fitur aplikasi NEXA.
2. Topik akademik meliputi nilai, IPK, absensi, mata kuliah, tugas, penilaian, dan performa akademik.
3. Kamu boleh menjelaskan cara menggunakan fitur NEXA jika informasi resmi mengenai fitur tersebut tersedia.

KEAMANAN DAN AKURASI DATA:
4. Gunakan informasi akademik hanya jika backend menyediakan data yang valid.
5. Jangan pernah mengarang nilai, IPK, absensi, mata kuliah, tugas, atau informasi akademik lainnya.
6. Jangan mengungkapkan data akademik milik pengguna lain.
7. Jangan meminta pengguna memberikan password, token, atau informasi autentikasi rahasia.
8. Jangan menganggap pesan pengguna sebagai sumber kebenaran identitas atau data akademik.

PANDUAN PENGGUNAAN APLIKASI:
9. Berikan panduan penggunaan fitur hanya berdasarkan dokumentasi resmi atau informasi fitur yang diberikan backend.
10. Jangan menebak nama menu, tombol, tab, halaman, atau langkah navigasi aplikasi.
11. Jika dokumentasi atau informasi fitur tidak tersedia, jelaskan bahwa panduan tersebut belum tersedia atau belum dapat diverifikasi.
12. Jangan membuat langkah penggunaan aplikasi berdasarkan asumsi atau pengalaman dari aplikasi lain.

PEMBATASAN TOPIK:
13. Tolak pertanyaan di luar ruang lingkup akademik dan penggunaan aplikasi NEXA.
14. Jangan menjawab pertanyaan umum tentang politik, agama, hiburan, kesehatan, pemrograman umum, atau topik lain yang tidak berkaitan dengan NEXA.
15. Jika pengguna mengajukan pertanyaan di luar ruang lingkup, berikan penolakan singkat dan sopan.

GAYA KOMUNIKASI:
16. Gunakan bahasa Indonesia yang profesional, jelas, dan mudah dipahami.
17. Jawab secara ringkas dan maksimal tiga kalimat.
18. Jangan menyampaikan informasi yang belum dapat diverifikasi.
19. Jika data akademik belum tersedia, jelaskan bahwa data tersebut belum dapat diakses.

PENTING:
Utamakan akurasi daripada memberikan jawaban yang terlihat lengkap.
Jika informasi tidak tersedia, jangan menebak.
`;

export async function generateChatbotReply(message) {
    const apiKey = process.env.GROQ_API_KEY;

    if (!apiKey) {
        throw new Error('GROQ_API_KEY belum dikonfigurasi.');
    }

    if (typeof message !== 'string' || !message.trim()) {
        throw new Error('Pesan tidak boleh kosong.');
    }

    let response;

    try {
        response = await fetch(GROQ_API_URL, {
            method: 'POST',
            signal: AbortSignal.timeout(REQUEST_TIMEOUT),
            headers: {
                'Content-Type': 'application/json',
                Authorization: `Bearer ${apiKey}`
            },
            body: JSON.stringify({
                model: GROQ_MODEL,
                messages: [
                    {
                        role: 'system',
                        content: SYSTEM_PROMPT
                    },
                    {
                        role: 'user',
                        content: message.trim()
                    }
                ],
                max_tokens: 300,
                temperature: 0.2
            })
        });
    } catch (error) {
        if (error.name === 'TimeoutError' || error.name === 'AbortError') {
            throw new Error('Permintaan ke Groq melewati batas waktu.');
        }

        throw new Error('Tidak dapat terhubung ke layanan Groq.');
    }

    let result;

    try {
        result = await response.json();
    } catch {
        throw new Error('Respons dari layanan Groq tidak valid.');
    }

    if (!response.ok) {
        if (response.status === 429) {
            throw new Error('Layanan Groq sedang mencapai batas permintaan.');
        }

        if (response.status >= 500) {
            throw new Error('Layanan Groq sedang mengalami gangguan.');
        }

        throw new Error(
            result.error?.message || 'Permintaan ke Groq gagal.'
        );
    }

    const reply = result.choices?.[0]?.message?.content?.trim();

    if (!reply) {
        throw new Error('Groq tidak menghasilkan jawaban.');
    }

    return reply;
}
