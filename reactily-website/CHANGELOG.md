# 1.1.8

- Rebuilt the distributable with a single correct `reactily-website/` project root.
- Added `npm run check:structure` to catch accidental `src/src` nesting.
- Hardened API-doc validation with a clear missing-directory error.
- Added `src/content/api` to the project doctor checks.
- Kept development docs separate from published GitHub releases.
- Preserved compact Luau terminals and multicolor Luau syntax highlighting.
- Updated startup/error fallback colors to the current cyan/teal visual system.

# 1.1.7

- Fixed the homepage Luau terminal example being parsed as JSX expressions.
- Kept the compact Luau terminal and syntax coloring intact.

## 1.1.6

- Restored the homepage terminal to real Reactily/Luau instead of TypeScript/TSX.
- Compacted the homepage terminal and documentation code blocks with tighter chrome, padding, and line height.
- Added Luau backtick/interpolated-string highlighting and a visible Luau language label.
- Kept the editor-style multicolor syntax palette for keywords, types, functions, properties, strings, numbers, and comments.

## 1.1.5 — 2026-10-07

### Compact terminal formatting

- Reduced the homepage terminal chrome, padding, footer height, and line spacing.
- Reduced documentation code-block chrome and padding for a denser editor-like layout.
- Preserved rounded shells and multicolor syntax highlighting.
- Added mobile-specific compact code spacing.

# Reactily Docs 1.1.4

- Separated unreleased Development docs from published GitHub Releases.
- The header no longer presents the development runtime version as a published release.
- GitHub release options are loaded from the repository and the newest stable release is marked Latest release.
- Added token-level syntax highlighting to Markdown code examples while preserving exact copy-to-clipboard text.
- Kept the current unreleased API surface and all 197 documented exports available in the site.

# Changelog

## 1.1.3

- Added a GitHub Releases version selector that loads up to 100 published releases and marks the newest release as Latest.
- Added a safe fallback to the bundled Reactily runtime version when GitHub is unavailable.
- Increased documentation sidebar width and click targets for easier navigation.
- Increased documentation, API, navigation, code, and supporting text sizes across the site.
- Preserved the rounded cyan/teal visual system and no-gradient rule.

## 1.1.2

- Reworked the visual palette toward a React-inspired cool cyan/teal system without copying React's exact colors.
- Added consistently rounded navigation, cards, dialogs, code blocks, API panels, and documentation controls.
- Simplified the primary navigation to Learn, API, Examples, Search, and Theme.
- Restored the homepage preview to real Reactily/Luau and kept the editor-style multicolor syntax palette.
- Reduced homepage sections and added direct getting-started/API/examples routes.
- Kept gradients and ambient glow effects out of the theme.

## 1.1.1 — 2026-10-07

### White-page hardening

- Removed the hardcoded production base path `/Reactily/`.
- Development now always uses `/`.
- GitHub Actions builds derive the Pages base automatically from `GITHUB_REPOSITORY`.
- Added `VITE_BASE_PATH` as an explicit override for other subpath deployments.
- Production now generates `404.html` from the same resolved base, preventing the router and asset base from drifting apart.
- Added a plain-JavaScript startup bootstrap that catches import-time failures before React mounts and renders the actual error instead of a blank white page.
- Added visible startup fallback markup directly in `index.html`.
- Added `npm run doctor` to validate Node and dependency resolution before starting the site.
- Hardened theme storage against privacy/security contexts where `localStorage` is unavailable.

### Documentation/toolchain alignment

- Kept React 19.3.0, React DOM 19.3.0, React Router 8.4.0, Vite 8.3.3, `@vitejs/plugin-react` 6.1.2, Lucide React 1.52.0, react-markdown 10.1.0, and remark-gfm 4.0.1.
- Switched TypeScript from 7.0.2 to 6.0.2 because the current official Vite React+TypeScript template still uses the TypeScript 6 line as its tested baseline.
- Added `@types/node` 24.19.1, matching the current Vite React+TypeScript template's Node type baseline.
- Updated `MarkdownArticle` to use react-markdown's exported `Components` type instead of manually narrowing renderer props.
- Reactily API coverage still validates at 197/197 documented exports.

## 1.1.0 — 2026-10-06

### Reactily runtime compatibility release

- Added a full Reactily 1.4.0 model with additive compatibility metadata.
- Added `apiVersion`, `versionInfo`, `features`, `hasFeature`, `isCompatible`, and the reserved `Experimental` namespace.
- Preserved older `new`, `getVersion`, `useEvent`, and `useExternalStore` entry points as deprecated compatibility aliases through the 1.x line.
- Explicitly reports DOM-only `view-transitions` and `fragment-refs` capability flags as unsupported instead of pretending Roblox has direct parity.

### Toolchain

- React 19.3.0 and React DOM 19.3.0.
- Migrated from the React Router v7 compatibility package (`react-router-dom`) to `react-router` 8.4.0.
- Raised the Node engine baseline to 22.22.0 to match React Router v8.

### Reactily API synchronization

- Synchronized the documentation against Reactily runtime 1.4.0.
- Added documentation for all 197 public exports.
- Replaced stale `useEvent` documentation with `useEffectEvent`.
- Replaced stale `useExternalStore` documentation with `useSyncExternalStore`.
- Added documentation for modern hooks including `useActionState`, `useOptimistic`, `useDevice`, `useMeasure`, `useProperty`, `useShortcut`, and `useTag`.
- Added overview pages for public namespace modules such as `Style`, `Props`, `Layout`, `Children`, `VirtualList`, and others.
- Added pages for special exports such as `Fragment`, `StrictMode`, `Suspense`, `ErrorBoundary`, `Attributes`, `Change`, `Event`, and `Tag`.
- Converted Luau examples from mislabeled TypeScript fences to `luau` code fences.
- Updated the homepage example to use PascalCase Roblox properties and current Reactily component APIs.

### Compatibility safeguards

- Added `npm run validate:api`.
- Added `npm run verify`.
- Added a React 19.3 parity guide explaining which React concepts map to Roblox and which DOM-only APIs should not be copied literally.
