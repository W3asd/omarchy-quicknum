# Contributing

Thanks for your interest! Issues and pull requests are welcome.

## Reporting a bug

Please use the bug-report template and include:

- `omarchy version`
- what you did, what you expected, what happened
- relevant lines from `journalctl --user -b | grep omarchy-shell`

Check [docs/known-issues.md](docs/known-issues.md) first.

## Making changes

1. Create a branch from `main` (`fix/…`, `feat/…`, `docs/…`).
2. Make the change and follow the existing QML style. If you work around an
   Omarchy bug, add a comment with a link to the upstream issue.
3. Run `./tests/validate.sh` and the manual checklist in
   [docs/development.md](docs/development.md#manual-test-checklist).
4. Add an entry under **Unreleased** in [CHANGELOG.md](CHANGELOG.md).
5. Write the commit message as `type(scope): summary`, for example
   `fix(menu): fall back to own AppLibrary`, and explain *why* in the body.

## AI-generated code

This project is fully AI-generated (see the README). AI-assisted contributions
are welcome. Please review and test them before you open a pull request.
