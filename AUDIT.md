# Reactily package audit

Audit performed 2026-10-06 against the attached source tree.

## Changes made

- Added TypeScript-familiar PascalCase Luau aliases in `src/init.luau` for
  components, elements, refs, state setters, reusable prop types, and every
  typed host creator. Existing lowercase aliases remain available.
- Updated the README with a `--!strict` component example, typed host-prop
  usage, and the correct project documentation and release links.
- Removed the incorrect `DataModel` class override from
  `test.project.json`'s `StarterPlayerScripts` node.
- Updated the manifest's source file list and line totals to match the current
  source tree.
- Updated Rokit pins to current stable releases for Rojo, Selene, and
  Luau LSP. StyLua and Wally were already at their latest stable releases.
- Removed the bundled ARM64-only `rojo` executable so the project no longer
  tries to launch a binary incompatible with Intel Macs. No packages were
  added or installed.
- Added a type-oriented regression example to `tests/reactPatterns.server.luau`.
- Standardized the library's own event-handler usage on React-style props such
  as `onActivated`. `Reactily.Event` remains available as a compatibility alias.

## Checks completed

- All 63 source modules were included in the relative `require(script...)`
  reference scan; no missing internal module targets were found.
- `default.project.json`, `model.project.json`, `test.project.json`, and
  `manifest.json` parse as JSON.
- Confirmed that the public typed GUI creators use Roblox PascalCase property
  names and expose dedicated prop types.
- Compared the bundled release model timestamp (2026-09-23) with source changes
  dated 2026-10-06. The model is stale and is not included in the updated source
  archive so it cannot be mistaken for the audited code.

## Remaining verification

Luau type analysis, Selene, StyLua, Rojo builds, and Roblox Studio runtime tests
could not be executed in this Linux workspace because those tools are not
installed here. Use a Rojo executable already present on the target machine and
matching its CPU architecture; the project no longer bundles a platform-specific
binary. Run the static checks, build `test.project.json`, then run both test
scripts in Roblox Studio before publishing a new `.rbxm`.

The implementation still uses dynamic `any` at parts of the Roblox host
property/event boundary, where property availability depends on the runtime
`Instance` class. Typed creator functions provide the strongest available
static checking; generic `createElement("ClassName", props)` remains flexible
and cannot enforce class-specific property names as strongly.
