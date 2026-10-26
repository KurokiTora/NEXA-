
import {
  Users,
  BookOpen,
  ClipboardCheck,
  TrendingUp,
  ArrowUpRight,
  ArrowRight,
  CalendarDays,
} from "lucide-react";

const statistics = [
  {
    title: "Total Students",
    value: "1,248",
    change: "+12.5%",
    Icon: Users,
  },
  {
    title: "Total Classes",
    value: "32",
    change: "+4.2%",
    Icon: BookOpen,
  },
  {
    title: "Attendance Rate",
    value: "94.8%",
    change: "+2.4%",
    Icon: ClipboardCheck,
  },
  {
    title: "Average Score",
    value: "86.4",
    change: "+5.7%",
    Icon: TrendingUp,
  },
];

const schedule = [
  {
    time: "08:00 - 09:30",
    subject: "Mathematics",
    className: "Class 10-A",
    room: "Room 201",
    status: "Ongoing",
  },
  {
    time: "10:00 - 11:30",
    subject: "Computer Science",
    className: "Class 11-B",
    room: "Lab 02",
    status: "Upcoming",
  },
  {
    time: "13:00 - 14:30",
    subject: "English",
    className: "Class 10-C",
    room: "Room 105",
    status: "Upcoming",
  },
];

const activities = [
  {
    title: "New student registered",
    detail: "A new student joined Class 10-A.",
    time: "10 minutes ago",
  },
  {
    title: "Attendance completed",
    detail: "Class 11-B attendance was submitted.",
    time: "35 minutes ago",
  },
  {
    title: "New feedback received",
    detail: "A student submitted course feedback.",
    time: "1 hour ago",
  },
];

export default function DashboardPage() {
  return (
    <div className="page-container">
      <section className="dashboard-welcome">
        <div>
          <p className="section-eyebrow">OVERVIEW</p>
          <h2 className="page-title">Welcome back, Admin!</h2>
          <p className="page-description">
            Here is what is happening with your educational platform today.
          </p>
        </div>

        <div className="dashboard-date">
          <CalendarDays size={17} />
          <span>Academic Dashboard</span>
        </div>
      </section>

      <section className="dashboard-statistics">
        {statistics.map(({ title, value, change, Icon }) => (
          <article className="dashboard-stat-card panel" key={title}>
            <div className="dashboard-stat-top">
              <span className="dashboard-stat-icon">
                <Icon size={19} />
              </span>
              <span className="dashboard-stat-change">
                <ArrowUpRight size={13} />
                {change}
              </span>
            </div>

            <p className="dashboard-stat-title">{title}</p>
            <h3 className="dashboard-stat-value">{value}</h3>
          </article>
        ))}
      </section>

      <section className="dashboard-main-grid">
        <article className="panel dashboard-schedule">
          <div className="dashboard-section-header">
            <div>
              <h3>Today's Schedule</h3>
              <p>Overview of today's classes</p>
            </div>

            <button
              type="button"
              className="dashboard-text-button"
              onClick={() => {
                window.location.href = "/classes";
              }}
            >
              View classes <ArrowRight size={14} />
            </button>
          </div>

          <div className="dashboard-table-wrapper">
            <table className="dashboard-table">
              <thead>
                <tr>
                  <th>Time</th>
                  <th>Subject</th>
                  <th>Class</th>
                  <th>Status</th>
                </tr>
              </thead>

              <tbody>
                {schedule.map((item) => (
                  <tr key={`${item.time}-${item.subject}`}>
                    <td>
                      <span className="dashboard-time">
                        {item.time}
                      </span>
                      <small>{item.room}</small>
                    </td>
                    <td>{item.subject}</td>
                    <td>{item.className}</td>
                    <td>
                      <span
                        className={`dashboard-status ${
                          item.status === "Ongoing"
                            ? "status-ongoing"
                            : "status-upcoming"
                        }`}
                      >
                        {item.status}
                      </span>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </article>

        <article className="panel dashboard-activities">
          <div className="dashboard-section-header">
            <div>
              <h3>Recent Activities</h3>
              <p>Latest platform updates</p>
            </div>
          </div>

          <div className="dashboard-activity-list">
            {activities.map((activity, index) => (
              <div
                className="dashboard-activity-item"
                key={activity.title}
              >
                <span className="dashboard-activity-dot">
                  {index + 1}
                </span>

                <div>
                  <h4>{activity.title}</h4>
                  <p>{activity.detail}</p>
                  <small>{activity.time}</small>
                </div>
              </div>
            ))}
          </div>
        </article>
      </section>
    </div>
  );
}
