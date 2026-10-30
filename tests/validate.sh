#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$SCRIPT_DIR"

echo "Running tests for Omarchy QuickNum..."

# Test 1: omarchy plugin validate
echo "1. Checking manifest schema with omarchy plugin validate..."
omarchy plugin validate "$SCRIPT_DIR"
echo "   -> PASS: Manifest conforms to Omarchy plugin schema."

# Test 2: Check required files
echo "2. Checking required plugin files..."
for file in manifest.json Menu.qml MenuModel.js QuickNumIndicator.qml BarWidget.qml; do
  if [[ ! -f "$file" ]]; then
    echo "   -> FAIL: Missing required file $file"
    exit 1
  fi
done
echo "   -> PASS: All core QML, JS and manifest files present."

# Test 3: Validate JSON syntax
echo "3. Validating manifest.json syntax..."
jq empty manifest.json
echo "   -> PASS: Valid JSON."

# Test 4: Validate JavaScript syntax if node is available
if command -v node >/dev/null 2>&1; then
  echo "4. Checking JavaScript syntax of MenuModel.js..."
  node --check MenuModel.js
  echo "   -> PASS: MenuModel.js syntax valid."
fi

echo "All tests passed successfully!"
