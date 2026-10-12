---
description: "Create the minimal cross-platform Python Hello World project skeleton and verify it runs."
agent: build-engineer
---

# Purpose

Create the minimal Python Hello World project skeleton using the project-scaffold skill and verify that the generated application runs.

## Preconditions

- Python 3.12 is available on PATH.
- Run `python --version` before creating files.
- If Python 3.12 is not available, stop and report the issue.

## Actions

1. Apply the skill: [.github/skills/project-scaffold/SKILL.md](../../.github/skills/project-scaffold/SKILL.md)
2. Use these inputs:
   - language: "python"
   - package name: "hello"
3. Create missing files only.
4. Update existing files minimally and never overwrite user changes silently.
5. Ensure README.md contains sections for:
   - running the agent
   - building and running the project
   - project structure
6. Run `python src/hello/main.py`.

## Expected files

- src/hello/__init__.py
- src/hello/main.py
- README.md

## Verification

- `python src/hello/main.py` runs successfully.
- The output is exactly: `Hello, World!`
- The project structure matches the scaffold requirements.

## Error message

If Python 3.12 is unavailable: "Python 3.12 is required but was not found in PATH. Please install Python 3.12 and try again."
