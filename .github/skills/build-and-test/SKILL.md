---
name: build-and-test
description: "Use when creating test configuration, dependency lists, and cross-platform build scripts for the Python Hello World project."
---

# Purpose

Configure the Python Hello World project for testing and packaging. This skill creates the pytest setup, dependency list, and cross-platform build scripts needed to run tests and build a distributable binary with PyInstaller.

## When to use

Use this skill after the project skeleton exists and src/hello/main.py is present.

## Inputs

- package name: default "hello"
- Python version: 3.12

The generated files should align with this package name and Python runtime target.

## Steps

### 1. Create tests/test_basic.py

Create the file with this exact content:

```python
from hello.main import add


def test_basic_addition():
    assert add(2, 3) == 5
```

### 2. Create pytest.ini

Create the file with this exact content:

```ini
[pytest]
pythonpath = src
testpaths = tests
```

### 3. Create requirements.txt

Create the file with this exact content:

```text
pytest>=8,<9
pyinstaller>=6
pyyaml>=6
```

### 4. Create ci.sh

Create the file with this exact content:

```bash
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
```

This script must use LF line endings, print a clear message for each step, and must not delete any files.

### 5. Create ci.bat

Create the file with this exact content:

```bat
@echo off
setlocal

set "SCRIPT_DIR=%~dp0"
cd /d "%SCRIPT_DIR%"

echo [1/6] Ensuring virtual environment exists...
if not exist .venv (
    python -m venv .venv
    if errorlevel 1 exit /b 1
)

echo [2/6] Activating virtual environment...
call .venv\Scripts\activate.bat
if errorlevel 1 exit /b 1

echo [3/6] Installing dependencies...
pip install -r requirements.txt
if errorlevel 1 exit /b 1

echo [4/6] Running pytest...
pytest
if errorlevel 1 exit /b 1

echo [5/6] Building application with PyInstaller...
pyinstaller --onefile --name hello --distpath dist --workpath build --specpath build src\hello\main.py
if errorlevel 1 exit /b 1

echo [6/6] Running built application...
set "OUTPUT="
if not exist dist\hello.exe (
    echo Error: dist\hello.exe was not created.
    exit /b 1
)
for /f "delims=" %%i in ('dist\hello.exe') do set "OUTPUT=%%i"
if not "%OUTPUT%"=="Hello, World!" (
    echo Error: built application output was '%OUTPUT%', expected 'Hello, World!'
    exit /b 1
)

echo Build and test completed successfully.
```

This script must use CRLF line endings, print a clear message for each step, check errorlevel after each step, and exit /b 1 on failure. It must not delete any files.

## Idempotency

- Create files only if they are missing.
- If a file exists, update it minimally instead of rewriting unrelated content.
- Re-running the scripts must work when .venv already exists.
- Do not duplicate dependency declarations or test configuration.

## Outputs

List of files created or updated:

- tests/test_basic.py
- pytest.ini
- requirements.txt
- ci.sh
- ci.bat

PyYAML is included because the check command uses it to validate the workflow YAML.

## Verification

This skill is successful when:

- pytest passes, including test_basic_addition
- dist/hello exists and prints "Hello, World!"
- dist/hello.exe exists and prints "Hello, World!" on Windows
- build/, dist/, and .venv/ are not tracked by Git
- the check command validates the workflow YAML successfully using PyYAML

## Example input

```text
package name = "hello"
Python version = 3.12
```

Expected result:

- pytest configuration is present and valid
- test_basic_addition passes
- requirements include pytest and pyinstaller
- ci.sh and ci.bat run successfully in their respective environments
- the built executable prints Hello, World!

## Typical failure scenarios and handling

### Failure: pytest fails

Stop immediately and show the failing test output. Do not build the project until pytest passes.

### Failure: pyinstaller is missing

Reinstall the project dependencies from requirements.txt and retry the build step.

### Failure: Python not found

Stop immediately and report the exact command that failed. Suggest installing Python 3.12 and ensuring it is available on PATH.
