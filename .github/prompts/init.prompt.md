---
description: "Orchestrate project creation, build setup, CI generation, and final validation in a safe, idempotent sequence."
agent: build-engineer
---

# Purpose

This is the main orchestrator command. It runs the repository setup, project scaffold, build/test configuration, workflow generation, and final validation steps in a strict sequence while preserving user work and avoiding destructive actions.

## Preconditions

- The current folder is a Git repository.
- The current branch is not develop, master, or main.
- If the branch is one of these protected branches, stop immediately and tell the user to run `git switch -c feature/<name>` first.
- The agent files already exist under .github.

## Actions

Run the following commands in this exact order and verify each step before continuing:

1. [git-init](./git-init.prompt.md)
2. [create-project](./create-project.prompt.md)
3. [create-build](./create-build.prompt.md)
4. [create-actions](./create-actions.prompt.md)
5. [check](./check.prompt.md)

Pass the project values from step 2 to the later steps:

- language: "python"
- package name: "hello"

After each step, check whether its expected files exist. If they do not exist, stop immediately and report the failure.

## Expected files

- .gitignore
- src/hello/__init__.py
- src/hello/main.py
- README.md
- tests/test_basic.py
- pytest.ini
- requirements.txt
- ci.sh
- ci.bat
- .github/workflows/ci.yml
- verification results from the check step

## Verification

- Each step completes in order without overwriting existing user content.
- Each step's expected files exist before the process continues.
- The final check command must print `RESULT: PASS` before the orchestrator reports success.
- Re-running the command must create only missing files and skip existing files.

## Error handling

- Stop at the first failed step.
- Report the step name, the failing command or file, and the reason.
- Do not run any remaining steps after the failure.
- Never claim success unless the final check output is `RESULT: PASS`.
- The command must not commit, push, create branches, or change Git settings.
- It must not delete files or overwrite user changes silently.

## Error message

If a step fails: `FAILED STEP: <step name> - <failing command or file> - <reason>`

## Final report

Provide a table with the following columns:

- Step
- Status (`created`, `skipped (already exists)`, or `failed`)
- Created files

Then print the final check result from the check step.
