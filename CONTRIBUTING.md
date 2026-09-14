# Contributing to Reactily

Thank you for contributing to Reactily.

Reactily is a typed, React-inspired UI framework for Roblox Luau. Contributions should preserve its goals of predictable behavior, strong typing, explicit lifecycle ownership, efficient updates, and clean Roblox integration.

## Ways to Contribute

Contributions are welcome for:

- Bug fixes
- Performance improvements
- New framework features
- Type improvements
- Documentation
- Tests
- Examples
- Developer tooling
- API consistency improvements

For large API changes, architecture changes, or features that may affect backward compatibility, open an issue or discussion before starting implementation.

## Getting the Repository

Clone the repository:

```bash
git clone https://github.com/lily-studios/Reactily.git
cd Reactily
```

To update an existing clone:

```bash
git pull
```

You can also download the latest source from the GitHub repository or use a published GitHub Release when one is available.

## Development Requirements

You should have:

- Roblox Studio
- Git
- A Luau-capable editor such as Visual Studio Code
- Luau language support
- StyLua for formatting

If the project is being synchronized with Roblox Studio through Rojo, install and configure Rojo for your local workflow.

## Code Style

All contributions must follow the **Lily Studio Coding Convention**.

Keep code clean, consistent, typed, efficient, and aligned with the existing Reactily codebase.

## Formatting

Use StyLua to format Luau source files.

Format the repository before submitting a pull request.

Depending on your local setup:

```bash
stylua .
```

Do not manually reformat unrelated files in the same pull request.

Keep diffs focused on the change being submitted.

## Testing

Changes should be tested before opening a pull request.

At minimum:

- Confirm the changed code runs under `--!strict`.
- Confirm existing behavior still works.
- Test expected success cases.
- Test invalid or edge-case input when relevant.
- Verify cleanup behavior.
- Verify repeated setup and teardown do not leak resources.
- Verify idle systems stop doing runtime work.
- Verify unchanged state does not trigger redundant updates.

For performance-sensitive changes, test both small and large workloads where practical.

Bug fixes should ideally include a regression test or a clear reproduction case.

## Documentation

Update documentation when a contribution changes:

- Public APIs
- Function signatures
- Behavior
- Installation
- Lifecycle semantics
- Cleanup requirements
- Examples
- Supported Roblox objects or features

Code examples should be valid Luau and should follow the same formatting conventions as the source.

Use GitHub-compatible Markdown.

## Commit Guidelines

Keep commits focused and understandable.

Good commit messages describe the actual change:

```text
fix binding cleanup after root deletion
```

```text
add typed viewport frame creator
```

```text
reduce redundant store notifications
```

Avoid vague messages such as:

```text
update
```

```text
fix stuff
```

```text
changes
```

Large contributions may contain multiple commits, but each commit should represent a coherent change.

## Pull Requests

Before opening a pull request:

- Rebase or update your branch against the current target branch.
- Format changed Luau files.
- Run relevant tests.
- Remove debugging code.
- Remove unused files.
- Review the diff for accidental changes.
- Update documentation when required.

A pull request should explain:

1. What changed.
2. Why the change is needed.
3. How it was tested.
4. Whether it changes public behavior or APIs.
5. Any performance or lifecycle implications.

Screenshots or videos are useful for changes that affect visible Roblox UI behavior.

## Pull Request Scope

Keep pull requests focused.

Avoid combining unrelated work such as:

- API additions
- Large refactors
- Formatting the entire repository
- Documentation rewrites
- Unrelated bug fixes

Separate unrelated work into separate pull requests whenever practical.

## Breaking Changes

Breaking changes require extra consideration.

A breaking change includes changes to:

- Public function names
- Parameters
- Return values
- Exported types
- Lifecycle behavior
- Cleanup behavior
- Existing semantics relied on by callers

Clearly label breaking changes in the pull request description.

When possible, prefer a migration path over immediately removing an existing API.

## Issues

When reporting a bug, include:

- A clear description
- Expected behavior
- Actual behavior
- A minimal reproduction
- Relevant error output
- Roblox Studio context when relevant
- Reactily version or commit
- Any important environment information

For feature requests, explain the problem first and the proposed API second.

This helps determine whether a new API is necessary or whether an existing Reactily feature can solve the same problem.

## Security

Do not publicly disclose security-sensitive vulnerabilities before maintainers have had a reasonable opportunity to investigate them.

For sensitive reports, use the repository's private security reporting method when available.

## Generated Files

Do not commit generated output, temporary files, editor caches, or local environment files unless the repository explicitly requires them.

Examples may include:

- Build output
- Temporary test files
- Editor metadata
- Local logs
- OS-generated files

Follow the repository's `.gitignore`.

## License

Reactily is licensed under the **MIT License**.

By contributing to Reactily, you agree that your contributions may be distributed under the MIT License.

## Questions

If you are unsure whether a change fits Reactily, open an issue or discussion before investing significant work into the implementation.

Focused contributions that preserve Reactily's typing, lifecycle, performance, and API consistency are preferred.
