
import { ArrowLeft, Mail, GraduationCap, CalendarCheck } from "lucide-react";
import { useNavigate, useParams } from "react-router-dom";

const grades = [
  { subject: "Mathematics", score: 92, progress: 92 },
  { subject: "Computer Science", score: 85, progress: 85 },
  { subject: "English", score: 88, progress: 88 },
  { subject: "Physics", score: 76, progress: 76 },
  { subject: "Biology", score: 95, progress: 95 },
];

export default function StudentDetailPage() {
  const navigate = useNavigate();
  const { studentId } = useParams();

  return (
    <div className="page-container">
      <button
        type="button"
        className="detail-back-button"
        onClick={() => navigate(-1)}
      >
        <ArrowLeft size={16} /> Back
      </button>

      <section className="panel student-profile">
        <div className="student-avatar">AM</div>
        <div className="student-profile-info">
          <p className="section-eyebrow">STUDENT PROFILE</p>
          <h2 className="page-title">Alicia Morgan</h2>
          <p className="page-description">
            Student ID: {studentId ?? "ST001"}
          </p>
          <div className="student-profile-meta">
            <span><Mail size={14} /> alicia@example.com</span>
            <span><GraduationCap size={14} /> Class 10-A</span>
            <span><CalendarCheck size={14} /> Enrolled 2026</span>
          </div>
        </div>
        <span className="classes-status classes-status-active">Active</span>
      </section>

      <section className="detail-stats-grid">
        <article className="panel detail-stat-card">
          <GraduationCap size={20} />
          <p>Average Score</p>
          <h3>87.2</h3>
        </article>
        <article className="panel detail-stat-card">
          <CalendarCheck size={20} />
          <p>Attendance Rate</p>
          <h3>96%</h3>
        </article>
        <article className="panel detail-stat-card">
          <GraduationCap size={20} />
          <p>Subjects</p>
          <h3>{grades.length}</h3>
        </article>
      </section>

      <section className="panel student-grades-panel">
        <div className="detail-panel-heading">
          <div>
            <h3>Academic Performance</h3>
            <p>Current scores by subject</p>
          </div>
        </div>

        <div className="student-grade-list">
          {grades.map((grade) => (
            <div className="student-grade-row" key={grade.subject}>
              <div className="student-grade-label">
                <strong>{grade.subject}</strong>
                <span>{grade.score}/100</span>
              </div>
              <div className="student-grade-track">
                <div
                  className="student-grade-fill"
                  style={{ width: `${grade.progress}%` }}
                />
              </div>
            </div>
          ))}
        </div>
      </section>

      <section className="panel student-notes-panel">
        <h3>Teacher Notes</h3>
        <p>
          This profile currently uses sample information. Add teacher
          observations and learning recommendations when the backend is connected.
        </p>
      </section>
    </div>
  );
}
