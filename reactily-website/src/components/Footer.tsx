import { Link } from "react-router";
import { reactilyRuntime } from "../lib/runtime";
import { Brand } from "./Brand";
import { useVersionedDocs } from "../lib/versioned-docs";

export function Footer() {
  const { tag, path } = useVersionedDocs();
  return (
    <footer className="siteFooter">
      <div className="footerInner">
        <div className="footerBrand">
          <Brand />
          <p>Reactily {tag ?? `v${reactilyRuntime.version}`} · {tag ? "Release documentation" : `API v${reactilyRuntime.apiVersion} · ${reactilyRuntime.apiExportCount} runtime exports`}</p>
        </div>

        <div className="footerLinks">
          <div>
            <strong>Docs</strong>
            <Link to={path("/docs/getting-started")}>Get started</Link>
            <Link to={path("/docs/guides/examples")}>Examples</Link>
            <Link to={path("/api")}>API</Link>
          </div>
          <div>
            <strong>Updates</strong>
            <Link to={path("/changelog")}>Changelog</Link>
            <a href="https://github.com/lily-studios/Reactily/releases/latest" target="_blank" rel="noreferrer">Releases</a>
          </div>
        </div>
      </div>
      <div className="footerBottom">© Lily Studios and contributors.</div>
    </footer>
  );
}
