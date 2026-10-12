# Architecture of the AI Agent for a Cross-Platform Python Hello World Project

## 1. Problem statement

The agent solves a recurring set of project setup problems for a small Python application:

- repeatable project scaffolding for a cross-platform Hello World app
- consistent Python environment setup with venv and dependency management
- automated test configuration with pytest
- build automation with PyInstaller for both Unix-like and Windows environments
- CI generation for GitHub Actions
- verification before reporting success so that generated files and workflows are checked against the intended result

The goal is to create a predictable repository structure that can be recreated reliably without manual copy-paste setup.

## 2. Agent: .github/agents/build-engineer.agent.md

The build-engineer agent is responsible for creating and validating a Python project skeleton for a Hello World application.

Responsibilities:

- generate the initial project layout
- configure venv-based local development and dependency installation
- create build scripts and PyInstaller packaging settings
- generate test and CI configuration
- verify that generated files exist and match the expected structure
- orchestrate command execution in a safe, repeatable order
- avoid destructive actions and protect repository integrity

This agent acts as the implementation and verification layer for project generation and automation.

## 3. Skills

| Name | Purpose | Inputs | Outputs | Verification |
| --- | --- | --- | --- | --- |
| project-scaffold | Creates the base repository structure and Python project files | project name, language, target layout | src tree, config files, requirements, test scaffold | confirm required files exist and contain expected configuration |
| build-and-test | Sets up test and packaging commands for Python | project layout, dependencies, build tool | pytest.ini, requirements, build scripts, PyInstaller config | run checks and validate script execution paths |
| github-actions | Creates CI workflow automation for build and test | repository metadata, runner targets, scripts | .github/workflows/ci.yml and helper files | validate YAML syntax and that workflow calls the defined scripts |

Each skill is represented by a markdown specification under .github/skills/<name>/SKILL.md.

## 4. Commands

| Name | Purpose | Precondition | Expected files |
| --- | --- | --- | --- |
| git-init | Checks that the repository exists, creates or updates .gitignore without removing existing entries, and shows the Git status | repository folder exists | .git, .gitignore, optional repo config |
| create-project | Creates the Python project skeleton | valid project name and language | src/hello/main.py, tests/test_basic.py, requirements.txt, pytest.ini |
| create-build | Creates build and run scripts for local packaging | project scaffold exists | ci.sh, ci.bat, packaging configuration |
| create-actions | Creates GitHub workflow automation | build scripts exist | .github/workflows/ci.yml |
| check | Verifies outputs and file existence | project scaffolding and generated files are present | validation output, file checks for all required paths |
| init | Main orchestrator | repository is available | all project files and CI artifacts produced in required order |

The orchestrator command is defined in .github/prompts/init.prompt.md and runs the following sequence:

1. git-init
2. create-project
3. create-build
4. create-actions
5. check

## 5. Data flow between stages

The flow is intentionally linear and minimal:

- create-project receives the project name and language as inputs
- those values are propagated to later stages for path generation and package naming
- create-build uses the project name to create build artifacts and packaging commands
- create-actions uses the same project identity to generate workflow references
- check validates that all created file paths exist and are consistent with the project definition

This ensures that generated paths remain aligned across scaffolding, build scripts, and CI workflow definitions.

## 6. Orchestrator error handling

The orchestrator follows strict error-handling rules:

- stop immediately on the first failed step
- print the exact step name that failed and the reason for the failure
- never claim success without running check
- treat repeated execution as idempotent: re-running init must not overwrite or duplicate files
- prefer creating missing files only when they do not already exist, and skip unchanged content

This reduces accidental repository corruption and ensures consistent generated output.

## 7. Safety rules

The agent must follow these safety constraints:

- no secrets or credentials are added to files or workflow configuration
- no deleting files during generation or verification
- no force-push commands or history rewrite commands
- no changes to branch protection rules or repository security settings
- all actions must be limited to project scaffolding, validation, and automation tasks

## 8. Planned project layout

The expected repository layout is:

```text
README.md
.gitignore
.gitattributes
docs/
  architecture.md
  usage.md
.github/
  agents/
  prompts/
  skills/
  workflows/
    ci.yml
src/
  hello/
    main.py
tests/
  test_basic.py
pytest.ini
requirements.txt
ci.sh
ci.bat
dist/
  hello(.exe)
```

The dist/ directory is a build output and is not committed to Git.

The GitHub Actions workflow only invokes the platform-appropriate script:

- ci.sh on Unix-like runners
- ci.bat on Windows runners

PyInstaller builds the distributable output in dist/ as hello or hello.exe depending on the platform.

## 9. File-role mapping in the GitHub Copilot in VS Code environment

| Type | Role in the lab | Example |
| --- | --- | --- |
| agents | define the persona and responsibilities for specialized automation | .github/agents/build-engineer.agent.md |
| prompts | represent command-level tasks executed by the orchestrator | .github/prompts/git-init.prompt.md, .github/prompts/init.prompt.md |
| skills | describe reusable capabilities used by commands and the agent | .github/skills/project-scaffold/SKILL.md |
| workflows | execute CI automation in GitHub Actions | .github/workflows/ci.yml |

This mapping clarifies how the lab organizes the AI workflow into roles, reusable skills, command prompts, and continuous integration automation.

## 10. Branch workflow

The develop branch contains only the agent files, skills, prompts, and documentation. In this branch, the repository is used as the source for the AI workflow definition and project guidance.

Running the init command on develop reproduces the full project on a feature branch. The generated project files are created there, and the result is merged back through a pull request named lab1/finish.
