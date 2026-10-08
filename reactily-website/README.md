# Reactily Documentation — React + TypeScript

Reactily documentation website built with React, React Router, Vite, strict TypeScript, TSX, `react-markdown`, and `remark-gfm`.

## Required runtime

React Router 8 requires Node 22.22.0 or newer. Node 24 LTS is recommended.

```bash
node -v
npm -v
```

## Clean install

Run these commands **inside this folder**. `npm ci` installs the exact dependency versions recorded in `package-lock.json`:

```bash
npm ci
npm run doctor
npm run typecheck
npm run dev
```

Open the exact URL printed by Vite, normally:

```text
http://localhost:5173/
```

Do **not** open the source `index.html` directly and do not serve the source tree with VS Code Live Server. Vite must transform TSX and `import.meta.glob()`.

## Verification

```bash
npm run verify
```

This runs environment checks, strict TypeScript checking, Reactily API documentation coverage, and the production Vite build.

## Deployment base

Development always uses `/`.

For GitHub Actions, the production base is automatically derived from `GITHUB_REPOSITORY`, so a repository such as `lily-studios/reactily-luau` builds for `/reactily-luau/` without hardcoding the repository name.

For another subpath, set it explicitly:

```bash
VITE_BASE_PATH=/my-site/ npm run build
```

For a custom domain hosted at the root:

```bash
npm run build
```

## GitHub Pages deployment

The workflow in `.github/workflows/deploy.yml` installs the lockfile, runs the full verification suite, and deploys `dist` with the official Pages actions. In repository settings, set **Pages → Build and deployment → Source** to **GitHub Actions**. Pushes to `main` affecting the website or workflow trigger verification and deployment. The workflow can also be started manually.

## Toolchain

- React 19.3.0
- React DOM 19.3.0
- React Router 8.4.0
- Vite 8.3.3
- `@vitejs/plugin-react` 6.1.2
- TypeScript 7.0.2
- Lucide React 1.52.0
- react-markdown 10.1.0
- remark-gfm 4.0.1

The startup path contains a TypeScript bootstrap. If an ESM import fails before React mounts, the actual error is displayed in the page instead of leaving a white screen.

## Versioned documentation

The version menu switches between the documentation snapshots generated from each published GitHub release's **exact Git tag**. APIs, guides, examples, sidebar, and search are scoped to the selected release. Version selection is preserved in the URL with `?version=v1.1.0`.

GitHub Pages builds run `scripts/sync-release-snapshots.mjs` before building the website. GitHub releases (including Experimental and Pre-release) automatically trigger a new Pages build. Each snapshot comes from the release's original Markdown files. Releases that predate the website, such as v1.1.0, are reconstructed from their tagged README and public Luau exports. An unavailable snapshot shows an error rather than unrelated documentation.

The current unreleased documentation is available by selecting **Current website docs**. When publishing a new stable release, update `src/lib/runtime.ts` and `src/lib/public-api-manifest.json` together.

## API availability and status in Markdown

Add the following optional frontmatter to any API or guide `.md` file:

```yaml
---
title: Reactily.example
since: v2.0.0
deprecated_since: v2.2.0
removed_in: v3.0.0
deprecation_message: This API will be removed.
replacement: Reactily.createElement
experimental: false
---
```

Use `deprecated: true` to mark the API deprecated immediately instead of using a version threshold. `since` and `removed_in` control which versions show the API; the tagged release archive is authoritative for whether an API actually existed in that release. Deprecated APIs display an amber warning and, if provided, their replacement. Experimental APIs display a purple warning.

Mark an individual code example without changing the entire page:

````markdown
```luau experimental
-- Code that may contain bugs or change
```

```luau deprecated
-- Code using an outdated API
```
````

Only APIs present in a release's source archive should be documented for that version. Never reuse newer API examples under an older release label.

## Automatic deprecated-version labels

When a numbered GitHub release is published, every release with a lower numeric version is automatically labeled **Deprecated** in the version menu, changelog, and documentation views. Version comparisons work with tags such as `v1`, `v1.1`, `v1.1.0`, `v.2.0`, `2.0.1-beta`, and `v2.1.1 Experimental`. Missing numeric components are interpreted as zero, so `v1.1` and `v1.1.0` represent the same number. Channel labels (Stable, Pre-release, Experimental) remain independent. An Experimental release can supersede an older stable release without becoming the default stable documentation.

Purely word-based tags without a version number cannot be numerically compared and are not automatically marked deprecated. Deprecating a **release** is different from deprecating individual APIs: API deprecation still requires `deprecated: true` or `deprecated_since` in the API Markdown. Older release docs remain accessible and unchanged.
