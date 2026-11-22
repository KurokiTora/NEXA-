import { useNavigate } from "react-router-dom";
import Card from "../component/card";
import PageState from "../component/PageState";
import { useApiData } from "../hooks/useApiData";
import { getClasses } from "../services/lecturerApi";

export default function ClassPage() {
  const navigate = useNavigate();
  const { data: classes, loading, error, reload } = useApiData(getClasses);

  return (
    <div className="academic-page">
      <div className="academic-page-header">
        <div>
          <h1>Classes</h1>
          <p>Manage and monitor your classes.</p>
        </div>
      </div>

      <PageState loading={loading} error={error} onRetry={reload} className="" />

      {classes && classes.length === 0 && <p>No classes found.</p>}

      <div className="academic-card-list">
        {classes?.map((item) => (
          <Card
            key={item.id}
            title={item.courseName}
            subtitle={item.classCode}
            footer={`${item.studentCount} Students`}
            actionLabel="View Class"
            onAction={() => navigate(`/classes/${item.id}`)}
          />
        ))}
      </div>
    </div>
  );
}