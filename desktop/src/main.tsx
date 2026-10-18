
import { StrictMode } from "react";
import { createRoot } from "react-dom/client";
import App from "./app";
import "./style/global.css";
import "./style/layout.css";
import "./style/pages.css";

const rootElement = document.getElementById("root");

if (!rootElement) {
  throw new Error('Elemen dengan id "root" tidak ditemukan.');
}

createRoot(rootElement).render(
  <StrictMode>
    <App />
  </StrictMode>
);
