# Omarchy QuickNum

[Deutsch](README.de.md) · **English**

[![Omarchy Plugin](https://img.shields.io/badge/Omarchy-plugin-blue?style=flat-square)](https://omarchy.org)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=flat-square)](LICENSE)
[![AI-generated](https://img.shields.io/badge/code-AI--generated-lightgrey?style=flat-square)](#ai-generated)

**QuickNum** is a plugin for [Omarchy](https://omarchy.org/). It replaces the
built-in Omarchy menu with a version where you choose each of the first nine
rows directly with the number keys `1`–`9` (or the numpad). Right-aligned badges show the numbers.

> [!NOTE]
> <a id="ai-generated"></a>**This project is fully AI-generated.** The first version was created with
> Google Antigravity. Bug fixes and documentation were done with Claude Code
> (Anthropic). Each change is tested on a real Omarchy system, but the code
> was not written by hand. Please keep this in mind and review the
> code before you enable it. Plugins run unsandboxed inside `omarchy-shell`.

## Features

- **Number keys and numpad `1`–`9`** run the matching row immediately, so you
  can step through nested menus quickly (e.g. `3` → `1`).
- **Right-aligned badges:** long titles are truncated with `…`, so the badges always line up.
- **Search as usual:** typing filters the list, and the badges follow the results.
  Once a search has started, digits are typed into it.
- **Drop-in replacement:** the manifest declares `clonedFrom: "omarchy.menu"`,
  so existing shortcuts (`Super + Space`, `Super + Alt + Space`) open QuickNum
  without any config changes.

## Compatibility

| Omarchy | Status |
|---|---|
| 4.0.6 | tested (1.1.0) |
| 4.0.x | expected to work; the Apps workaround is active ([details](docs/known-issues.md)) |
| ≥ 4.5 | not tested yet; the upstream fix there should make the workaround inactive |

Some problems come from Omarchy itself, not from QuickNum: the empty Apps list on 4.0.x, and a numpad that
types nothing until NumLock is toggled. The [known issues](docs/known-issues.md#overview-omarchy-issues-that-affect-quicknum)
list them with links to the Omarchy issues.

## Installation

```bash
omarchy plugin add https://github.com/W3asd/omarchy-quicknum.git
```

Review the code, then switch from the built-in menu to QuickNum. Only one menu plugin should be active:

```bash
omarchy plugin disable omarchy.menu
omarchy plugin enable quicknum
```

Manual alternative: clone the repository to `~/.config/omarchy/plugins/quicknum`
and run `omarchy-shell shell rescanPlugins`, or run `./bin/install.sh` from the repository.

## Uninstall / back to the built-in menu

```bash
omarchy plugin disable quicknum
omarchy plugin enable omarchy.menu
```

`omarchy plugin remove quicknum` also deletes the files.

## Keys

| Key | Action |
| :--- | :--- |
| `Super + Space` / `Super + Alt + Space` | Open / close the menu |
| `1`–`9`, numpad `1`–`9` | Run row 1–9 (while the search is empty) |
| `A`–`Z`, then also `0`–`9` | Search |
| `Enter` | Run the selected row |
| `Backspace` / `Left` | Up one level (when the search is empty) |
| `Esc` | Clear the search, then close the menu |
| `Up` / `Down` | Move the selection |

## Settings

These properties are at the top of `Menu.qml`:

- `quickNumEnabled` (default `true`): turns number-key selection on or off.
- `quickNumInSearch` (default `false`): with `false`, number keys select rows
  only while the search is empty; once you type a letter, digits go into the
  search. With `true`, number keys always select.
- `quickNumBadgeStyle` (default `"badge"`): `"badge"` or `"minimal"`.

## Repository layout

```
manifest.json          Omarchy plugin manifest (clonedFrom: omarchy.menu)
Menu.qml               Menu, based on Omarchy's built-in menu, plus QuickNum
MenuModel.js           Unchanged copy of Omarchy's menu model (4.0.6)
QuickNumIndicator.qml  Number badges
BarWidget.qml          Optional bar button
bin/install.sh         Local install script
bin/omarchy-quicknum   CLI helper (toggle, summon, close, refresh, ping); not installed to PATH
hypr/quicknum.lua      Example keybindings (template only, does nothing by itself)
tests/validate.sh      Manifest and syntax checks
docs/                  Known issues and development notes
```

## Documentation

- [Known issues](docs/known-issues.md)
- [Development and testing](docs/development.md)
- [Changelog](CHANGELOG.md)
- [Contributing](CONTRIBUTING.md)

## License

[MIT](LICENSE). `Menu.qml` and `MenuModel.js` are derived from
[Omarchy](https://github.com/omacom/omarchy) (MIT, © David Heinemeier Hansson).
