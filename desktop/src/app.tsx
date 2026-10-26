import {
  BrowserRouter,
  Navigate,
  Route,
  Routes,
} from "react-router-dom";

import LoginPage from "./pages/loginpage";
import DashboardPage from "./pages/dashboard";
import ClassDetailPage from "./pages/classdetailpage";
import StudentDetailPage from "./pages/studentdetailpage";
import StudentFeedbackPage from "./pages/studentfeedbackpage";
import AISettingPage from "./pages/aisettingpage";
import Layout from "./component/layout";

export default function App() {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/login" element={<LoginPage />} />

        <Route element={<Layout />}>
          <Route path="/dashboard" element={<DashboardPage />} />
          <Route
            path="/classes/:classId"
            element={<ClassDetailPage />}
          />
          <Route
            path="/students/:studentId"
            element={<StudentDetailPage />}
          />
          <Route
            path="/feedback"
            element={<StudentFeedbackPage />}
          />
          <Route path="/ai-setting" element={<AISettingPage />} />
        </Route>

        <Route path="*" element={<Navigate to="/login" replace />} />
      </Routes>
    </BrowserRouter>
  );
}