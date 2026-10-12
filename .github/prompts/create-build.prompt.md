---
description: "Create the test and build configuration for the Python Hello World project without running the build."
agent: build-engineer
---

# Purpose

Apply the build-and-test skill to generate the testing and packaging configuration for the Python Hello World project without running the build itself.

## Preconditions

- src/hello/main.py exists.
- If it does not exist, stop and report that the project scaffold must be created first.

## Actions

1. Apply the skill: [.github/skills/build-and-test/SKILL.md](../../.github/skills/build-and-test/SKILL.md)
2. Create missing files only.
3. Update existing files minimally and never duplicate configuration.
4. Generate the following files if missing:
   - tests/test_basic.py
   - pytest.ini
   - requirements.txt
   - ci.sh
   - ci.bat
5. Do not execute the build process in this command.

## Expected files

- tests/test_basic.py
- pytest.ini
- requirements.txt
- ci.sh
- ci.bat

## Verification

- All five files exist.
- ci.sh uses LF line endings.
- ci.bat uses CRLF line endings.
- The generated configuration matches the expected Python Hello World project layout.

## Error message

If src/hello/main.py is missing: "The project scaffold is missing. Please run create-project first so src/hello/main.py exists."
