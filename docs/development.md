# Development

## Setup

The installed plugin lives in `~/.config/omarchy/plugins/io.github.w3asd.quicknum/`. An
install made with `omarchy plugin add` is a git clone, so you can work directly
in it. Alternatively remove that install (`omarchy plugin remove io.github.w3asd.quicknum`)
and run `./bin/install.sh` from your own clone after each change; the script
refuses to overwrite a git clone. Saving a file in the plugin directory reloads
the plugin automatically.

QuickNum and `omarchy.menu` both have kind `menu`. Because QuickNum declares
`clonedFrom: "omarchy.menu"`, enabling it switches `omarchy.menu` off and
disabling it switches `omarchy.menu` back on (verified on Omarchy 4.0.6):

```bash
# test QuickNum
omarchy plugin enable io.github.w3asd.quicknum

# back to the built-in menu
omarchy plugin disable io.github.w3asd.quicknum
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
omarchy-shell shell call io.github.w3asd.quicknum debugApps '{}'
omarchy-shell shell summon io.github.w3asd.quicknum '{"menu":"apps"}'
omarchy-shell shell call io.github.w3asd.quicknum debugApps '{}'
omarchy-shell shell hide io.github.w3asd.quicknum
```

A result of `unknown` means the function does not exist in the loaded instance;
in that case run `omarchy restart shell`. Shell log: `journalctl --user -b | grep omarchy-shell`.

## Manual test checklist

After testing on a new Omarchy version, update the "tested" version in the
first README badge (both READMEs) and in the compatibility table.

- [ ] `Super + Space` opens the menu; badges 1–9 are right-aligned
- [ ] `Super + Alt + Space` opens the Apps list directly
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

- QuickNum properties, `getQuickNumIndex()`, `keypadDigitText()`, `tryQuickNum()`,
  the numpad branch at the top of `Keys.onPressed`, the number-key branch at its end,
  and the `QuickNumIndicator` in the row delegate
- the text branch of `Keys.onPressed` ignores `Qt.KeypadModifier` (omacom/omarchy#14956)
- card width `320` instead of `300`, and the chevron row layout next to the badge
- the AppLibrary fallback (comment `Workaround`, see [known-issues.md](known-issues.md))

Any other difference comes from an Omarchy change that QuickNum has not picked up yet.
