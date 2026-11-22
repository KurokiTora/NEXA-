interface PageStateProps {
  loading: boolean;
  error: string;
  onRetry?: () => void;
  className?: string;
}

export default function PageState({
  loading,
  error,
  onRetry,
  className = "academic-page",
}: PageStateProps) {
  if (!loading && !error) return null;

  return (
    <div className={className}>
      {loading && <p>Loading...</p>}
      {error && (
        <>
          <p role="alert">{error}</p>
          {onRetry && (
            <button type="button" onClick={onRetry}>
              Try again
            </button>
          )}
        </>
      )}
    </div>
  );
}