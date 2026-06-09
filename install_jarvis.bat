@echo off
title Install J.A.R.V.I.S - Auto Start
echo.
echo  Installing J.A.R.V.I.S Desktop Assistant
echo  ========================================
echo.

:: Create shortcut in Startup folder
set SCRIPT_DIR=%~dp0
set SHORTCUT_PATH="%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\JARVIS.lnk"

:: Create shortcut using PowerShell
powershell -Command ^
  $ws = New-Object -ComObject WScript.Shell; ^
  $s = $ws.CreateShortcut('%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\JARVIS.lnk'); ^
  $s.TargetPath = 'powershell.exe'; ^
  $s.Arguments = '-WindowStyle Hidden -ExecutionPolicy Bypass -NoProfile -File "%SCRIPT_DIR%jarvis_assistant.ps1"'; ^
  $s.Description = 'J.A.R.V.I.S AI Assistant - Voice controlled desktop helper'; ^
  $s.WorkingDirectory = '%SCRIPT_DIR%'; ^
  $s.Save()

if exist %SHORTCUT_PATH% (
  echo  [OK] J.A.R.V.I.S added to Windows Startup.
  echo.
  echo  JARVIS will now launch every time you log in.
  echo  It will greet you and wait for voice commands.
  echo.
  echo  To start now, double-click: start_jarvis.bat
  echo  To remove from startup, delete: %SHORTCUT_PATH%
) else (
  echo  [ERROR] Could not install.
)
echo.
pause