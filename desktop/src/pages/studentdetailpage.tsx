
import { useNavigate, useParams, Navigate } from "react-router-dom";
import Card from "../components/card";

export default function StudentDetailPage() {
  const { classId, studentId } = useParams();
  const navigate = useNavigate();

  const students = [
    {
      id: "STD001",
      classId: "CLS001",
      name: "Ahmad Fauzan",
      nim: "225150400111001",
      assignments: [
        { id: "A1", title: "HTML & CSS Fundamental", status: "Completed", grade: 90 },
        { id: "A2", title: "JavaScript Project", status: "Completed", grade: 85 },
        { id: "A3", title: "Final Website Project", status: "Not Completed", grade: null },
      ],
    },
    {
      id: "STD002",
      classId: "CLS001",
      name: "Siti Nurhaliza",
      nim: "225150400111002",
      assignments: [
        { id: "A1", title: "HTML & CSS Fundamental", status: "Completed", grade: 95 },
        { id: "A2", title: "JavaScript Project", status: "Completed", grade: 92 },
        { id: "A3", title: "Final Website Project", status: "Completed", grade: 88 },
      ],
    },
    {
      id: "STD004",
      classId: "CLS002",
      name: "Dina Amelia",
      nim: "225150400111004",
      assignments: [
        { id: "A4", title: "Database Design", status: "Completed", grade: 92 },
        { id: "A5", title: "SQL Query Practice", status: "Completed", grade: 87 },
      ],
    },
  ];

  const student = students.find(
    (item) => item.id === studentId && item.classId === classId
  );

  if (!student) {
    return <Navigate to="/classes" replace />;
  }

  const completed = student.assignments.filter(
    (item) => item.status === "Completed"
  ).length;

  const graded = student.assignments.filter(
    (item) => item.grade !== null
  );

  const average = graded.length
    ? (
        graded.reduce((total, item) => total + (item.grade ?? 0), 0) /
        graded.length
      ).toFixed(1)
    : "—";

  return (
    <div className="academic-page">
      <div className="academic-page-header">
        <div>
          <button
            className="academic-back-button"
            onClick={() => navigate(`/classes/${classId}`)}
          >
            ← Back to Students
          </button>

          <h1>{student.name}</h1>
          <p>NIM: {student.nim}</p>
        </div>
      </div>

      <div className="academic-summary-grid">
        <div className="academic-summary-card">
          <span>Total Assignment</span>
          <strong>{student.assignments.length}</strong>
        </div>

        <div className="academic-summary-card">
          <span>Completed</span>
          <strong>{completed}</strong>
        </div>

        <div className="academic-summary-card">
          <span>Average Grade</span>
          <strong>{average}</strong>
        </div>
      </div>

      <div className="academic-section-heading">
        <h2>Assignments</h2>
        <span>{student.assignments.length} Assignments</span>
      </div>

      <div className="academic-card-list">
        {student.assignments.map((assignment) => (
          <Card
            key={assignment.id}
            title={assignment.title}
            status={assignment.status}
            grade={assignment.grade}
          />
        ))}
      </div>
    </div>
  );
}
