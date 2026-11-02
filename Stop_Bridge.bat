@echo off
REM Closes a running bridge (this one or the older Thetis-only one) and its window.
cd /d "%~dp0"
py -3 kpa1500_sdr_bridge.py --stop-running
timeout /t 3 >nul
