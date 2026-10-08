import { ArrowRight } from "lucide-react";
import { Link } from "react-router";
import { apiDocs, docs } from "../lib/docs";
import { reactilyRuntime } from "../lib/runtime";

function LuauTerminal() {
  return (
    <div className="terminalCard" aria-label="Reactily Luau code example">
      <div className="terminalTopbar">
        <span className="terminalFile">Counter.client.luau</span>
      </div>
      <pre className="terminalCode"><code>
        <span className="syntaxKeyword">local function</span>{" Counter(): "}<span className="syntaxType">Reactily.Element</span>{"\n"}
        {"  "}<span className="syntaxKeyword">local</span>{" count, setCount = "}<span className="syntaxType">Reactily</span>.<span className="syntaxFunction">useState</span>(<span className="syntaxNumber">0</span>){"\n\n"}
        {"  "}<span className="syntaxKeyword">return</span>{" "}<span className="syntaxType">Reactily</span>.<span className="syntaxFunction">createTextButton</span>({"{"}{"\n"}
        {"    "}<span className="syntaxProperty">Size</span>{" = "}<span className="syntaxType">UDim2</span>.fromOffset(<span className="syntaxNumber">240</span>, <span className="syntaxNumber">56</span>),{"\n"}
        {"    "}<span className="syntaxProperty">Text</span>{" = "}<span className="syntaxString">{'`Count: {count}`'}</span>,{"\n"}
        {"    "}<span className="syntaxProperty">OnActivated</span>{" = "}<span className="syntaxKeyword">function</span>(){"\n"}
        {"      "}setCount(<span className="syntaxKeyword">function</span>(previous){"\n"}
        {"        "}<span className="syntaxKeyword">return</span>{" previous + "}<span className="syntaxNumber">1</span>{"\n"}
        {"      "}<span className="syntaxKeyword">end</span>){"\n"}
        {"    "}<span className="syntaxKeyword">end</span>,{"\n"}
        {"  })\n"}
        <span className="syntaxKeyword">end</span>
      </code></pre>
    </div>
  );
}

export function HomePage() {
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
              <Link className="button primaryButton" to="/docs/getting-started">
                Get started <ArrowRight size={16} />
              </Link>
              <Link className="button secondaryButton" to="/api">Browse API</Link>
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
