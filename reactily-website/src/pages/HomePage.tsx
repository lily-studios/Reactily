import { ArrowRight } from "lucide-react";
import { DeprecatedVersionNotice } from "../components/DeprecatedVersionNotice";
import { Link } from "react-router";
import { useVersionedDocs } from "../lib/versioned-docs";
import { reactilyRuntime } from "../lib/runtime";
import { highestNumberedReleaseTag, isSupersededRelease } from "../lib/release-lifecycle";
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
  const { tag, docs, releases, path } = useVersionedDocs();
  const highestTag = highestNumberedReleaseTag(releases.filter((release) => release.channel === "stable").map((release) => release.tag));
  const outdatedVersion = tag !== null && isSupersededRelease(tag, highestTag);
  const apiDocs = docs.filter((doc) => doc.sourcePath.startsWith("api/"));
  return (
    <main>
      {outdatedVersion && tag && highestTag ? (
        <DeprecatedVersionNotice currentVersion={tag} latestVersion={highestTag} context="home" />
      ) : null}
      <section className="heroSection">
        <div className="container heroLayout">
          <div className="heroCopy">
            <span className="sectionEyebrow">
              Reactily {tag ?? `v${reactilyRuntime.version}`} · {tag ? "Release documentation" : `API v${reactilyRuntime.apiVersion}`}
            </span>
            <h1>React-style UI structure.<span>Roblox-native output.</span></h1>
            <p>
              Reactily gives strict Luau projects components, hooks, stores,
              signals, bindings, virtualization, diagnostics, and typed Roblox
              creators in one runtime. {tag ? `You are viewing documentation and public APIs from the ${tag} release.` : `Reactily v${reactilyRuntime.version} exposes ${reactilyRuntime.apiExportCount} runtime exports and ${reactilyRuntime.apiTypeCount} public types.`}
            </p>
            <div className="heroActions">
              <Link className="button primaryButton" to={path(tag ? "/docs/intro" : "/docs/getting-started")}>
                Get started <ArrowRight size={16} />
              </Link>
              <Link className="button secondaryButton" to={path("/api")}>Browse API</Link>
            </div>
            <div className="heroFacts" aria-label="Reactily facts">
              <span><strong>{tag ? apiDocs.length : reactilyRuntime.apiExportCount}</strong> {tag ? "archived API pages" : "runtime exports"}</span>
              <span><strong>{apiDocs.length}</strong> API pages</span>
              <span><strong>{docs.length}</strong> searchable docs</span>
            </div>
          </div>
          <div className="heroVisualColumn">
            {!tag ? <LuauTerminal /> : <div className="versionDocsMessage">Documentation for <strong>{tag}</strong> is loaded from its original release. Examples may differ from the current package.</div>}
          </div>
        </div>
      </section>
    </main>
  );
}
