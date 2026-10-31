# Development

## Setup

The installed plugin lives in `~/.config/omarchy/plugins/quicknum/`. During
development, copy changed files there (or run `./bin/install.sh`). Saving a file
in that directory reloads the plugin automatically.

QuickNum and `omarchy.menu` both have kind `menu`. Keep only one of them enabled:

```bash
# test QuickNum
omarchy plugin disable omarchy.menu
omarchy plugin enable quicknum

# back to the built-in menu
omarchy plugin disable quicknum
omarchy plugin enable omarchy.menu
```

`menu` plugins are `keepLoaded`, so a running instance can survive a file
reload. If a change does not show up, restart the shell:

```bash
omarchy restart shell
```

## Tests

```bash
./tests/validate.sh
```

This checks the manifest with `omarchy plugin validate`, required files, JSON
syntax and `MenuModel.js` syntax. It does not load the QML. Always test the
menu itself as well (see the checklist below).

## Inspecting the running menu

`omarchy-shell shell call <plugin-id> <function> '{}'` calls a function on a
loaded plugin and prints its return value. To debug, temporarily add a function
to the **installed** `Menu.qml` (not to the repository), for example:

```qml
function debugApps() {
  var appsRows = 0
  for (var i = 0; i < root.itemOrder.length; i++)
    if (String(root.itemOrder[i]).indexOf("apps.") === 0) appsRows++
  return JSON.stringify({ host: !!root.hostAppLibrary, lib: String(root.appLibrary), loaded: !!root.providersLoaded["apps"], appsRows: appsRows })
}
```

```bash
omarchy restart shell
omarchy-shell shell call quicknum debugApps '{}'
omarchy-shell shell summon quicknum '{"menu":"apps"}'
omarchy-shell shell call quicknum debugApps '{}'
omarchy-shell shell hide quicknum
```

A result of `unknown` means the function does not exist in the loaded instance;
in that case run `omarchy restart shell`. Shell log: `journalctl --user -b | grep omarchy-shell`.

## Manual test checklist

- [ ] `Super + Alt + Space` opens the menu; badges 1–9 are right-aligned
- [ ] Number keys and numpad keys 1–9 run the matching row (empty search)
- [ ] After typing a letter, number-row and numpad digits are added to the search
- [ ] Numpad still selects after hovering another window with the mouse (NumLock desync)
- [ ] **Apps** lists the installed applications, with icons
- [ ] Searching from the root menu finds applications
- [ ] Launching an app from the menu works
- [ ] `Esc` clears the search, then closes the menu

## Syncing with Omarchy

`Menu.qml` and `MenuModel.js` are copies of the built-in menu. After an Omarchy
update, compare them:

```bash
diff /usr/share/omarchy/shell/plugins/menu/MenuModel.js MenuModel.js
diff /usr/share/omarchy/shell/plugins/menu/Menu.qml Menu.qml
```

Expected differences in `Menu.qml` (as of Omarchy 4.0.6):

- QuickNum properties, `getQuickNumIndex()`, the number-key branch in
  `Keys.onPressed` and the `QuickNumIndicator` in the row delegate
- card width `320` instead of `300`, and the chevron row layout next to the badge
- the AppLibrary fallback (comment `Workaround`, see [known-issues.md](known-issues.md))

Any other difference comes from an Omarchy change that QuickNum has not picked up yet.
