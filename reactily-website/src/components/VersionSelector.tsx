import { ExternalLink } from "lucide-react";
import { reactilyRuntime } from "../lib/runtime";

export function VersionSelector() {
  return (
    <a
      className="versionSelectorShell"
      href={`https://github.com/lily-studios/Reactily/releases/tag/v${reactilyRuntime.version}`}
      target="_blank"
      rel="noreferrer"
      aria-label={`Reactily documentation for release v${reactilyRuntime.version}; open the matching GitHub release`}
      title="Open the release these docs describe"
    >
      <span className="versionSelectorCurrent">v{reactilyRuntime.version} · API v{reactilyRuntime.apiVersion}</span>
      <ExternalLink className="versionSelectorChevron" size={13} aria-hidden="true" />
    </a>
  );
}
