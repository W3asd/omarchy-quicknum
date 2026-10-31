# Known issues

## Empty "Apps" submenu on Omarchy 4.0.x (worked around)

**Status:** worked around in QuickNum 1.1.0 (see [CHANGELOG](../CHANGELOG.md)).
Fixed upstream in Omarchy v4.5.0-rc1, according to the Omarchy project's bot
account. A maintainer has not confirmed this yet.

### Symptom

With QuickNum enabled, the **Apps** list (`Super + Space` → Apps, or `Super + Alt + Space`) is empty,
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

Since 1.1.0, `quickNumInSearch` defaults to `false`: as soon
as a search contains text, every digit (number row and numpad) is typed into it.
A search still cannot *start* with a digit, because on an empty search
`1`–`9` select a row.

## Numpad types nothing until NumLock is toggled (Omarchy/Qt)

**Symptom:** NumLock is on (LED lit, `hyprctl devices` shows `numLock: true`),
but in `omarchy-shell` surfaces (menu, lock screen, polkit dialog) the numpad
types nothing. After you press NumLock off and on again, it works.

**Cause:** Qt's NumLock state is out of sync with the compositor, so Qt delivers
the NumLock-off keys (`End`, `Down`, …) without text. The issue was first
attributed to Qt not reading NumLock at startup
([QTBUG-32687](https://bugreports.qt.io/browse/QTBUG-32687)). Later comments
point to keymaps being re-sent without a following NumLock state (see the next
section).

**In QuickNum:** since 1.2.0 the menu reads these keys as digits, so this does
not affect QuickNum. The lock screen and the polkit dialog are Omarchy code;
QuickNum cannot change them. There, press NumLock twice.

**Upstream:** [omacom/omarchy#8552](https://github.com/omacom/omarchy/issues/8552)
(still reproducible on 4.5.0-rc2 according to a comment),
[#8176](https://github.com/omacom/omarchy/issues/8176),
[#16298](https://github.com/omacom/omarchy/issues/16298),
[#12438](https://github.com/omacom/omarchy/issues/12438) (after suspend/resume).

## Numpad acts as if NumLock were off after hovering a window (worked around)

**Symptom (reported 2026-10-31, Omarchy 4.0.6):** while the menu is open, moving
the mouse over another window, for example a terminal, makes the numpad behave as if
NumLock were off. The number row keeps working. The lock screen shows the same
effect after the screen locks.

**Cause (per the analysis in [omacom/omarchy#8552](https://github.com/omacom/omarchy/issues/8552)):**
Hyprland sends a window a new keymap whenever input switches between two
keyboards with different keymaps, for example the physical keyboard and the
fcitx5 virtual keyboard. Qt then rebuilds its keyboard state, but no NumLock
state follows, so Qt treats NumLock as off until NumLock is pressed. Omarchy's
default `kb_options = "compose:caps,shift:both_capslock_cancel"` is what makes the
two keymaps differ. QuickNum does not change how the menu takes the keyboard
(`WlrKeyboardFocus.Exclusive`, as in the built-in menu).

**Workaround in QuickNum 1.2.0:** inside the menu, numpad keys that arrive
as navigation keys with Qt's `KeypadModifier` (`End`, `Down`, `PageDown`, `Left`,
`Clear`, `Right`, `Home`, `Up`, `PageUp`, `Insert`) count as the digit printed
on them. They select a row or type into the search like any other digit.
Omarchy uses the same approach in its open PRs for the lock screen (#12667)
and the polkit dialog (#10530).

**Trade-off:** with NumLock *really* off, the numpad can no longer navigate the
menu; the regular arrow keys and `PageUp`/`PageDown` still do. Set
`quickNumKeypadAlwaysDigits: false` in `Menu.qml` to turn the workaround off.
The numpad decimal key (`Delete` when NumLock is off) is not mapped.

**System-side fix (not applied by QuickNum):** removing `shift:both_capslock_cancel`
from `kb_options` in `~/.config/hypr/input.lua` makes the keymaps identical.
Users report that this helps, but not always when several keyboards use different layouts.

## Dialog results were visible in process arguments (fixed in 3.0.1)

**Problem:** when a command used the menu as an input or select dialog,
`finishRequest()` saved the result with
`bash -c "printf '%s\n' '<value>' > <file>"`. The typed value was therefore part
of the process arguments, readable by other local accounts in `/proc/<pid>/cmdline`,
even though the result file itself is private. Shell quoting prevented injection,
not disclosure.

**Fix in QuickNum 3.0.1:** the value goes over stdin (`IFS= read -r`); only the
file paths are process arguments. Reported in the marketplace review of the
submission ([omacom/omarchy-plugin-marketplace#13493](https://github.com/omacom/omarchy-plugin-marketplace/issues/13493)).

**Upstream:** Omarchy's built-in menu has the same code. Open pull request
[omacom/omarchy#15774](https://github.com/omacom/omarchy/pull/15774) fixes it
there by writing the result from inside the shell with `FileView`. Not merged as
of 2026-10-31.

## Overview: Omarchy issues that affect QuickNum

| Problem | Upstream | Status upstream (per issue thread) | In QuickNum |
|---|---|---|---|
| Third-party menus get `appLibrary: null`, Apps list empty | [#15617](https://github.com/omacom/omarchy/issues/15617) → #10661, fix [#13439](https://github.com/omacom/omarchy/pull/13439) | fixed for v4.5.0-rc1 | worked around (AppLibrary fallback) |
| Numpad digits are dropped by the menu's modifier check | [#14956](https://github.com/omacom/omarchy/issues/14956) | fixed for v4.5.0-rc1 (#15508) | fixed in `Menu.qml` |
| Qt's NumLock state out of sync (startup, suspend) | [#8552](https://github.com/omacom/omarchy/issues/8552), [#8176](https://github.com/omacom/omarchy/issues/8176), [#12438](https://github.com/omacom/omarchy/issues/12438) | open | worked around in the menu (1.2.0); lock screen: press NumLock twice |
| Dialog result in process arguments | PR [#15774](https://github.com/omacom/omarchy/pull/15774) | open (PR) | fixed in 3.0.1 |
| NumLock state lost when the keymap is re-sent (hover, lock screen) | [#8552](https://github.com/omacom/omarchy/issues/8552) (analysis in comments), lock screen PR #12667, polkit PR #10530 | open | worked around in the menu |

The upstream status comes from replies in the Omarchy issue threads, mostly
from the `omarchybot` account. It was not verified by running Omarchy 4.5.
Checked on 2026-10-31.

## Menu code is a copy of Omarchy's menu (by design, with a cost)

QuickNum ships a modified copy of the built-in `Menu.qml` and an unchanged
copy of `MenuModel.js` (from Omarchy 4.0.6). Fixes Omarchy makes to its own
menu do not reach QuickNum automatically. Compare the copy after Omarchy
updates; [development.md](development.md#syncing-with-omarchy) describes how.
