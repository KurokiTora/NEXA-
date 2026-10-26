
import { ArrowLeft, Users, ClipboardCheck, TrendingUp } from "lucide-react";
import { useNavigate, useParams } from "react-router-dom";

const students = [
  { id: "ST001", name: "Alicia Morgan", email: "alicia@example.com", score: 92, attendance: "96%" },
  { id: "ST002", name: "Benjamin Lee", email: "benjamin@example.com", score: 85, attendance: "92%" },
  { id: "ST003", name: "Charlotte Davis", email: "charlotte@example.com", score: 88, attendance: "98%" },
  { id: "ST004", name: "Daniel Wilson", email: "daniel@example.com", score: 76, attendance: "89%" },
  { id: "ST005", name: "Emma Taylor", email: "emma@example.com", score: 95, attendance: "100%" },
];

export default function ClassDetailPage() {
  const navigate = useNavigate();
  const { classId } = useParams();

  const className = `Class ${(classId ?? "10-a").toUpperCase()}`;

  return (
    <div className="page-container">
      <button
        type="button"
        className="detail-back-button"
        onClick={() => navigate("/classes")}
      >
        <ArrowLeft size={16} /> Back to Classes
      </button>

      <section className="detail-heading">
        <div>
          <p className="section-eyebrow">CLASS MANAGEMENT</p>
          <h2 className="page-title">{className}</h2>
          <p className="page-description">
            Mathematics · Academic Year 2026/2027
          </p>
        </div>
        <span className="classes-status classes-status-active">Active</span>
      </section>

      <section className="detail-stats-grid">
        <article className="panel detail-stat-card">
          <Users size={20} />
          <p>Total Students</p>
          <h3>{students.length}</h3>
        </article>
        <article className="panel detail-stat-card">
          <TrendingUp size={20} />
          <p>Average Score</p>
          <h3>
            {(students.reduce((sum, student) => sum + student.score, 0) / students.length).toFixed(1)}
          </h3>
        </article>
        <article className="panel detail-stat-card">
          <ClipboardCheck size={20} />
          <p>Average Attendance</p>
          <h3>95%</h3>
        </article>
      </section>

      <section className="panel detail-table-panel">
        <div className="detail-panel-heading">
          <div>
            <h3>Student List</h3>
            <p>Students enrolled in this class</p>
          </div>
        </div>

        <div className="detail-table-wrapper">
          <table className="detail-table">
            <thead>
              <tr>
                <th>Student ID</th>
                <th>Student Name</th>
                <th>Email</th>
                <th>Average Score</th>
                <th>Attendance</th>
                <th>Details</th>
              </tr>
            </thead>
            <tbody>
              {students.map((student) => (
                <tr key={student.id}>
                  <td>{student.id}</td>
                  <td><strong>{student.name}</strong></td>
                  <td>{student.email}</td>
                  <td>{student.score}</td>
                  <td>{student.attendance}</td>
                  <td>
                    <button
                      type="button"
                      className="detail-link-button"
                      onClick={() => navigate(`/students/${student.id}`)}
                    >
                      View
                    </button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </section>
    </div>
  );
}
