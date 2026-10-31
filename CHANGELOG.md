# Changelog

All notable changes to this project are documented here.
The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and the project uses [Semantic Versioning](https://semver.org/).

## [Unreleased]

## [2.0.0] - 2026-10-31

### Added

- Screenshot in the README (`docs/screenshot.png`).
- Release badge in the README.

### Changed

- **Breaking:** the plugin id is now `w3asd.quicknum` instead of `quicknum`.
  The Omarchy docs recommend a personal prefix so that plugin ids from different
  authors cannot collide. Commands, the bar widget and the install folder use
  the new id. To upgrade an existing install, see "Upgrading from 1.x" in the README.
- `bin/install.sh` reads the id from `manifest.json` and reports errors instead
  of claiming success. It refuses to overwrite a checkout made by
  `omarchy plugin add` and hints when `omarchy.menu` is still enabled.
- Removed `hypr/quicknum.lua`, a Lua module that did nothing. The README
  explains how to bind QuickNum to a custom key.
- `.gitignore` no longer lists Python files.

## [1.2.0] - 2026-10-31

### Fixed

- The numpad works in the menu even when Qt's NumLock state is out of sync,
  for example after hovering another window. Numpad keys that arrive as
  navigation keys are read as their digits
  ([omacom/omarchy#8552](https://github.com/omacom/omarchy/issues/8552)).
  Trade-off: with NumLock really off, the numpad no longer navigates the menu.

### Added

- Setting `quickNumKeypadAlwaysDigits` (default `true`) to turn the numpad
  workaround off for people who navigate with the numpad arrows.

### Changed

- Number-key selection logic moved into `tryQuickNum()`, so the number row
  and the numpad use the same rules.

## [1.1.0] - 2026-10-31

### Fixed

- **Apps** submenu and application search were empty on Omarchy 4.0.x.
  Omarchy passes third-party menu plugins a `null` `appLibrary`
  ([omacom/omarchy#15617](https://github.com/omacom/omarchy/issues/15617)).
  QuickNum now loads Omarchy's own `AppLibrary.qml` as a fallback while the
  host provides none. Details: [docs/known-issues.md](docs/known-issues.md).
  Tested on Omarchy 4.0.6-1: 0 → 55 app rows.

- Digits can now be typed into a running search, from the number row and
  the numpad. Before, `1`–`9` always selected a row, and numpad digits never
  reached the search.

### Changed

- `quickNumInSearch` now defaults to `false`: number keys select rows only
  while the search is empty. The special case that let the numpad select during
  a search was removed.
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

[Unreleased]: https://github.com/W3asd/omarchy-quicknum/compare/v2.0.0...HEAD
[2.0.0]: https://github.com/W3asd/omarchy-quicknum/compare/v1.2.0...v2.0.0
[1.2.0]: https://github.com/W3asd/omarchy-quicknum/compare/v1.1.0...v1.2.0
[1.1.0]: https://github.com/W3asd/omarchy-quicknum/compare/v1.0.0...v1.1.0
[1.0.0]: https://github.com/W3asd/omarchy-quicknum/releases/tag/v1.0.0
