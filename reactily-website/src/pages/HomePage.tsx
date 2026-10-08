import { ArrowRight, BookOpen, Boxes, Code2, Gauge, Layers3 } from "lucide-react";
import { Link } from "react-router";
import { apiDocs, docs } from "../lib/docs";
import { reactilyRuntime } from "../lib/runtime";

function LuauTerminal() {
  return (
    <div className="terminalCard" aria-label="Reactily Luau component example">
      <div className="terminalTopbar">
        <span className="terminalDots" aria-hidden="true">
          <i />
          <i />
          <i />
        </span>
        <span className="terminalFile">Counter.client.luau</span>
        <span className="terminalLanguage">LUAU</span>
      </div>

      <pre className="terminalCode">
        <code>
          <span className="syntaxKeyword">type</span>{" "}
          <span className="syntaxType">CounterProps</span>{" = { "}
          <span className="syntaxProperty">Label</span>{": "}
          <span className="syntaxType">string</span>{" }\n"}
          <span className="syntaxKeyword">local function</span>{" "}
          <span className="syntaxFunction">Counter</span>{"(props: "}
          <span className="syntaxType">CounterProps</span>{"): "}
          <span className="syntaxType">Reactily.Element</span>{"\n"}
          {"\t"}<span className="syntaxKeyword">local</span>{" count, setCount = "}
          <span className="syntaxType">Reactily</span>{"."}
          <span className="syntaxFunction">useState</span>{"("}
          <span className="syntaxNumber">0</span>{")\n"}
          {"\t"}<span className="syntaxKeyword">return</span>{" "}
          <span className="syntaxType">Reactily</span>{"."}
          <span className="syntaxFunction">createTextButton</span>{"({\n"}
          {"\t\t"}<span className="syntaxProperty">Size</span>{" = "}
          <span className="syntaxType">UDim2</span>{"."}
          <span className="syntaxFunction">fromOffset</span>{"("}
          <span className="syntaxNumber">220</span>{", "}
          <span className="syntaxNumber">48</span>{"),\n"}
          {"\t\t"}<span className="syntaxProperty">Text</span>{" = "}
          <span className="syntaxString">{"`{props.Label}: {count}`"}</span>{",\n"}
          {"\t\t"}<span className="syntaxProperty">OnActivated</span>{" = "}
          <span className="syntaxKeyword">function</span>{"()\n"}
          {"\t\t\t"}<span className="syntaxFunction">setCount</span>{"(count + "}
          <span className="syntaxNumber">1</span>{")\n"}
          {"\t\t"}<span className="syntaxKeyword">end</span>{",\n"}
          {"\t"}{"})\n"}
          <span className="syntaxKeyword">end</span>
        </code>
      </pre>

      <div className="terminalFooter">
        <span>Roblox client</span>
        <span>Reactily state</span>
        <span>typed Luau</span>
      </div>
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

            <h1>
              React-style UI structure.
              <span>Roblox-native output.</span>
            </h1>

            <p>
              Reactily gives strict Luau projects components, hooks, stores,
              signals, bindings, virtualization, diagnostics, and typed Roblox
              creators in one runtime. Reactily v{reactilyRuntime.version} exposes {reactilyRuntime.apiExportCount} runtime exports and {reactilyRuntime.apiTypeCount} public types.
            </p>

            <div className="heroActions">
              <Link className="button primaryButton" to="/docs/getting-started">
                Get started <ArrowRight size={16} />
              </Link>
              <Link className="button secondaryButton" to="/api">
                Browse API
              </Link>
            </div>

            <div className="heroFacts" aria-label="Reactily facts">
              <span><strong>{reactilyRuntime.apiExportCount}</strong> runtime exports</span>
              <span><strong>{apiDocs.length}</strong> API pages</span>
              <span><strong>{docs.length}</strong> searchable docs</span>
            </div>
          </div>

          <div className="heroVisualColumn">
            <LuauTerminal />
            <p className="terminalNote">
              Real Reactily/Luau code with an editor-style multicolor syntax palette.
            </p>
          </div>
        </div>
      </section>

      <section className="container section startSection">
        <div className="sectionHeading compactHeading">
          <span className="sectionEyebrow">Start here</span>
          <h2>Four routes. No digging.</h2>
          <p>
            Pick the page that matches what you are trying to do instead of navigating a large landing page first.
          </p>
        </div>

        <div className="startGrid">
          <Link className="startCard startCardPrimary" to="/docs/getting-started">
            <span className="startIcon"><BookOpen size={20} /></span>
            <div>
              <span className="startMeta">First project</span>
              <h3>Getting started</h3>
              <p>Set up the package, create a root, render a component, and connect state.</p>
            </div>
            <ArrowRight size={18} />
          </Link>

          <div className="startStack">
            <Link className="startCard" to="/api">
              <span className="startIcon"><Code2 size={19} /></span>
              <div>
                <span className="startMeta">{apiDocs.length} pages</span>
                <h3>API reference</h3>
                <p>Search hooks, creators, state, signals, animation, and runtime APIs.</p>
              </div>
              <ArrowRight size={18} />
            </Link>

            <Link className="startCard" to="/docs/guides/examples">
              <span className="startIcon"><Boxes size={19} /></span>
              <div>
                <span className="startMeta">Real patterns</span>
                <h3>Examples</h3>
                <p>Jump directly into component, state, and UI composition examples.</p>
              </div>
              <ArrowRight size={18} />
            </Link>
          </div>
        </div>
      </section>

      <section className="featureSection">
        <div className="container featureLayout">
          <article className="featureMain">
            <span className="featureBadge"><Gauge size={20} /></span>
            <span className="sectionEyebrow">Virtualization</span>
            <h2>1,000 inventory rows do not need 1,000 mounted UI rows.</h2>
            <p>
              Reactily includes virtual-list, variable-list, virtual-grid, and virtual-window APIs for inventories,
              browsers, command lists, and other large collections.
            </p>
            <Link className="textLink" to="/docs/api/virtualization/create-virtual-list">
              Read virtualization docs <ArrowRight size={15} />
            </Link>
          </article>

          <div className="featureStack">
            <article className="featureSmall">
              <span className="featureBadge"><Layers3 size={19} /></span>
              <h3>Roblox props stay recognizable.</h3>
              <p>
                `Size`, `BackgroundColor3`, and other host properties keep Roblox-style names instead of becoming DOM-like aliases.
              </p>
            </article>

            <article className="featureSmall featureSmallAccent">
              <span className="startMeta">API v{reactilyRuntime.apiVersion}</span>
              <h3>{reactilyRuntime.compatibilityLine}</h3>
              <p>Check compatibility before adopting newer runtime features.</p>
              <Link className="textLink" to="/docs/api/package/compatibility">
                Compatibility API <ArrowRight size={15} />
              </Link>
            </article>
          </div>
        </div>
      </section>

      <section className="container section finalCtaSection">
        <div className="finalCta">
          <div>
            <span className="sectionEyebrow">Ready to build</span>
            <h2>Start with one root and one component.</h2>
            <p>
              The getting-started guide moves from package setup to a rendered Roblox UI tree without making you learn the entire API first.
            </p>
          </div>
          <div className="finalCtaActions">
            <Link className="button primaryButton" to="/docs/getting-started">
              Open guide <ArrowRight size={16} />
            </Link>
            <Link className="button secondaryButton" to="/api">
              API reference
            </Link>
          </div>
        </div>
      </section>
    </main>
  );
}
