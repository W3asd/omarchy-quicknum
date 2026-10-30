#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TARGET_DIR="$HOME/.config/omarchy/plugins/quicknum"

echo "=== Installing Omarchy QuickNum ==="

# 1. Validate plugin manifest
echo "Validating plugin manifest..."
omarchy plugin validate "$SCRIPT_DIR"

# 2. Copy or link files into plugins directory
mkdir -p "$TARGET_DIR"
cp -a "$SCRIPT_DIR/manifest.json" "$TARGET_DIR/"
cp -a "$SCRIPT_DIR/Menu.qml" "$TARGET_DIR/"
cp -a "$SCRIPT_DIR/MenuModel.js" "$TARGET_DIR/"
cp -a "$SCRIPT_DIR/QuickNumIndicator.qml" "$TARGET_DIR/"
cp -a "$SCRIPT_DIR/BarWidget.qml" "$TARGET_DIR/"

echo "Installed files to $TARGET_DIR"

# 3. Rescan plugins in omarchy-shell if shell is running
if command -v omarchy-shell >/dev/null 2>&1; then
  echo "Rescanning Omarchy plugins..."
  omarchy-shell shell rescanPlugins >/dev/null 2>&1 || true
  omarchy plugin enable quicknum >/dev/null 2>&1 || true
  echo "QuickNum successfully enabled in omarchy-shell!"
fi

echo "=== Done! Press Super + Space to summon QuickNum. ==="

