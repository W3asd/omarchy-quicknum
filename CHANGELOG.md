# Changelog

All notable changes to this project are documented here.
The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and the project uses [Semantic Versioning](https://semver.org/).

## [Unreleased]

### Fixed

- **Apps** submenu and application search were empty on Omarchy 4.0.x.
  Omarchy passes third-party menu plugins a `null` `appLibrary`
  ([omacom/omarchy#15617](https://github.com/omacom/omarchy/issues/15617)).
  QuickNum now loads Omarchy's own `AppLibrary.qml` as a fallback while the
  host provides none. Details: [docs/known-issues.md](docs/known-issues.md).
  Tested on Omarchy 4.0.6-1: 0 → 55 app rows.

### Changed

- `manifest.json`: author is now `W3asd` instead of
  "Omarchy Community"; descriptions are in English.
- `LICENSE`: added the copyright notice of Omarchy, from which `Menu.qml` and
  `MenuModel.js` are derived, as the MIT license requires.

### Added

- English `README.md` (German moved to `README.de.md`) with a note that the
  project is AI-generated
- `CHANGELOG.md`, `CONTRIBUTING.md`, `docs/known-issues.md`, `docs/development.md`
- GitHub bug-report template

## [1.0.0] - 2026-10-30

### Added

- First release: menu overlay based on the built-in Omarchy menu, with
  direct selection via the number keys and numpad 1–9 and right-aligned number badges.
