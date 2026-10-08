import react from "@vitejs/plugin-react";
import { defineConfig } from "vite";
import type { Plugin } from "vite";

function normalizeBase(value: string): string {
  const trimmed = value.trim();
  if (trimmed === "" || trimmed === "/") return "/";
  return `/${trimmed.replace(/^\/+|\/+$/g, "")}/`;
}

function resolveBase(command: "build" | "serve"): string {
  if (command === "serve") return "/";

  const explicitBase = process.env.VITE_BASE_PATH;
  if (explicitBase) return normalizeBase(explicitBase);

  // GitHub Actions exposes owner/repository through GITHUB_REPOSITORY.
  // Project Pages are hosted below /<repository>/ unless a custom domain is used.
  if (process.env.GITHUB_ACTIONS === "true") {
    const repository = process.env.GITHUB_REPOSITORY?.split("/")[1];
    if (repository) return normalizeBase(repository);
  }

  // Root hosting is the safest default for local production builds and custom domains.
  return "/";
}

function spa404Plugin(base: string): Plugin {
  return {
    name: "reactily-spa-404",
    apply: "build",
    generateBundle() {
      const serializedBase = JSON.stringify(base);
      const source = `<!doctype html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Reactily</title>
    <script>
      (function () {
        var base = ${serializedBase};
        var requested = window.location.pathname + window.location.search + window.location.hash;
        try {
          window.sessionStorage.setItem("reactily-spa-redirect", requested);
        } catch (_) {}
        window.location.replace(base);
      })();
    </script>
  </head>
  <body></body>
</html>\n`;

      this.emitFile({
        type: "asset",
        fileName: "404.html",
        source,
      });
    },
  };
}

export default defineConfig(({ command }) => {
  const base = resolveBase(command);

  return {
    plugins: [react(), spa404Plugin(base)],
    base,
    build: {
      target: "es2022",
      sourcemap: true,
    },
  };
});
