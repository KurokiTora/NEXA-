
import { Bell, LogOut } from "lucide-react";
import { useNavigate } from "react-router-dom";

interface HeaderProps {
  title: string;
  description?: string;
}

export default function Header({
  title,
  description,
}: HeaderProps) {
  const navigate = useNavigate();

  function handleLogout() {
    if (window.confirm("Apakah kamu yakin ingin logout?")) {
      navigate("/login");
    }
  }

  return (
    <header className="app-header">
      <div>
        <h1 className="app-header-title">{title}</h1>
        {description && (
          <p className="app-header-description">
            {description}
          </p>
        )}
      </div>

      <div className="app-header-actions">
        <button
          type="button"
          className="app-icon-button"
          aria-label="Notifikasi"
        >
          <Bell size={17} />
        </button>

        <button
          type="button"
          className="app-logout-button"
          onClick={handleLogout}
        >
          <LogOut size={15} />
          Logout
        </button>
      </div>
    </header>
  );
}
