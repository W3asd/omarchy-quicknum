# Known issues

## Empty "Apps" submenu on Omarchy 4.0.x (worked around)

**Status:** worked around in QuickNum (see [CHANGELOG](../CHANGELOG.md), Unreleased).
Fixed upstream in Omarchy v4.5.0-rc1, according to the Omarchy project's bot
account. A maintainer has not confirmed this yet.

### Symptom

With QuickNum enabled, `Super + Alt + Space` → **Apps** shows an empty list,
and application search finds nothing. The built-in `omarchy.menu` lists the
apps normally.

### Cause (Omarchy bug, not intended behavior)

The Omarchy shell README promises that third-party plugins with kind `menu`
"receive an application-library facade". On Omarchy 4.0.x the shell decides
this with:

```js
// /usr/share/omarchy/shell/shell.qml
function manifestHasKind(manifest, kind) {
  return !!manifest && Array.isArray(manifest.kinds) && manifest.kinds.indexOf(kind) !== -1
}
```

The menu loader passes the manifest through a QML `Instantiator` model first.
There `kinds` becomes a QML list object instead of a JavaScript array, so
`Array.isArray()` returns `false`. The plugin then gets `shell.appLibrary === null`.
First-party plugins are not affected because they receive the real shell object.

### Measured (Omarchy 4.0.6-1, 2026-10-31)

| | `shell` | `shell.appLibrary` | App rows |
|---|---|---|---|
| QuickNum 1.0.0 | present | `null` | 0 |
| QuickNum with workaround | present | `null` (host), fallback loaded | 55 |

See [development.md](development.md#inspecting-the-running-menu) for how to measure this.

### Workaround in QuickNum

`Menu.qml` loads Omarchy's own `shell/services/AppLibrary.qml` through a
`Loader`, but only while the host provides no `appLibrary`. As soon as the
host passes one (Omarchy ≥ 4.5), the host's facade takes over and the fallback
unloads. If a future Omarchy removes or changes `AppLibrary.qml`, the Loader
stays empty and the menu works without apps instead of failing.

Known limitation: the fallback runs a second copy of the app library, so the
desktop entries and the icon index are read twice. In practice this cost is negligible.

**Remove the workaround** once the minimum supported Omarchy version contains
upstream PR #13439.

### Upstream references

- [omacom/omarchy#15617](https://github.com/omacom/omarchy/issues/15617): root cause; closed as duplicate of #10661
- [omacom/omarchy#10908](https://github.com/omacom/omarchy/issues/10908), [#12061](https://github.com/omacom/omarchy/issues/12061), [#12944](https://github.com/omacom/omarchy/issues/12944): same symptom
- [omacom/omarchy#13439](https://github.com/omacom/omarchy/pull/13439): upstream fix
- [omacom/omarchy#13064](https://github.com/omacom/omarchy/pull/13064): open PR that re-delivers APIs after a revoke
- [DanielLemky/omalaunch#75](https://github.com/DanielLemky/omalaunch/issues/75): the same problem in another menu plugin, solved with a fallback

## Digits could not be typed into the search (fixed)

In 1.0.0 the keys `1`–`9` always selected a row, even while you typed a
search, so searching for "7zip" or "Steam 2" was not possible. Numpad digits
were never typed at all: the menu only accepts typed text without modifiers,
and numpad keys carry Qt's `KeypadModifier`. The built-in Omarchy menu has the
same bug ([omacom/omarchy#14956](https://github.com/omacom/omarchy/issues/14956)).

Since the Unreleased version, `quickNumInSearch` defaults to `false`: as soon
as a search contains text, every digit (number row and numpad) is typed into it.
A search still cannot *start* with a digit, because on an empty search
`1`–`9` select a row.

## Numpad types nothing until NumLock is toggled (Omarchy/Qt, not fixable here)

**Symptom:** NumLock is on (LED lit, `hyprctl devices` shows `numLock: true`),
but numpad keys select nothing and type nothing in the menu. After you press
NumLock off and on again, the numpad works.

**Cause:** Qt does not read the system NumLock state at startup
([QTBUG-32687](https://bugreports.qt.io/browse/QTBUG-32687)). It delivers the
NumLock-off keys (`End`, `Down`, …) without text. This affects every text field
of `omarchy-shell` (menu, lock screen, polkit dialog), not only QuickNum. A
plugin cannot fix this.

**Workaround:** press NumLock twice after login, or after the shell restarts.

**Upstream:** [omacom/omarchy#8552](https://github.com/omacom/omarchy/issues/8552)
(still reproducible on 4.5.0-rc2 according to a comment),
[#8176](https://github.com/omacom/omarchy/issues/8176),
[#16298](https://github.com/omacom/omarchy/issues/16298),
[#12438](https://github.com/omacom/omarchy/issues/12438) (after suspend/resume).

## Numpad acts as if NumLock were off after hovering a window (under investigation)

**Symptom (reported 2026-10-31, Omarchy 4.0.6):** while the menu is open, moving
the mouse over another window, for example a terminal, makes the numpad behave as if
NumLock were off. The number row keeps working.

**What is known:** QuickNum does not change how the menu takes the keyboard
(`WlrKeyboardFocus.Exclusive`, as in the built-in menu). The symptom matches
the NumLock desync between the compositor and Qt described in
[omacom/omarchy#8176](https://github.com/omacom/omarchy/issues/8176) and
[#15686](https://github.com/omacom/omarchy/issues/15686). No upstream issue
reports exactly this hover trigger yet. A comparison with the built-in menu is
limited, because the built-in menu ignores numpad digits anyway (#14956).

**Planned:** map the NumLock-off keypad keys (`End`, `Down`, `PageDown`, …) back to
digits inside the menu, so numpad selection works regardless of the NumLock state.

## Overview: Omarchy issues that affect QuickNum

| Problem | Upstream | Status upstream (per issue thread) | In QuickNum |
|---|---|---|---|
| Third-party menus get `appLibrary: null`, Apps list empty | [#15617](https://github.com/omacom/omarchy/issues/15617) → #10661, fix [#13439](https://github.com/omacom/omarchy/pull/13439) | fixed for v4.5.0-rc1 | worked around (AppLibrary fallback) |
| Numpad digits are dropped by the menu's modifier check | [#14956](https://github.com/omacom/omarchy/issues/14956) | fixed for v4.5.0-rc1 (#15508) | fixed in `Menu.qml` |
| Qt ignores NumLock at startup | [#8552](https://github.com/omacom/omarchy/issues/8552), [#8176](https://github.com/omacom/omarchy/issues/8176) | open | not fixable; toggle NumLock |
| NumLock state lost after hovering another window | none found yet; related #8176, #15686 | — | under investigation |

The upstream status comes from replies in the Omarchy issue threads, mostly
from the `omarchybot` account. It was not verified by running Omarchy 4.5.
Checked on 2026-10-31.

## Menu code is a copy of Omarchy's menu (by design, with a cost)

QuickNum ships a modified copy of the built-in `Menu.qml` and an unchanged
copy of `MenuModel.js` (from Omarchy 4.0.6). Fixes Omarchy makes to its own
menu do not reach QuickNum automatically. Compare the copy after Omarchy
updates; [development.md](development.md#syncing-with-omarchy) describes how.
