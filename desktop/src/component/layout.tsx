import { Outlet } from "react-router-dom";
import Sidebar from "./sidebar";
import Header from "./header";

import "../style/global.css";
import "../style/layout.css";
import "../style/pages.css";

export default function Layout() {
  return (
    <div className="app-layout">
      <Sidebar />

      <main className="app-main">
        <Header
          title="NEXA"
          description="AI Assistance Platform"
        />
        <Outlet />
      </main>
    </div>
  );
}