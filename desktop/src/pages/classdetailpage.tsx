
import { useNavigate, useParams, Navigate } from "react-router-dom";
import Card from "../components/card";

export default function ClassDetailPage() {
  const { classId } = useParams();
  const navigate = useNavigate();

  const classes = [
    {
      id: "CLS001",
      name: "Pemrograman Web",
      students: [
        { id: "STD001", name: "Ahmad Fauzan", nim: "225150400111001" },
        { id: "STD002", name: "Siti Nurhaliza", nim: "225150400111002" },
        { id: "STD003", name: "Rizky Pratama", nim: "225150400111003" },
      ],
    },
    {
      id: "CLS002",
      name: "Basis Data",
      students: [
        { id: "STD004", name: "Dina Amelia", nim: "225150400111004" },
        { id: "STD005", name: "Fajar Ramadhan", nim: "225150400111005" },
      ],
    },
    {
      id: "CLS003",
      name: "UI/UX Design",
      students: [
        { id: "STD006", name: "Nadia Putri", nim: "225150400111006" },
        { id: "STD007", name: "Dimas Saputra", nim: "225150400111007" },
      ],
    },
  ];

  const selectedClass = classes.find((item) => item.id === classId);

  if (!selectedClass) {
    return <Navigate to="/classes" replace />;
  }

  return (
    <div className="academic-page">
      <div className="academic-page-header">
        <div>
          <button
            className="academic-back-button"
            onClick={() => navigate("/classes")}
          >
            ← Back to Classes
          </button>

          <h1>{selectedClass.name}</h1>
          <p>Student list in this class.</p>
        </div>
      </div>

      <div className="academic-section-heading">
        <h2>Students</h2>
        <span>{selectedClass.students.length} Students</span>
      </div>

      <div className="academic-card-list">
        {selectedClass.students.map((student) => (
          <Card
            key={student.id}
            title={student.name}
            subtitle={`NIM: ${student.nim}`}
            actionLabel="View Student"
            onAction={() =>
              navigate(`/classes/${classId}/students/${student.id}`)
            }
          />
        ))}
      </div>
    </div>
  );
}
