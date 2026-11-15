
import { UserRound } from "lucide-react";
import "../style/dashboard.css";

const lecturer = {
  name: "Nexa Lecture",
  nim: "253100000000",
};

const statistics = [
  {
    title: "Attendant",
    value: "90%",
    type: "attendance",
  },
  {
    title: "Student",
    value: "34",
    suffix: "Person",
    type: "student",
  },
  {
    title: "Average Grade",
    value: "80",
    prefix: "Total",
    type: "grade",
  },
];

const schedule = [
  { day: "Senin", code: "T3A", room: "Kelas 403", time: "12.00 - 00.00" },
  { day: "Selasa", code: "T2A", room: "Kelas 403", time: "12.00 - 00.00" },
  { day: "Rabu", code: "T4A", room: "Kelas 403", time: "12.00 - 00.00" },
  { day: "Kamis", code: "T5A", room: "Kelas 403", time: "12.00 - 00.00" },
  { day: "Jumat", code: "T6A", room: "Kelas 403", time: "12.00 - 00.00" },
  { day: "Sabtu", code: "T7A", room: "Kelas 403", time: "12.00 - 00.00" },
  { day: "Minggu", code: "T8A", room: "Kelas 403", time: "12.00 - 00.00" },
];

export default function DashboardPage() {
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
                <span className="summary-prefix">
                  {item.prefix}
                </span>
              )}

              <strong>{item.value}</strong>

              {item.suffix && (
                <span className="summary-suffix">
                  {item.suffix}
                </span>
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

        <span className="lecturer-id">
          {lecturer.nim}
        </span>
      </section>

      {/* LECTURER SCHEDULE */}
      <section className="lecturer-schedule">
        <div className="lecturer-schedule-header">
          Jadwal Pengajar
        </div>

        <div className="lecturer-table-wrapper">
          <table className="lecturer-table">
            <tbody>
              {schedule.map((item) => (
                <tr key={item.code}>
                  <td>{item.day}</td>
                  <td>{item.code}</td>
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
