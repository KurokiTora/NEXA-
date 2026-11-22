
import { useState, type FormEvent } from "react";
import { Link, useNavigate } from "react-router-dom";
import { Eye, EyeOff, LockKeyhole, Mail } from "lucide-react";
import { apiRequest } from "../services/api";

interface LoginResponse {
  success: boolean;
  message: string;
  data: {
    token: string;
    user: {
      id: number;
      email: string;
      role: string;
    };
  } | null;
}

export default function LoginPage() {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [showPassword, setShowPassword] = useState(false);
  const [error, setError] = useState("");
  const [isLoading, setIsLoading] = useState(false);

  const navigate = useNavigate();

  async function handleSubmit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();

    if (!email.trim() || !password.trim()) {
      setError("Please enter your email and password.");
      return;
    }

    setError("");
    setIsLoading(true);

    try {
      const result = await apiRequest<LoginResponse>("/auth/login", {
        method: "POST",
        body: JSON.stringify({
          email: email.trim(),
          password,
        }),
      });

      if (!result.success || !result.data) {
        throw new Error(result.message || "Login failed.");
      }

      localStorage.setItem("nexa_token", result.data.token);

      localStorage.setItem(
        "nexa_user",
        JSON.stringify(result.data.user)
      );

      navigate("/dashboard");
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
          <div className="login-logo">
            <img src="/asset/image/Nexa_Logo.png" alt="NEXA Logo" />
          </div>

          <p className="section-eyebrow">WELCOME BACK</p>
          <h2>Sign in to NEXA</h2>
          <p className="login-description">
            Enter your account details to continue.
          </p>

          <label htmlFor="login-email">Email Address</label>
          <div className="login-input-wrap">
            <Mail size={18} />
            <input
              id="login-email"
              type="email"
              placeholder="name@example.com"
              value={email}
              onChange={(event) => setEmail(event.target.value)}
              autoComplete="email"
              required
            />
          </div>

          <label htmlFor="login-password">Password</label>
          <div className="login-input-wrap">
            <LockKeyhole size={18} />
            <input
              id="login-password"
              type={showPassword ? "text" : "password"}
              placeholder="Enter your password"
              value={password}
              onChange={(event) => setPassword(event.target.value)}
              autoComplete="current-password"
              required
            />

            <button
              type="button"
              className="login-password-toggle"
              onClick={() => setShowPassword(!showPassword)}
              aria-label={showPassword ? "Hide password" : "Show password"}
            >
              {showPassword ? <EyeOff size={18} /> : <Eye size={18} />}
            </button>
          </div>

          {error && <p className="login-error">{error}</p>}

          <div className="login-options">
            <label className="login-remember">
              <input type="checkbox" />
              Remember me
            </label>

            <Link
              to="/forgot-password"
              className="login-link-button"
            >
              Forgot password?
            </Link>
          </div>

          <button
            type="submit"
            className="login-submit"
            disabled={isLoading}
          >
            {isLoading ? "Signing In..." : "Sign In"}
          </button>

          <p className="login-disclaimer">
            By signing in, you agree to the platform&apos;s terms and policies.
          </p>
        </form>
      </section>
    </main>
  );
}
