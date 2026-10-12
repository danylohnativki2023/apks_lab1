---
description: "Check repository status and ensure the project ignores local Python and build artifacts without deleting user entries."
agent: build-engineer
---

# Purpose

Verify that the current folder is already a Git repository, ensure the Python project ignores the required local artifacts, and report the current Git status in a safe, idempotent way.

## Preconditions

- The current folder must already be a Git repository.
- If it is not a Git repository, stop immediately and report the issue.
- Do not run `git init` automatically.

## Actions

1. Check whether the current directory is a Git repository.
2. If it is not a Git repository, stop and report: "This folder is not a Git repository. Please initialize Git manually before running git-init."
3. If .gitignore does not exist, create it.
4. If .gitignore exists, append only the missing entries below without removing existing entries:
   - .venv/
   - __pycache__/
   - .pytest_cache/
   - build/
   - dist/
   - *.spec
   - .env
   - *.log
5. Show `git status --short`.
6. Show the current branch name.

## Expected files

- .gitignore

## Verification

- The folder is confirmed to be a Git repository.
- .gitignore exists after the step.
- Missing ignore entries are present without deleting any user entries.
- `git status --short` runs successfully.
- The current branch is displayed.

## Error message

If the folder is not a Git repository: "This folder is not a Git repository. Please initialize Git manually before running git-init."
