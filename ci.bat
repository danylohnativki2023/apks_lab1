@echo off
setlocal

set "SCRIPT_DIR=%~dp0"
cd /d "%SCRIPT_DIR%"

echo [1/6] Ensuring virtual environment exists...
if not exist .venv (
    python -m venv .venv
    if errorlevel 1 exit /b 1
)

echo [2/6] Activating virtual environment...
call .venv\Scripts\activate.bat
if errorlevel 1 exit /b 1

echo [3/6] Installing dependencies...
pip install -r requirements.txt
if errorlevel 1 exit /b 1

echo [4/6] Running pytest...
pytest
if errorlevel 1 exit /b 1

echo [5/6] Building application with PyInstaller...
pyinstaller --onefile --name hello --distpath dist --workpath build --specpath build src\hello\main.py
if errorlevel 1 exit /b 1

echo [6/6] Running built application...
set "OUTPUT="
if not exist dist\hello.exe (
    echo Error: dist\hello.exe was not created.
    exit /b 1
)
for /f "delims=" %%i in ('dist\hello.exe') do set "OUTPUT=%%i"
if not "%OUTPUT%"=="Hello, World!" (
    echo Error: built application output was '%OUTPUT%', expected 'Hello, World!'
    exit /b 1
)

echo Build and test completed successfully.
