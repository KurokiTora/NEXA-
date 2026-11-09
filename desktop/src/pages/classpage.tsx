
import { useNavigate } from "react-router-dom";
import Card from "../components/card";

export default function ClassPage() {
  const navigate = useNavigate();

  const classes = [
    {
      id: "CLS001",
      name: "Pemrograman Web",
      code: "WEB-01",
      students: 32,
    },
    {
      id: "CLS002",
      name: "Basis Data",
      code: "DB-02",
      students: 28,
    },
    {
      id: "CLS003",
      name: "UI/UX Design",
      code: "UX-03",
      students: 25,
    },
  ];

  return (
    <div className="academic-page">
      <div className="academic-page-header">
        <div>
          <h1>Classes</h1>
          <p>Manage and monitor your classes.</p>
        </div>
      </div>

      <div className="academic-card-list">
        {classes.map((item) => (
          <Card
            key={item.id}
            title={item.name}
            subtitle={item.code}
            footer={`${item.students} Students`}
            actionLabel="View Class"
            onAction={() => navigate(`/classes/${item.id}`)}
          />
        ))}
      </div>
    </div>
  );
}
