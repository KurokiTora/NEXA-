import { useNavigate, useParams } from "react-router-dom";
import Card from "../component/card";
import PageState from "../component/PageState";
import { useApiData } from "../hooks/useApiData";
import { getClassDetail } from "../services/lecturerApi";

export default function ClassDetailPage() {
  // Accept either route param name (:classId or :id)
  const params = useParams();
  const classId = params.classId ?? params.id ?? "";
  const navigate = useNavigate();

  const {
    data: selectedClass,
    loading,
    error,
    reload,
  } = useApiData(() => getClassDetail(classId), [classId]);

  const students = selectedClass?.students ?? [];

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

          <h1>{selectedClass?.classCode ?? "Class"}</h1>
          <p>Student list in this class.</p>
        </div>
      </div>

      <PageState loading={loading} error={error} onRetry={reload} className="" />

      {selectedClass && (
        <>
          <div className="academic-section-heading">
            <h2>Students</h2>
            <span>{students.length} Students</span>
          </div>

          <div className="academic-card-list">
            {students.map((student) => (
              <Card
                key={student.id}
                title={student.fullName}
                subtitle={`NIM: ${student.studentNumber}`}
                actionLabel="View Student"
                onAction={() =>
                  navigate(`/classes/${classId}/students/${student.id}`)
                }
              />
            ))}
          </div>
        </>
      )}
    </div>
  );
}