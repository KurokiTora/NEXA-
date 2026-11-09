
interface CardProps {
  title: string;
  subtitle?: string;
  status?: string;
  grade?: number | null;
  footer?: string;
  actionLabel?: string;
  onAction?: () => void;
}

export default function Card({
  title,
  subtitle,
  status,
  grade,
  footer,
  actionLabel,
  onAction,
}: CardProps) {
  return (
    <div className="academic-card">
      <div className="academic-card-content">
        <div>
          <h3>{title}</h3>

          {subtitle && (
            <p className="academic-card-subtitle">{subtitle}</p>
          )}

          {status && (
            <span className={`academic-status ${
              status === "Completed" ? "completed" : "not-completed"
            }`}>
              {status}
            </span>
          )}
        </div>

        {grade !== undefined && (
          <div className="academic-card-grade">
            <span>Grade</span>
            <strong>{grade ?? "—"}</strong>
          </div>
        )}
      </div>

      {footer && (
        <p className="academic-card-footer">{footer}</p>
      )}

      {actionLabel && (
        <div className="academic-card-action">
          <button onClick={onAction}>{actionLabel}</button>
        </div>
      )}
    </div>
  );
}
