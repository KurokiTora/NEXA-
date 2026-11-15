
import { useState, useRef, useEffect } from "react";
import "../style/chatbot.css";

type Message = {
  id: number;
  text: string;
  sender: "bot" | "user";
};

const chatbotMenus = [
  "Saran Dosen",
  "Tingkat Partisipasi Mahasiswa",
  "Rata-Rata Kelas",
];

export default function Chatbot() {
  const [menuOpen, setMenuOpen] = useState(false);

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

  const messagesEndRef = useRef<HTMLDivElement>(null);

  // Scroll otomatis ke pesan terbaru
  useEffect(() => {
    messagesEndRef.current?.scrollIntoView({
      behavior: "smooth",
      block: "end",
    });
  }, [messages]);

  // Memilih menu chatbot
  const handleMenuClick = (menu: string) => {
    const userMessage: Message = {
      id: Date.now(),
      sender: "user",
      text: menu,
    };

    // Tampilkan pertanyaan pengguna
    setMessages((prev) => [...prev, userMessage]);

    // Tutup menu
    setMenuOpen(false);

    // Simulasi jawaban AI
    setTimeout(() => {
      const botMessage: Message = {
        id: Date.now() + 1,
        sender: "bot",
        text: `Berikut adalah analisis ${menu.toLowerCase()}. Hasil analisis akan ditampilkan berdasarkan data akademik NEXA setelah backend terhubung.`,
      };

      // Tampilkan jawaban AI setelah pertanyaan
      setMessages((prev) => [...prev, botMessage]);
    }, 500);
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
                style={{
                  // USER DI KANAN
                  // BOT DI KIRI
                  alignSelf: isUser ? "flex-end" : "flex-start",
                  marginLeft: isUser ? "auto" : "0",
                  marginRight: isUser ? "0" : "auto",
                  backgroundColor: isUser ? "#09275b" : "#91d4f1",
                  color: isUser ? "#ffffff" : "#09275b",
                }}
              >
                {message.text}
              </div>
            );
          })}

          <div ref={messagesEndRef} />

        </div>

        {/* POPUP MENU */}
        {menuOpen && (
          <div className="chatbot-menu-popup">

            <div className="chatbot-menu-title">
              ✦ Menu Chatbot
            </div>

            <div className="chatbot-menu-options">
              {chatbotMenus.map((menu) => (
                <button
                  key={menu}
                  type="button"
                  className="chatbot-option"
                  onClick={() => handleMenuClick(menu)}
                >
                  {menu}
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
