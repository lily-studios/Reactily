import { ArrowRight } from "lucide-react";
import { Link } from "react-router";
import { useVersionedDocs } from "../lib/versioned-docs";
import { docs, apiDocs } from "../lib/docs";
import { reactilyRuntime } from "../lib/runtime";
import { HighlightedCode } from "../components/MarkdownArticle";

function LuauTerminal() {
  const code = [
    "local function Counter(): Reactily.Element",
    "    local count, setCount = Reactily.useState(0)",
    "",
    "    return Reactily.createTextButton({",
    "        Size = UDim2.fromOffset(240, 56),",
    "        Text = `Count: {count}`,",
    "        OnActivated = function()",
    "            setCount(function(previous: number): number",
    "                return previous + 1",
    "            end)",
    "        end,",
    "    })",
    "end",
  ].join("\n");

  return (
    <div className="terminalCard" aria-label="Reactily Luau code example">
      <div className="terminalTopbar"><span className="terminalFile">Counter.client.luau</span></div>
      <pre className="terminalCode"><code><HighlightedCode source={code} /></code></pre>
    </div>
  );
}

export function HomePage() {
  const { path } = useVersionedDocs();
  return (
    <main>
      <section className="heroSection">
        <div className="container heroLayout">
          <div className="heroCopy">
            <span className="sectionEyebrow">
              Reactily v{reactilyRuntime.version} · API v{reactilyRuntime.apiVersion}
            </span>
            <h1>React-style UI structure.<span>Roblox-native output.</span></h1>
            <p>
              Reactily gives strict Luau projects components, hooks, stores,
              signals, bindings, virtualization, diagnostics, and typed Roblox
              creators in one runtime. Reactily v{reactilyRuntime.version} exposes{" "}
              {reactilyRuntime.apiExportCount} runtime exports and {reactilyRuntime.apiTypeCount} public types.
            </p>
            <div className="heroActions">
              <Link className="button primaryButton" to={path("/docs/intro")}>
                Get started <ArrowRight size={16} />
              </Link>
              <Link className="button secondaryButton" to={path("/api")}>Browse API</Link>
            </div>
            <div className="heroFacts" aria-label="Reactily facts">
              <span><strong>{reactilyRuntime.apiExportCount}</strong> runtime exports</span>
              <span><strong>{apiDocs.length}</strong> API pages</span>
              <span><strong>{docs.length}</strong> searchable docs</span>
            </div>
          </div>
          <div className="heroVisualColumn">
            <LuauTerminal />
          </div>
        </div>
      </section>
    </main>
  );
}
