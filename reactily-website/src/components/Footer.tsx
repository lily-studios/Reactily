import { Link } from "react-router";
import { reactilyRuntime } from "../lib/runtime";
import { Brand } from "./Brand";

export function Footer() {
  return (
    <footer className="siteFooter">
      <div className="footerInner">
        <div className="footerBrand">
          <Brand />
          <p>Reactily v{reactilyRuntime.version} · API v{reactilyRuntime.apiVersion} · {reactilyRuntime.apiExportCount} runtime exports</p>
        </div>

        <div className="footerLinks">
          <div>
            <strong>Docs</strong>
            <Link to="/docs/getting-started">Get started</Link>
            <Link to="/docs/guides/examples">Examples</Link>
            <Link to="/api">API</Link>
          </div>
          <div>
            <strong>Project</strong>
            <a href="https://github.com/lily-studios/Reactily" target="_blank" rel="noreferrer">GitHub</a>
            <a href="https://github.com/lily-studios/Reactily/releases/latest" target="_blank" rel="noreferrer">Releases</a>
          </div>
        </div>
      </div>
      <div className="footerBottom">© Lily Studios and contributors.</div>
    </footer>
  );
}
