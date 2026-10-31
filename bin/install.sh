#!/bin/bash
# Installs QuickNum from this checkout into the Omarchy plugin directory.
# For an install made with `omarchy plugin add`, use `omarchy plugin update` instead.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PLUGIN_ID="$(jq -r '.id' "$SCRIPT_DIR/manifest.json")"
TARGET_DIR="$HOME/.config/omarchy/plugins/$PLUGIN_ID"

echo "=== Installing Omarchy QuickNum ($PLUGIN_ID) ==="

# 1. Refuse to overwrite a git checkout managed by `omarchy plugin add`
if [[ -d $TARGET_DIR/.git && $TARGET_DIR != "$SCRIPT_DIR" ]]; then
  echo "error: $TARGET_DIR is a git checkout (installed with 'omarchy plugin add')." >&2
  echo "       Update it with: omarchy plugin update $PLUGIN_ID" >&2
  exit 1
fi

# 2. Validate plugin manifest
echo "Validating plugin manifest..."
omarchy plugin validate "$SCRIPT_DIR"

# 3. Copy files into the plugins directory
if [[ $TARGET_DIR != "$SCRIPT_DIR" ]]; then
  mkdir -p "$TARGET_DIR"
  for file in manifest.json Menu.qml MenuModel.js QuickNumIndicator.qml BarWidget.qml LICENSE; do
    cp -a "$SCRIPT_DIR/$file" "$TARGET_DIR/"
  done
  echo "Installed files to $TARGET_DIR"
fi

# 4. Rescan and enable; errors are reported, not hidden. The rescan runs
#    asynchronously in the shell, so wait until the plugin is listed.
omarchy-shell shell rescanPlugins >/dev/null
for _ in {1..20}; do
  omarchy plugin list | grep -qE "^${PLUGIN_ID//./\\.} " && break
  sleep 0.25
done
omarchy plugin enable "$PLUGIN_ID"

if omarchy plugin list | grep -qE '^omarchy\.menu +enabled'; then
  echo "note: the built-in omarchy.menu is still enabled. Only one menu plugin should be active:"
  echo "      omarchy plugin disable omarchy.menu"
fi

echo "=== Done. Open the menu with Super + Alt + Space. ==="
