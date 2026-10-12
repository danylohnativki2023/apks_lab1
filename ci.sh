#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "[1/6] Ensuring virtual environment exists..."
if [ ! -d .venv ]; then
  python3 -m venv .venv
fi

echo "[2/6] Activating virtual environment..."
# shellcheck disable=SC1091
source .venv/bin/activate

echo "[3/6] Installing dependencies..."
pip install -r requirements.txt

echo "[4/6] Running pytest..."
pytest

echo "[5/6] Building application with PyInstaller..."
pyinstaller --onefile --name hello --distpath dist --workpath build --specpath build src/hello/main.py

echo "[6/6] Running built application..."
OUTPUT="$(./dist/hello)"
if [ "$OUTPUT" != "Hello, World!" ]; then
  echo "Error: built application output was '$OUTPUT', expected 'Hello, World!'"
  exit 1
fi

echo "Build and test completed successfully."
