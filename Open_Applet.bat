@echo off
REM Opens the Applet window of the bridge that is already running.
REM (If you started the bridge with --web-port, change 8080 below.)
curl -s -X POST -H "Content-Type: application/json" -H "X-KPA: 1" -d "{\"action\":\"applet_window\"}" http://127.0.0.1:8080/api/cmd >nul 2>&1
if errorlevel 1 (
  echo The bridge does not seem to be running. Start it with start_kpa_sdr_bridge.bat
  pause
)
