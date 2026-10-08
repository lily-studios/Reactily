
/* ============================================================
 * Reactily · Lily Studios
 * Vite Configuration
 * ============================================================ */

import react from "@vitejs/plugin-react";
import process from "node:process";
import { defineConfig } from "vite";
import type { Plugin } from "vite";

/* ============================================================
 * Base Path
 * ============================================================ */

function normalizeBase(value: string): string {
  const trimmed = value.trim();

  if (trimmed === "" || trimmed === "/") {
    return "/";
  }

  return `/${trimmed.replace(/^\/+|\/+$/g, "")}/`;
}

function resolveBase(command: "build" | "serve"): string {
  if (command === "serve") {
    return "/";
  }

  const explicitBase = process.env.VITE_BASE_PATH;

  if (explicitBase !== undefined) {
    return normalizeBase(explicitBase);
  }

  if (process.env.GITHUB_ACTIONS === "true") {
    const repositoryPath = process.env.GITHUB_REPOSITORY;

    if (repositoryPath) {
      const [owner, repository] = repositoryPath.split("/");

      if (owner && repository) {
        // User and organization Pages use the root path.
        if (
          repository.toLowerCase() ===
          `${owner.toLowerCase()}.github.io`
        ) {
          return "/";
        }

        // Project Pages use /repository/.
        return normalizeBase(repository);
      }
    }
  }

  return "/";
}

/* ============================================================
 * GitHub Pages SPA Support
 * ============================================================ */

function spa404Plugin(base: string): Plugin {
  const storageKey = "reactily-spa-redirect";

  const serializedBase = JSON.stringify(base);
  const serializedKey = JSON.stringify(storageKey);

  // Restore the original route before React initializes.
  const restorationScript = `
(function () {
  try {
    var stored = window.sessionStorage.getItem(
      ${serializedKey}
    );

    if (!stored) {
      return;
    }

    window.sessionStorage.removeItem(
      ${serializedKey}
    );

    var target = new URL(
      stored,
      window.location.origin
    );

    if (target.origin !== window.location.origin) {
      return;
    }

    if (!target.pathname.startsWith(${serializedBase})) {
      return;
    }

    window.history.replaceState(
      window.history.state,
      "",
      target.pathname + target.search + target.hash
    );
  } catch (_) {
    // Continue loading even if storage is unavailable.
  }
})();
`;

  // GitHub Pages serves this document for unknown URLs.
  const notFoundHtml = `<!doctype html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta
      name="viewport"
      content="width=device-width, initial-scale=1.0"
    />
    <title>Reactily · Redirecting</title>
    <script>
      (function () {
        var base = ${serializedBase};
        var key = ${serializedKey};

        var requested =
          window.location.pathname +
          window.location.search +
          window.location.hash;

        try {
          window.sessionStorage.setItem(
            key,
            requested
          );
        } catch (_) {
          // Continue to the homepage when storage is blocked.
        }

        window.location.replace(base);
      })();
    </script>
  </head>
  <body>
    <p>Redirecting to Reactily documentation...</p>
  </body>
</html>
`;

  return {
    name: "reactily-github-pages-spa",
    apply: "build",

    // Restore the route before application scripts run.
    transformIndexHtml() {
      return [
        {
          tag: "script",
          children: restorationScript,
          injectTo: "head-prepend",
        },
      ];
    },

    // Generate dist/404.html automatically.
    generateBundle() {
      this.emitFile({
        type: "asset",
        fileName: "404.html",
        source: notFoundHtml,
      });
    },
  };
}

/* ============================================================
 * Vite Configuration
 * ============================================================ */

export default defineConfig(({ command }) => {
  const base = resolveBase(command);

  return {
    /* ========================================================
     * Plugins
     * ======================================================== */

    plugins: [
      react(),
      spa404Plugin(base),
    ],

    /* ========================================================
     * Base Path
     * ======================================================== */

    base,

    /* ========================================================
     * Build Configuration
     * ======================================================== */

    build: {
      target: "es2022",
      sourcemap: true,
      outDir: "dist",
      emptyOutDir: true,
      cssCodeSplit: true,

      /* ======================================================
       * Rolldown Code Splitting
       * ====================================================== */

      rolldownOptions: {
        output: {
          codeSplitting: {
            groups: [
              /* ----------------------------------------------
               * React Core
               * ---------------------------------------------- */

              {
                name: "react-core",

                test: /[/\\]node_modules[/\\](?:react|react-dom|scheduler)(?:[/\\]|$)/,

                priority: 40,
              },

              /* ----------------------------------------------
               * React Router
               * ---------------------------------------------- */

              {
                name: "react-router",

                test: /[/\\]node_modules[/\\](?:react-router|react-router-dom)(?:[/\\]|$)/,

                priority: 30,
              },

              /* ----------------------------------------------
               * Markdown Processing
               * ---------------------------------------------- */

              {
                name: "markdown",

                test: /[/\\]node_modules[/\\](?:react-markdown|remark-[^/\\]+|rehype-[^/\\]+|unified|micromark)(?:[/\\]|$)/,

                maxSize: 300_000,

                priority: 20,
              },

              /* ----------------------------------------------
               * Syntax Highlighting
               * ---------------------------------------------- */

              {
                name: "syntax-highlighting",

                test: /[/\\]node_modules[/\\](?:shiki|@shikijs|prismjs|highlight\.js)(?:[/\\]|$)/,

                maxSize: 300_000,

                priority: 15,
              },

              /* ----------------------------------------------
               * Other Dependencies
               * ---------------------------------------------- */

              {
                name: "dependencies",

                test: /[/\\]node_modules[/\\]/,

                maxSize: 300_000,

                priority: 1,
              },
            ],
          },
        },
      },
    },
  };
});
