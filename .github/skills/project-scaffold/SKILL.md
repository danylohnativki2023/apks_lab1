---
name: project-scaffold
description: "Use when creating a minimal cross-platform Python Hello World project skeleton."
---

# Purpose

Create the minimal project skeleton for a cross-platform Python Hello World application. This skill establishes the package layout, a simple entry point, basic repository hygiene, and the required project documentation without overwriting existing user work.

## When to use

Use this skill when starting a new Python project that must include:

- a package under src/
- a simple Hello World entry point
- a minimal pytest-ready layout
- repository ignore rules
- a README with required sections
- safe, idempotent project creation

## Inputs

- language: default "python"
- project package name: default "hello"

The skill should preserve these values consistently across file creation and validation.

## Steps

### 1. Create src/hello/__init__.py

Create this file with empty content if it does not already exist.

```python
```

### 2. Create src/hello/main.py

Create the file with this exact content if it does not exist:

```python
"""Hello World entry point."""


def add(a: int, b: int) -> int:
    return a + b


def main() -> None:
    print("Hello, World!")


if __name__ == "__main__":
    main()
```

Do not use relative imports. This keeps the file portable and compatible with PyInstaller packaging.

### 3. Ensure .gitignore exists

Ensure a repository-level .gitignore exists. If it already exists, append only the missing entries below instead of overwriting it:

```text
.venv/
__pycache__/
.pytest_cache/
build/
dist/
*.spec
```

Do not remove or rewrite existing entries that the user has already added.

### 4. Ensure README.md contains required sections

Ensure README.md includes sections for:

- running the agent
- building and running the project
- project structure

If README.md already exists, append missing sections or add placeholders without removing existing text.

## Idempotency

- Create a file only if it is missing.
- If the file exists, compare it with the expected content and update minimally.
- Never duplicate content.
- Never overwrite user-authored text silently.
- Preserve existing project structure and custom entries.

## Outputs

List of files created or updated:

- src/hello/__init__.py
- src/hello/main.py
- .gitignore
- README.md

## Verification

The skill is considered successful when:

- src/hello/main.py exists
- src/hello/main.py defines add and main
- running `python src/hello/main.py` prints `Hello, World!`

## Example input

```text
language = "python"
project package name = "hello"
```

Expected result:

- src/hello/__init__.py exists and is empty
- src/hello/main.py contains the add and main functions with the required content
- .gitignore includes the required ignores without rewriting user entries
- README.md contains the required sections
- `python src/hello/main.py` prints Hello, World!

## Typical failure scenario and handling

### Failure: Python not found in PATH

If `python` is not available, stop immediately and report the exact failing command. Suggest installing Python 3.12 before continuing.

### Failure: existing main.py has different content

If src/hello/main.py already exists with different content, do not overwrite it. Report the difference and explain that the file was left intact to avoid deleting user work.
