---
description: "Validate the generated project, workflow, and repository hygiene without creating or editing source files."
agent: build-engineer
---

# Purpose

Run a read-only validation of the repository and generated project. This command verifies that the agent, skills, prompts, project files, build scripts, workflow file, and Git hygiene all match the required architecture without changing tracked source files.

## Preconditions

- The repository must exist.
- The project may already contain generated files.
- The command is read-only for project source files.
- It may create or refresh only the Git-ignored runtime folders and caches required by the build/test flow: .venv/, build/, dist/, and Python cache folders.
- It must not edit or delete tracked source files.

## Actions

Run all checks below in order, record PASS or FAIL for each item, and do not stop at the first failure. Then summarize the results.

1. Record `git status --short` before starting.
2. Agent manifest check:
   - .github/agents/build-engineer.agent.md exists.
   - It contains YAML frontmatter.
   - It includes the sections: Role, Scope of responsibility, Forbidden actions, Completion criteria.
3. Skills check:
   - .github/skills/project-scaffold/SKILL.md exists and has frontmatter with name and description.
   - .github/skills/build-and-test/SKILL.md exists and has frontmatter with name and description.
   - .github/skills/github-actions/SKILL.md exists and has frontmatter with name and description.
   - Each skill includes sections: Purpose, Inputs, Outputs, Verification, and a failure scenario.
4. Commands check:
   - The six prompt files exist:
     - .github/prompts/git-init.prompt.md
     - .github/prompts/create-project.prompt.md
     - .github/prompts/create-build.prompt.md
     - .github/prompts/create-actions.prompt.md
     - .github/prompts/check.prompt.md
     - .github/prompts/init.prompt.md
   - Each has a description field and an Error message section.
   - init.prompt.md references git-init, create-project, create-build, create-actions, check in this order.
5. Project files check:
   - src/hello/__init__.py exists
   - src/hello/main.py exists
   - tests/test_basic.py exists
   - pytest.ini exists
   - requirements.txt exists
   - ci.sh exists
   - ci.bat exists
   - .github/workflows/ci.yml exists
   - README.md exists
   - docs/architecture.md exists
   - docs/usage.md exists
6. Configuration check:
   - .gitignore contains the required entries.
   - ci.sh uses LF line endings.
   - ci.bat uses CRLF line endings.
7. Build and tests check:
   - On Windows, run `ci.bat`.
   - On other systems, run `bash ci.sh`.
   - pytest must pass including test_basic_addition.
   - dist/hello must exist on Unix-like systems and print `Hello, World!`.
   - dist/hello.exe must exist on Windows and print `Hello, World!`.
8. Workflow check:
   - Parse .github/workflows/ci.yml as YAML using Python from .venv and PyYAML.
   - The matrix contains ubuntu-latest, windows-latest, and macos-latest.
   - Triggers include push and pull_request for develop and master.
   - Workflow steps only call `ci.bat` or `ci.sh`.
9. Git hygiene check:
   - `git ls-files` must not list anything under .venv/, build/, dist/, __pycache__/, or .pytest_cache/.
   - Tracked files must not contain secret patterns such as `ghp_`, `github_pat_`, `AKIA`, or `BEGIN PRIVATE KEY`.
   - Exclude .github/prompts/check.prompt.md itself from the secret scan.
10. Record `git status --short` again at the end.
11. Compare the end-of-run status with the initial status.
12. Summarize all checks in a table.
13. Finish with a final result line:
   - `RESULT: PASS` only if all checks passed.
   - Otherwise `RESULT: FAIL` followed by the failed items.

## Expected files

- .github/agents/build-engineer.agent.md
- .github/skills/project-scaffold/SKILL.md
- .github/skills/build-and-test/SKILL.md
- .github/skills/github-actions/SKILL.md
- .github/prompts/git-init.prompt.md
- .github/prompts/create-project.prompt.md
- .github/prompts/create-build.prompt.md
- .github/prompts/create-actions.prompt.md
- .github/prompts/check.prompt.md
- .github/prompts/init.prompt.md
- src/hello/__init__.py
- src/hello/main.py
- tests/test_basic.py
- pytest.ini
- requirements.txt
- ci.sh
- ci.bat
- .github/workflows/ci.yml
- README.md
- docs/architecture.md
- docs/usage.md

## Verification

- The repository is read-only for project source files.
- The runtime directories .venv/, build/, dist/, and caches may be created as part of validation.
- All checks are recorded with PASS or FAIL.
- The final `git status --short` output matches the initial status.
- Final result is `RESULT: PASS` only if every check passed. Otherwise it is `RESULT: FAIL` with the failed items listed.

## Error message

If any check fails: `FAILED CHECK: <check name> - <reason>`
