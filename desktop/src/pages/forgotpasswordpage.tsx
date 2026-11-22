import { useState, type FormEvent } from "react";
import { Link } from "react-router-dom";
import { Mail } from "lucide-react";
import { requestPasswordReset } from "../services/lecturerApi";

export default function ForgotPasswordPage() {
  const [email, setEmail] = useState("");
  const [message, setMessage] = useState("");
  const [error, setError] = useState("");
  const [isLoading, setIsLoading] = useState(false);

  async function handleSubmit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();

    if (!email.trim()) return;

    setError("");
    setMessage("");
    setIsLoading(true);

    try {
      await requestPasswordReset(email.trim());

      // Same message whether or not the email exists (no account enumeration)
      setMessage(
        "If this email is registered, password recovery instructions will be sent."
      );
    } catch (err) {
      setError(
        err instanceof Error
          ? err.message
          : "Unable to connect to the server."
      );
    } finally {
      setIsLoading(false);
    }
  }

  return (
    <main className="login-page">
      <section className="login-form-panel">
        <form className="login-form" onSubmit={handleSubmit}>
          <h2>Forgot Password?</h2>

          <p className="login-description">
            Enter your email address to recover your account.
          </p>

          <label htmlFor="email">Email Address</label>

          <div className="login-input-wrap">
            <Mail size={18} />
            <input
              id="email"
              type="email"
              placeholder="name@example.com"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              required
            />
          </div>

          {message && <p className="login-success">{message}</p>}
          {error && <p className="login-error">{error}</p>}

          <button
            type="submit"
            className="login-submit"
            disabled={isLoading}
          >
            {isLoading ? "Submitting..." : "Submit"}
          </button>

          <p>
            <Link to="/login">Back to Login</Link>
          </p>
        </form>
      </section>
    </main>
  );
}