# Reactily Documentation — React + TypeScript

Reactily documentation website built with React, React Router, Vite, strict TypeScript, TSX, `react-markdown`, and `remark-gfm`.

## Required runtime

React Router 8 requires Node 22.22.0 or newer. Node 24 LTS is recommended.

```bash
node -v
npm -v
```

## Clean install

Run these commands **inside this folder**:

```bash
rm -rf node_modules package-lock.json dist
npm install
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

## Toolchain

- React 19.3.0
- React DOM 19.3.0
- React Router 8.4.0
- Vite 8.3.3
- `@vitejs/plugin-react` 6.1.2
- TypeScript 6.0.2 (current Vite React+TS template baseline)
- Lucide React 1.52.0
- react-markdown 10.1.0
- remark-gfm 4.0.1

The startup path contains a plain-JavaScript bootstrap. If an ESM import fails before React mounts, the actual error is displayed in the page instead of leaving a white screen.

## Release selector

The header reads published versions from the GitHub Releases API. If GitHub is unavailable or rate-limited, the selector falls back to the bundled Reactily runtime version. Selecting a version opens that release on GitHub; "All GitHub releases" opens the repository release history.
