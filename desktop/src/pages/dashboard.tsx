import { UserRound } from "lucide-react";
import "../style/dashboard.css";
import { getDashboard, getMe } from "../services/lecturerApi";
import { useApiData } from "../hooks/useApiData";
import PageState from "../component/PageState";

export default function DashboardPage() {
  const me = useApiData(getMe);
  const dashboard = useApiData(getDashboard);

  const loading = me.loading || dashboard.loading;
  const error = me.error || dashboard.error;

  if (loading || error || !me.data || !dashboard.data) {
    return (
      <PageState
        loading={loading}
        error={error}
        className="dashboard-page"
        onRetry={() => {
          me.reload();
          dashboard.reload();
        }}
      />
    );
  }

  const lecturer = {
    name: me.data.profile?.fullName ?? me.data.email,
    nim: me.data.profile?.lecturerId ?? "",
  };

  const { stats, schedule } = dashboard.data;

  const statistics = [
    {
      title: "Attendant",
      value:
        stats.attendancePercentage === null
          ? "—"
          : `${stats.attendancePercentage}%`,
      type: "attendance",
    },
    {
      title: "Student",
      value: String(stats.studentCount),
      suffix: "Person",
      type: "student",
    },
    {
      title: "Average Grade",
      value: stats.averageGrade === null ? "—" : String(stats.averageGrade),
      prefix: "Total",
      type: "grade",
    },
  ];

  return (
    <div className="dashboard-page">
      {/* STATISTICS */}
      <section className="dashboard-summary">
        {statistics.map((item) => (
          <div
            key={item.type}
            className={`summary-card summary-${item.type}`}
          >
            <h4>{item.title}</h4>

            <div className="summary-value">
              {item.prefix && (
                <span className="summary-prefix">{item.prefix}</span>
              )}

              <strong>{item.value}</strong>

              {item.suffix && (
                <span className="summary-suffix">{item.suffix}</span>
              )}
            </div>
          </div>
        ))}
      </section>

      {/* LECTURER PROFILE */}
      <section className="lecturer-profile">
        <div className="lecturer-avatar">
          <UserRound size={48} strokeWidth={1.5} />
        </div>

        <h3>{lecturer.name}</h3>

        <span className="lecturer-id">{lecturer.nim}</span>
      </section>

      {/* LECTURER SCHEDULE */}
      <section className="lecturer-schedule">
        <div className="lecturer-schedule-header">Jadwal Pengajar</div>

        <div className="lecturer-table-wrapper">
          <table className="lecturer-table">
            <tbody>
              {schedule.length === 0 && (
                <tr>
                  <td colSpan={4}>Belum ada jadwal.</td>
                </tr>
              )}

              {schedule.map((item) => (
                <tr key={item.id}>
                  <td>{item.day}</td>
                  <td>{item.classCode}</td>
                  <td>{item.room}</td>
                  <td>{item.time}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </section>
    </div>
  );
}