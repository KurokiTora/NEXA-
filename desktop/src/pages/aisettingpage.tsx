
import { useState } from "react";
import { Bot, Save, RotateCcw, ShieldCheck, Sparkles } from "lucide-react";

export default function AISettingPage() {
  const [enabled, setEnabled] = useState(true);
  const [feedbackAnalysis, setFeedbackAnalysis] = useState(true);
  const [performanceInsights, setPerformanceInsights] = useState(true);
  const [level, setLevel] = useState("Balanced");
  const [language, setLanguage] = useState("English");
  const [instructions, setInstructions] = useState(
    "Provide clear, helpful, and constructive educational recommendations. Protect student privacy."
  );
  const [saved, setSaved] = useState(false);

  function handleSave() {
    // Demo only: settings are not persisted to a backend yet.
    setSaved(true);
  }

  function handleReset() {
    setEnabled(true);
    setFeedbackAnalysis(true);
    setPerformanceInsights(true);
    setLevel("Balanced");
    setLanguage("English");
    setInstructions(
      "Provide clear, helpful, and constructive educational recommendations. Protect student privacy."
    );
    setSaved(false);
  }

  return (
    <div className="page-container">
      <section>
        <p className="section-eyebrow">PLATFORM CONFIGURATION</p>
        <h2 className="page-title">AI Settings</h2>
        <p className="page-description">
          Configure how AI assistance supports teaching and student performance analysis.
        </p>
      </section>

      <section className="panel ai-status-panel">
        <div className="ai-status-icon"><Bot size={25} /></div>
        <div className="ai-status-content">
          <h3>AI Assistance</h3>
          <p>
            Enable or disable AI-powered assistance across the platform.
          </p>
          <span className={`ai-status-label ${enabled ? "ai-enabled" : "ai-disabled"}`}>
            {enabled ? "Currently enabled" : "Currently disabled"}
          </span>
        </div>
        <button
          type="button"
          role="switch"
          aria-checked={enabled}
          aria-label="Enable AI assistance"
          className={`ai-switch ${enabled ? "is-on" : ""}`}
          onClick={() => {
            setEnabled(!enabled);
            setSaved(false);
          }}
        >
          <span />
        </button>
      </section>

      <section className="panel ai-settings-panel">
        <div className="detail-panel-heading">
          <div>
            <h3><Sparkles size={17} /> AI Configuration</h3>
            <p>Choose how the AI assistant behaves</p>
          </div>
        </div>

        <div className="ai-setting-field">
          <label htmlFor="ai-level">Assistance Level</label>
          <p>Choose the level of detail used for recommendations.</p>
          <select
            id="ai-level"
            value={level}
            onChange={(event) => {
              setLevel(event.target.value);
              setSaved(false);
            }}
          >
            <option>Conservative</option>
            <option>Balanced</option>
            <option>Detailed</option>
          </select>
        </div>

        <div className="ai-setting-field">
          <label htmlFor="ai-language">Response Language</label>
          <p>Choose the default language for AI-generated responses.</p>
          <select
            id="ai-language"
            value={language}
            onChange={(event) => {
              setLanguage(event.target.value);
              setSaved(false);
            }}
          >
            <option>English</option>
            <option>Indonesian</option>
          </select>
        </div>

        <div className="ai-setting-field">
          <label>AI Features</label>

          <label className="ai-checkbox-row">
            <input
              type="checkbox"
              checked={feedbackAnalysis}
              onChange={(event) => {
                setFeedbackAnalysis(event.target.checked);
                setSaved(false);
              }}
            />
            <span>
              <strong>Feedback Analysis</strong>
              <small>Summarize student feedback and identify common themes.</small>
            </span>
          </label>

          <label className="ai-checkbox-row">
            <input
              type="checkbox"
              checked={performanceInsights}
              onChange={(event) => {
                setPerformanceInsights(event.target.checked);
                setSaved(false);
              }}
            />
            <span>
              <strong>Performance Insights</strong>
              <small>Generate learning progress insights from student scores.</small>
            </span>
          </label>
        </div>

        <div className="ai-setting-field">
          <label htmlFor="ai-instructions">Custom Instructions</label>
          <p>Provide additional guidelines for AI-generated recommendations.</p>
          <textarea
            id="ai-instructions"
            rows={5}
            value={instructions}
            onChange={(event) => {
              setInstructions(event.target.value);
              setSaved(false);
            }}
          />
        </div>

        <div className="ai-privacy-note">
          <ShieldCheck size={18} />
          <p>
            <strong>Privacy reminder</strong>
            <span>Use student information responsibly and follow your institution's data policies.</span>
          </p>
        </div>

        {saved && (
          <p className="ai-saved-message">
            Settings updated in this session. Connect a backend to save them permanently.
          </p>
        )}

        <div className="ai-settings-actions">
          <button type="button" className="ai-reset-button" onClick={handleReset}>
            <RotateCcw size={15} /> Reset
          </button>
          <button type="button" className="classes-add-button" onClick={handleSave}>
            <Save size={15} /> Save Settings
          </button>
        </div>
      </section>
    </div>
  );
}
