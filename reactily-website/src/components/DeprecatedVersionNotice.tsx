import { ArrowRight, TriangleAlert } from "lucide-react";
import { Link } from "react-router";

type DeprecatedVersionNoticeProps = {
  readonly currentVersion: string;
  readonly latestVersion: string;
  readonly context: "api" | "doc" | "home";
};

/** Display a centered deprecated-release notice with a link to current documentation. */
export function DeprecatedVersionNotice({
  currentVersion,
  latestVersion,
  context,
}: DeprecatedVersionNoticeProps) {
  const details = context === "api"
    ? `A newer stable major release (${latestVersion}) exists. These APIs are preserved from ${currentVersion}; this does not automatically deprecate each API.`
    : context === "doc"
      ? `A newer stable major release (${latestVersion}) is available. This page documents the original ${currentVersion} release; individual APIs are only deprecated when explicitly marked.`
      : `A newer stable major release (${latestVersion}) is available. Documentation for ${currentVersion} remains accessible.`;
  const destination = context === "home" ? "/" : "/api";
  const latestDocsUrl = `${destination}?version=${encodeURIComponent(latestVersion)}`;

  return (
    <div className="deprecatedNotice deprecatedNotice--release" role="note" aria-label="Deprecated release notice">
      <TriangleAlert size={18} aria-hidden="true" />
      <div className="deprecatedNoticeContent">
        <strong>Deprecated version: {currentVersion}</strong>
        <p>{details}</p>
      </div>
      <Link className="button secondaryButton deprecatedNoticeAction" to={latestDocsUrl}>
        View latest version <ArrowRight size={15} aria-hidden="true" />
      </Link>
    </div>
  );
}
