
import { NavLink } from "react-router-dom";
import {
  LayoutDashboard,
  BookOpen,
  Settings,
} from "lucide-react";

const menuItems = [
  {
    label: "Dashboard",
    path: "/dashboard",
    Icon: LayoutDashboard,
  },
  {
    label: "Classes",
    path: "/classes",
    Icon: BookOpen,
  },
  {
    label: "AI Setting",
    path: "/ai-setting",
    Icon: Settings,
  },
];

export default function Sidebar() {
  return (
    <aside className="app-sidebar">
      <NavLink to="/dashboard" className="app-brand">
        NEXA
      </NavLink>

      <nav className="app-nav" aria-label="Navigasi utama">
        {menuItems.map(({ label, path, Icon }) => (
          <NavLink
            key={path}
            to={path}
            className={({ isActive }) =>
              `app-nav-link${isActive ? " active" : ""}`
            }
          >
            <Icon size={17} />
            <span>{label}</span>
          </NavLink>
        ))}
      </nav>

      <div className="app-sidebar-footer">
        <div className="app-sidebar-status">
          <span className="app-status-dot" />
          AI Assistance Active
        </div>
        <p>NEXA Platform v1.0</p>
      </div>
    </aside>
  );
}
