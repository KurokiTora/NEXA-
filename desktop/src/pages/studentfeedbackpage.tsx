
import { useMemo, useState } from "react";
import { Search, MessageSquare, ArrowRight } from "lucide-react";
import { useNavigate } from "react-router-dom";

const feedbackData = [
  {
    id: 1,
    student: "Alicia Morgan",
    studentId: "ST001",
    subject: "Mathematics",
    message: "The explanations are clear, but I would like more practice questions.",
    date: "Oct 08, 2026",
    status: "New",
  },
  {
    id: 2,
    student: "Benjamin Lee",
    studentId: "ST002",
    subject: "Computer Science",
    message: "The practical sessions help me understand the material better.",
    date: "Oct 07, 2026",
    status: "Reviewed",
  },
  {
    id: 3,
    student: "Charlotte Davis",
    studentId: "ST003",
    subject: "English",
    message: "Please provide additional reading materials for the next lesson.",
    date: "Oct 06, 2026",
    status: "New",
  },
  {
    id: 4,
    student: "Daniel Wilson",
    studentId: "ST004",
    subject: "Physics",
    message: "Some topics move too quickly. More examples would be helpful.",
    date: "Oct 05, 2026",
    status: "Resolved",
  },
];

export default function StudentFeedbackPage() {
  const [search, setSearch] = useState("");
  const [filter, setFilter] = useState("All");
  const [selectedFeedback, setSelectedFeedback] = useState<number | null>(null);
  const navigate = useNavigate();

  const filteredFeedback = useMemo(() => {
    return feedbackData.filter((item) => {
      const matchesSearch = [
        item.student,
        item.studentId,
        item.subject,
        item.message,
      ].some((value) =>
        value.toLowerCase().includes(search.toLowerCase())
      );

      const matchesStatus = filter === "All" || item.status === filter;
      return matchesSearch && matchesStatus;
    });
  }, [search, filter]);

  const selected = feedbackData.find(
    (item) => item.id === selectedFeedback
  );

  return (
    <div className="page-container">
      <section>
        <p className="section-eyebrow">STUDENT EXPERIENCE</p>
        <h2 className="page-title">Student Feedback</h2>
        <p className="page-description">
          Review student opinions and identify opportunities to improve learning.
        </p>
      </section>

      <section className="feedback-summary">
        <article className="panel feedback-summary-card">
          <MessageSquare size={20} />
          <div><p>Total Feedback</p><h3>{feedbackData.length}</h3></div>
        </article>
        <article className="panel feedback-summary-card">
          <MessageSquare size={20} />
          <div><p>New Feedback</p><h3>{feedbackData.filter((item) => item.status === "New").length}</h3></div>
        </article>
        <article className="panel feedback-summary-card">
          <MessageSquare size={20} />
          <div><p>Resolved</p><h3>{feedbackData.filter((item) => item.status === "Resolved").length}</h3></div>
        </article>
      </section>

      <section className="panel feedback-panel">
        <div className="feedback-toolbar">
          <div>
            <h3>All Feedback</h3>
            <p>Student comments and suggestions</p>
          </div>

          <div className="feedback-controls">
            <label className="classes-search">
              <Search size={16} />
              <input
                type="search"
                placeholder="Search feedback..."
                value={search}
                onChange={(event) => setSearch(event.target.value)}
              />
            </label>

            <select
              className="classes-filter"
              value={filter}
              onChange={(event) => setFilter(event.target.value)}
              aria-label="Filter feedback status"
            >
              <option value="All">All Status</option>
              <option value="New">New</option>
              <option value="Reviewed">Reviewed</option>
              <option value="Resolved">Resolved</option>
            </select>
          </div>
        </div>

        <div className="feedback-list">
          {filteredFeedback.map((item) => (
            <article className="feedback-item" key={item.id}>
              <div className="feedback-avatar">
                {item.student.split(" ").map((part) => part[0]).join("")}
              </div>

              <div className="feedback-content">
                <div className="feedback-item-heading">
                  <h4>{item.student}</h4>
                  <span className={`feedback-status feedback-status-${item.status.toLowerCase()}`}>
                    {item.status}
                  </span>
                </div>
                <p className="feedback-subject">{item.subject} · {item.date}</p>
                <p className="feedback-message">{item.message}</p>
                <div className="feedback-actions">
                  <button
                    type="button"
                    className="detail-link-button"
                    onClick={() => setSelectedFeedback(item.id)}
                  >
                    Read feedback <ArrowRight size={14} />
                  </button>
                  <button
                    type="button"
                    className="detail-link-button"
                    onClick={() => navigate(`/students/${item.studentId}`)}
                  >
                    View student
                  </button>
                </div>
              </div>
            </article>
          ))}

          {filteredFeedback.length === 0 && (
            <p className="feedback-empty">No feedback matches your search.</p>
          )}
        </div>
      </section>

      {selected && (
        <div
          className="feedback-modal-backdrop"
          onClick={() => setSelectedFeedback(null)}
        >
          <section
            className="feedback-modal panel"
            role="dialog"
            aria-modal="true"
            aria-labelledby="feedback-modal-title"
            onClick={(event) => event.stopPropagation()}
          >
            <div className="detail-panel-heading">
              <div>
                <p className="section-eyebrow">FEEDBACK DETAILS</p>
                <h3 id="feedback-modal-title">{selected.subject}</h3>
              </div>
              <button
                type="button"
                className="feedback-close-button"
                onClick={() => setSelectedFeedback(null)}
                aria-label="Close feedback"
              >
                ×
              </button>
            </div>

            <p className="feedback-modal-student">{selected.student} · {selected.date}</p>
            <p className="feedback-modal-message">{selected.message}</p>

            <button
              type="button"
              className="classes-add-button"
              onClick={() => setSelectedFeedback(null)}
            >
              Close
            </button>
          </section>
        </div>
      )}
    </div>
  );
}
