---
description: "Create the GitHub Actions CI workflow for Linux, Windows, and macOS."
agent: build-engineer
---

# Purpose

Apply the github-actions skill to generate the CI workflow for the Python Hello World project and keep the workflow limited to calling the repository scripts.

## Preconditions

- ci.sh exists.
- ci.bat exists.
- If either file is missing, stop and tell the user to run create-build first.

## Actions

1. Apply the skill: [.github/skills/github-actions/SKILL.md](../../.github/skills/github-actions/SKILL.md)
2. Create .github/workflows/ci.yml if it does not exist.
3. If it exists, update it minimally without duplicating jobs or steps.
4. Keep the workflow limited to calling ci.sh and ci.bat.
5. Do not add secrets, tokens, or custom build logic.

## Expected files

- .github/workflows/ci.yml

## Verification

- The YAML file parses successfully.
- The matrix includes ubuntu-latest, windows-latest, and macos-latest.
- The workflow triggers on push and pull_request for develop and master.
- The workflow only calls ci.sh or ci.bat.
- No secrets or tokens appear in the workflow.

## Error message

If ci.sh or ci.bat is missing: "The build scripts are missing. Please run create-build first before creating the GitHub Actions workflow."
