import { useNavigate, useParams } from "react-router-dom";
import Card from "../component/card";
import PageState from "../component/PageState";
import { useApiData } from "../hooks/useApiData";
import { getStudentDetail } from "../services/lecturerApi";

export default function StudentDetailPage() {
  const { classId = "", studentId = "" } = useParams();
  const navigate = useNavigate();

  const {
    data: student,
    loading,
    error,
    reload,
  } = useApiData(
    () => getStudentDetail(classId, studentId),
    [classId, studentId]
  );

  const assignments = student?.assignments ?? [];

  const completed = assignments.filter(
    (item) => item.status === "Completed"
  ).length;

  const graded = assignments.filter((item) => item.grade !== null);

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

          <h1>{student?.fullName ?? "Student"}</h1>
          <p>{student ? `NIM: ${student.studentNumber}` : ""}</p>
        </div>
      </div>

      <PageState loading={loading} error={error} onRetry={reload} className="" />

      {student && (
        <>
          <div className="academic-summary-grid">
            <div className="academic-summary-card">
              <span>Total Assignment</span>
              <strong>{assignments.length}</strong>
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
            <span>{assignments.length} Assignments</span>
          </div>

          <div className="academic-card-list">
            {assignments.map((assignment) => (
              <Card
                key={assignment.id}
                title={assignment.title}
                status={assignment.status}
                grade={assignment.grade}
              />
            ))}
          </div>
        </>
      )}
    </div>
  );
}