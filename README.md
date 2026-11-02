# KPA1500 SDR Bridge

Connects an Elecraft KPA1500 amplifier (and an optional Telepost LP-100A meter) to **Thetis** (also Thetis HL2 and SDR-VST3) or **NereusSDR**, with a FlexControl knob, a browser control panel and a small **Applet** window.

Design and on-air testing by KW4EX. Version 2.40.

## What it does
- Follows the radio frequency so the amplifier changes band by itself.
- Standby on Tune: the amplifier drops to STANDBY while the radio tunes.
- Live amplifier and LP-100A readings; Operate/Standby, ATU, antenna, fan, clear fault, power on/off.
- FlexControl knob support for both radio programs.
- No-antenna protection: warn, warn and go to STANDBY, or refuse TUNE (or off).
- Works with Thetis or NereusSDR, one at a time; it finds out which one is running.
- **Applet window**: meters, buttons, knob lines and LP-100A in one small window. Top line with frequency, Operate/Standby and Power. Colours, size, zoom, shrink-to-fit, sections and order are set from the window.
- Ready-made Thetis windows (Telemetry, Controls, Knob) with your own item order and titles.
- Starting a new bridge closes one that is already running; `Stop_Bridge.bat` closes it cleanly.

## Install (Windows)
1. Install Python 3.8 or newer from python.org (tick Add Python to PATH).
2. Download `Install_KPA1500_SDR_Bridge.bat` and double-click it. It asks a few short questions and installs into its own `KPA1500_SDR_Bridge` subfolder (suggested: `C:\RadioScripts`).
3. Or copy the files into a folder yourself, run `py -m pip install pyserial` (LP-100A and knob), and double-click `start_kpa_sdr_bridge.bat`.

## NereusSDR settings (once)
All in **File > Settings... > CAT & Network**.

| Page | Setting | Value |
|---|---|---|
| TCI Server | Enable TCI Server | on |
| TCI Server | Listen on / Port | `127.0.0.1` / `50001` |
| TCI Server | Compatibility, VFO Quirks, IQ Stream, Sensors | leave at defaults |
| TCP/IP CAT | Enable TCP CAT | on |
| TCP/IP CAT | CAT 1 Listen on / Port | `127.0.0.1` / `13013` |
| TCP/IP CAT | CAT 1 **VFO A** | **Slice A** (may show as Slice ID 0) - required |
| TCP/IP CAT | CAT 1 VFO B | empty |

- Without the VFO A binding NereusSDR answers `?;` and the knob and TUNE do nothing.
- Only one program can use TCI port 50001: close Thetis first.
- TUNE keys the radio through CAT, so this NereusSDR window must hold transmit control (TXcontrol).
- Test: CAT Options > CAT Tester, channel CAT 1, send `ZZVN;` - you should get a version.
- Optional: the bridge sends readings as JSON/UDP to port 50110 for NereusSDR containers; some builds cannot add that data source yet. The Applet does not need it.

## Thetis settings (once)
Setup > Serial/Network/Midi CAT > Network tab > TCI Server: Bind IP:Port `127.0.0.1:50001` and tick **TCI Server Running**. Apply, OK, close Thetis normally. For Thetis HL2 always use its own shortcut (`-dbid:HL2`). Then run `Setup_Thetis_Containers.bat` (Thetis closed) to add the KPA1500 windows.

## Start and stop
- Start: `start_kpa_sdr_bridge.bat` (closes an older bridge first; flags are set inside the file).
- Stop: `Stop_Bridge.bat`, or Applet > Look > Bridge > Quit bridge, or Q in the bridge window.
- Applet again: `Open_Applet.bat` or http://127.0.0.1:8080/applet

## Files
- `kpa1500_sdr_bridge.py` the program (Python standard library only; `pyserial` only for the LP-100A and the knob)
- `start_kpa_sdr_bridge.bat`, `Open_Applet.bat`, `Stop_Bridge.bat` double-click helpers
- `Install_KPA1500_SDR_Bridge.bat` the installer
- `kpa1500_thetis_setup.py`, `Setup_Thetis_Containers.bat`, `Undo_Thetis_Containers.bat` add or remove the KPA1500 windows inside Thetis
- `KPA_Network_Check.bat`, `kpa_netcheck.ps1` read-only network check
- `KPA1500_Bridge_Help.html` the full help with every setting

The older Thetis-only program is at github.com/kw4ex/kpa1500-thetis-bridge.

## Status
Tested against simulated amplifier and radio programs and on one station (Thetis and NereusSDR). Reports are welcome.

## Licence
MIT, see `LICENSE`.
