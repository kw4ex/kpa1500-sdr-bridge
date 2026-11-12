@echo off
setlocal EnableDelayedExpansion
title Uninstall KPA1500 SDR Bridge
cd /d "%~dp0"
echo ===========================================================
echo   Uninstall KPA1500 SDR Bridge
echo ===========================================================
echo.
echo This removes, one step at a time:
echo   1. the running bridge (it is closed for you)
echo   2. the KPA1500 windows inside Thetis (only if you agree)
echo   3. the shortcuts (Desktop, Start menu, Windows startup)
echo   4. the Windows firewall rules the installer added (asks permission)
echo   5. the bridge's own files in this folder (only if you agree)
echo.
echo Python and pyserial are NOT removed (other programs may use them).
echo Your radio program (Thetis, NereusSDR ...) and the amplifier are not changed.
echo.
pause

echo.
echo --- Step 1: closing the bridge ---
powershell -NoProfile -Command "Get-CimInstance Win32_Process | Where-Object { ($_.CommandLine -like '*kpa1500_thetis_bridge.py*' -or $_.CommandLine -like '*kpa1500_sdr_bridge.py*') -and $_.Name -match '^(python|pythonw|py|pyw|cmd)' } | ForEach-Object { Stop-Process -Id $_.ProcessId -Force }" >nul 2>&1
echo Done.

echo.
echo --- Step 2: the KPA1500 windows inside Thetis ---
set "PY=py -3"
where py >nul 2>&1 || set "PY=python"
if not exist kpa1500_thetis_setup.py goto nothetis
echo The installer may have added KPA1500 Telemetry, Controls and Knob windows to Thetis,
echo Thetis HL2 or SDR-VST3. Removing them puts back the settings the program had before.
set /p RMT=Remove the KPA1500 windows from Thetis now? (y/N): 
if /i "%RMT%"=="y" %PY% kpa1500_thetis_setup.py --remove
:nothetis

echo.
echo --- Step 3: shortcuts ---
powershell -NoProfile -Command "foreach($f in 'Desktop','Programs','Startup'){ $p=[Environment]::GetFolderPath($f); if($p){ Get-ChildItem -LiteralPath $p -Filter 'KPA1500 SDR Bridge*.lnk' -ErrorAction SilentlyContinue | Remove-Item -Force -ErrorAction SilentlyContinue } }" >nul 2>&1
echo Shortcuts removed (Desktop, Start menu, Startup).

echo.
echo --- Step 4: Windows firewall rules ---
set "FW=0"
netsh advfirewall firewall show rule name="KPA1500 Bridge panel TCP 8080" >nul 2>&1 && set "FW=1"
netsh advfirewall firewall show rule name="KPA1500 Bridge buttons UDP 50101" >nul 2>&1 && set "FW=1"
if "%FW%"=="0" (
  echo No KPA1500 firewall rules found. Nothing to do.
  goto fwdone
)
> "%TEMP%\kpa_fw_remove.bat" echo @echo off
>> "%TEMP%\kpa_fw_remove.bat" echo netsh advfirewall firewall delete rule name="KPA1500 Bridge panel TCP 8080"
>> "%TEMP%\kpa_fw_remove.bat" echo netsh advfirewall firewall delete rule name="KPA1500 Bridge buttons UDP 50101"
>> "%TEMP%\kpa_fw_remove.bat" echo timeout /t 2 ^>nul
echo Windows will now ask for permission (UAC) to remove the network rules. Click Yes.
powershell -NoProfile -Command "Start-Process -FilePath 'cmd.exe' -ArgumentList '/c','\"%TEMP%\kpa_fw_remove.bat\"' -Verb RunAs -Wait" >nul 2>&1
del "%TEMP%\kpa_fw_remove.bat" >nul 2>&1
netsh advfirewall firewall show rule name="KPA1500 Bridge panel TCP 8080" >nul 2>&1 && (
  echo The rules are still there - permission was not given. To remove them yourself, open an
  echo Administrator Command Prompt and run:
  echo   netsh advfirewall firewall delete rule name="KPA1500 Bridge panel TCP 8080"
  echo   netsh advfirewall firewall delete rule name="KPA1500 Bridge buttons UDP 50101"
) || echo Firewall rules removed.
:fwdone
rmdir /s /q "%TEMP%\kpa1500_applet_profile" >nul 2>&1

echo.
echo --- Step 5: the bridge's own files ---
echo This folder may hold other things too. Only the bridge's own files are deleted,
echo never the folder's other contents.
set /p DEL=Delete the bridge's own files (program, help, settings, logs)? (y/N): 
if /i not "%DEL%"=="y" goto keep
for %%F in (kpa1500_sdr_bridge.py kpa1500_thetis_setup.py KPA1500_Bridge_Help.html start_kpa_sdr_bridge.bat Setup_Thetis_Containers.bat Undo_Thetis_Containers.bat kpa1500_settings.json kpa1500_bridge.log kpa1500_bridge.log.tmp install_log.txt install_selftest.txt kpa1500_mac.txt KPA_Network_Check.bat kpa_netcheck.ps1 kpa_network_check.txt Open_Applet.bat Stop_Bridge.bat README_SDR_Bridge.txt KPA1500-SDR-Bridge-guide.pdf) do del "%~dp0%%F" 2>nul
del "%~dp0kpa1500_sdr_bridge.py.*.bak" 2>nul
del "%~dp0start_kpa_sdr_bridge.bat.*.bak" 2>nul
rmdir /s /q "%~dp0__pycache__" 2>nul
if exist "%~dp0thetis_backups" (
  echo.
  echo The folder thetis_backups holds copies of your Thetis settings from before the setup.
  set /p DELB=Delete it too? Keep it if you may want to go back. ^(y/N^): 
  if /i "!DELB!"=="y" rmdir /s /q "%~dp0thetis_backups"
)
echo.
echo The bridge files are deleted. Other files in the folder were not touched.
echo This uninstaller removes itself now (and the folder if it is empty).
pause
start "" cmd /c "timeout /t 2 >nul & del ""%~f0"" & rmdir ""%~dp0."" 2>nul"
exit /b
:keep
echo.
echo Files kept. You can delete them yourself later.
pause
