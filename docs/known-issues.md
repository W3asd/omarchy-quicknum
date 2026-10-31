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

## Digits cannot be typed into the search (open)

With `quickNumInSearch: true` (the default), the keys `1`–`9` always select a
row, even while you type a search. Searching for "7zip" or "Steam 2" is
therefore not possible. Set `quickNumInSearch: false` in `Menu.qml` as a
workaround. The number row then types digits once a search has started, and
the numpad still selects. A search still cannot *start* with a digit.

## Menu code is a copy of Omarchy's menu (by design, with a cost)

QuickNum ships a modified copy of the built-in `Menu.qml` and an unchanged
copy of `MenuModel.js` (from Omarchy 4.0.6). Fixes Omarchy makes to its own
menu do not reach QuickNum automatically. Compare the copy after Omarchy
updates; [development.md](development.md#syncing-with-omarchy) describes how.
