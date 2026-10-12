# Usage

## 1. Prerequisites

- Git
- Python 3.12
- VS Code with the GitHub Copilot and Copilot Chat extensions
- A GitHub account with Copilot access signed in to VS Code

## 2. Running the agent

1. Open the repository folder in VS Code.
2. Create a feature branch with `git switch -c feature/hello-world`.
3. Open Copilot Chat.
4. Switch to Agent mode.
5. Select the `build-engineer` agent.
6. Run the command `/init`.
7. Review every generated file before committing.
8. Run `/check` at any time to validate the project without changing it.

The individual commands are:

- `/git-init`
- `/create-project`
- `/create-build`
- `/create-actions`
- `/check`
- `/init`

> The `/init` command refuses to run on the `develop`, `master`, and `main` branches.

## 3. Re-running

The `init` command is idempotent. It creates only missing files and does not overwrite or duplicate existing content.

## 4. Local build and test

On Windows, run:

```powershell
ci.bat
```

On Linux and macOS, run:

```bash
bash ci.sh
```

The scripts create `.venv`, install the project requirements, run pytest, build `dist/hello` with PyInstaller, and run the built program.

## 5. Running the built program

On Windows:

```powershell
.\dist\hello.exe
```

On Linux and macOS:

```bash
./dist/hello
```

Expected output:

```text
Hello, World!
```

## 6. Troubleshooting

- If `python` is not found, install Python 3.12 and reopen the terminal.
- If PowerShell blocks script execution, run the command in a shell that allows local scripts or adjust the execution policy for the current user.
- `build/` and `dist/` are git-ignored and safe to delete manually if needed.
