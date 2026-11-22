import { useState, useRef, useEffect, type CSSProperties } from "react";
import { useNavigate } from "react-router-dom";
import { apiRequest } from "../services/api";
import { clearSession } from "../services/lecturerApi";
import "../style/chatbot.css";

type Message = {
  id: number;
  text: string;
  sender: "bot" | "user";
};

interface ChatbotResponse {
  success: boolean;
  message: string;
  data: { role: string; reply: string } | null;
}

// label = teks di tombol dan gelembung chat, prompt = pertanyaan yang dikirim ke AI
const chatbotMenus = [
  {
    label: "Saran Dosen",
    prompt:
      "Berikan saran singkat untuk dosen dalam memantau perkembangan akademik mahasiswa di kelasnya.",
  },
  {
    label: "Tingkat Partisipasi Mahasiswa",
    prompt: "Jelaskan tingkat partisipasi mahasiswa di kelas saya.",
  },
  {
    label: "Rata-Rata Kelas",
    prompt: "Berapa rata-rata nilai kelas saya?",
  },
];

function bubbleStyle(isUser: boolean): CSSProperties {
  return {
    // USER DI KANAN, BOT DI KIRI
    alignSelf: isUser ? "flex-end" : "flex-start",
    marginLeft: isUser ? "auto" : "0",
    marginRight: isUser ? "0" : "auto",
    backgroundColor: isUser ? "#09275b" : "#91d4f1",
    color: isUser ? "#ffffff" : "#09275b",
  };
}

export default function Chatbot() {
  const navigate = useNavigate();

  const [menuOpen, setMenuOpen] = useState(false);
  const [loading, setLoading] = useState(false);

  const [messages, setMessages] = useState<Message[]>([
    {
      id: 1,
      sender: "user",
      text: "Halo, saya ingin mengetahui perkembangan akademik mahasiswa.",
    },
    {
      id: 2,
      sender: "bot",
      text: "Halo! Saya NEXA Assistant. Ada yang bisa saya bantu terkait aktivitas akademik kelas?",
    },
  ]);

  const nextId = useRef(3);
  const messagesEndRef = useRef<HTMLDivElement>(null);

  // Scroll otomatis ke pesan terbaru
  useEffect(() => {
    messagesEndRef.current?.scrollIntoView({
      behavior: "smooth",
      block: "end",
    });
  }, [messages, loading]);

  function addMessage(sender: Message["sender"], text: string) {
    setMessages((prev) => [...prev, { id: nextId.current++, sender, text }]);
  }

  // Memilih menu chatbot -> kirim ke backend (Groq)
  const handleMenuClick = async (menu: (typeof chatbotMenus)[number]) => {
    if (loading) return;

    // Tampilkan pertanyaan pengguna, tutup menu
    addMessage("user", menu.label);
    setMenuOpen(false);
    setLoading(true);

    try {
      const result = await apiRequest<ChatbotResponse>("/chatbot/message", {
        method: "POST",
        body: JSON.stringify({ message: menu.prompt }),
      });

      addMessage(
        "bot",
        result.data?.reply ?? "Maaf, NEXA AI tidak memberikan jawaban."
      );
    } catch (err) {
      const text = err instanceof Error ? err.message : "";

      // Token login habis -> kembali ke halaman login
      if (/authentication token/i.test(text)) {
        clearSession();
        navigate("/login", { replace: true });
        return;
      }

      addMessage(
        "bot",
        err instanceof TypeError
          ? "Tidak dapat terhubung ke server. Pastikan backend sedang berjalan."
          : text || "NEXA AI sedang mengalami kendala."
      );
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="chatbot-container">
      {/* HEADER */}
      <div className="chatbot-header">
        <span>Chatbot Nexa</span>
      </div>

      {/* AREA PERCAKAPAN */}
      <div className="chatbot-conversation">
        {/* DAFTAR PESAN */}
        <div className="chatbot-messages">
          {messages.map((message) => {
            const isUser = message.sender === "user";

            return (
              <div
                key={message.id}
                className={`chat-message ${
                  isUser ? "user-message" : "bot-message"
                }`}
                style={bubbleStyle(isUser)}
              >
                {message.text}
              </div>
            );
          })}

          {/* INDIKATOR SEDANG MENJAWAB */}
          {loading && (
            <div
              className="chat-message bot-message"
              style={bubbleStyle(false)}
            >
              NEXA sedang mengetik...
            </div>
          )}

          <div ref={messagesEndRef} />
        </div>

        {/* POPUP MENU */}
        {menuOpen && (
          <div className="chatbot-menu-popup">
            <div className="chatbot-menu-title">✦ Menu Chatbot</div>

            <div className="chatbot-menu-options">
              {chatbotMenus.map((menu) => (
                <button
                  key={menu.label}
                  type="button"
                  className="chatbot-option"
                  disabled={loading}
                  onClick={() => handleMenuClick(menu)}
                >
                  {menu.label}
                </button>
              ))}
            </div>
          </div>
        )}

        {/* TOMBOL MENU */}
        <button
          type="button"
          className="chatbot-menu-button"
          onClick={() => setMenuOpen((prev) => !prev)}
        >
          MENU
        </button>
      </div>
    </div>
  );
}