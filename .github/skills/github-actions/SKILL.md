---
name: github-actions
description: "Use when creating the CI workflow for Windows, Linux, and macOS."
---

# Purpose

Create and maintain the GitHub Actions workflow that runs the project validation and build logic for a cross-platform Python Hello World project. This skill keeps the CI definition minimal, portable, and aligned with the repository scripts.

## When to use

Use this skill after the project build scripts already exist and both ci.sh and ci.bat are present.

## Inputs

- Python version: default 3.12
- target branches: develop, master

The workflow should use these values consistently and keep the CI logic separate from the build logic.

## Steps

### 1. Create .github/workflows/ci.yml

Create the workflow with the following exact behavior:

```yaml
name: CI

on:
  push:
    branches:
      - develop
      - master
  pull_request:
    branches:
      - develop
      - master

permissions:
  contents: read

jobs:
  build-and-test:
    runs-on: ${{ matrix.os }}
    strategy:
      fail-fast: false
      matrix:
        os: [ubuntu-latest, windows-latest, macos-latest]

    steps:
      - name: Check out repository
        uses: actions/checkout@v4

      - name: Set up Python
        uses: actions/setup-python@v5
        with:
          python-version: '3.12'

      - name: Run build and tests on Windows
        if: runner.os == 'Windows'
        shell: cmd
        run: ci.bat

      - name: Run build and tests on Linux and macOS
        if: runner.os != 'Windows'
        shell: bash
        run: bash ci.sh

      - name: Upload build output
        if: always()
        uses: actions/upload-artifact@v4
        with:
          name: dist-${{ runner.os }}
          path: dist/
          if-no-files-found: error
```

The workflow must contain no build logic and no secrets. All project build and test logic lives only in ci.sh and ci.bat.

## Idempotency

- Create the workflow only if it is missing.
- If it already exists, update it minimally instead of rewriting unrelated content.
- Never duplicate jobs, steps, or triggers.
- Preserve other repository configuration unless it is required for CI.

## Outputs

- .github/workflows/ci.yml

## Verification

This skill is successful when:

- the YAML parses successfully
- the matrix includes ubuntu-latest, windows-latest, and macos-latest
- push and pull_request triggers include develop and master
- the workflow only calls ci.sh or ci.bat
- no secrets or tokens are present in the workflow

## Example input

```text
Python version = 3.12
target branches = [develop, master]
```

Expected result:

- a valid CI workflow is created in .github/workflows/ci.yml
- Linux, Windows, and macOS jobs execute the correct script
- the repository remains free of secrets and embedded tokens
- no custom build logic is duplicated in the workflow file

## Typical failure scenarios and handling

### Failure: required script missing

Stop immediately and report which script is missing. The workflow should not be generated until ci.sh and ci.bat are present.

### Failure: YAML syntax error

Fix the YAML structure and re-validate the file before reporting success.

### Failure: macOS or Windows job fails due to path or line-ending issues

Check .gitattributes and ensure script line endings match the expected platform behavior. Correct the file endings and re-run validation.
