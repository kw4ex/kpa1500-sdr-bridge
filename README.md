# KPA1500 SDR Bridge

**Windows is the main version** (Windows 10 and 11). A separate **experimental, untested Mac and Linux version** for NereusSDR is on the [Releases page](https://github.com/kw4ex/kpa1500-sdr-bridge/releases) (marked Pre-release) and in the `mac-linux` folder; see [Mac and Linux](#mac-and-linux-experimental-untested). The Windows installer and `.bat` files do not work on a Mac or Linux.

Connects an Elecraft KPA1500 amplifier (and an optional Telepost LP-100A meter) to **Thetis** (also Thetis HL2 and SDR-VST3) or **NereusSDR**, with a FlexControl knob, a browser control panel and a small **Applet** window.

Design and on-air testing by KW4EX. Version 2.44.

## What it does
- Follows the radio frequency so the amplifier changes band by itself.
- Standby on Tune: the amplifier drops to STANDBY while the radio tunes.
- Live amplifier and LP-100A readings; Operate/Standby, ATU, antenna, fan, clear fault, power on/off.
- FlexControl knob support for both radio programs.
- No-antenna protection: warn, warn and go to STANDBY, or refuse TUNE (or off).
- **Over-drive protection**: set one limit in watts into the amplifier; the bridge reads the radio program's drive setting before you transmit and watches the measured drive, then ignores, warns, or holds the drive at the limit. Only while the amp is in OPERATE (not in STANDBY or while its ATU tunes); short peaks are ignored. Set it in the panel Settings or the Applet Look menu.
- Works with Thetis or NereusSDR, one at a time; it finds out which one is running.
- **Applet window**: meters, buttons, knob lines and LP-100A in one small window. Top line with frequency, Operate/Standby and Power. Colours, size, zoom, shrink-to-fit, sections and order are set from the window.
- Ready-made Thetis windows (Telemetry, Controls, Knob) with your own item order and titles, and a choice of button look (Standard or Legacy) for the Controls window.
- Starting a new bridge closes one that is already running; `Stop_Bridge.bat` closes it cleanly.

## Download

**Start at the [Releases page](https://github.com/kw4ex/kpa1500-sdr-bridge/releases/latest).** The top entry marked **Latest** is the newest version; older versions stay listed below it. In the **Assets** list click **Install_KPA1500_SDR_Bridge.bat** (not "Source code"). Step-by-step download instructions are on the release page.

**Full guide:** [Install and User Guide (PDF)](docs/guides/KPA1500-SDR-Bridge-guide.pdf) - step by step install, every setting, troubleshooting. It is also in the Assets list of each release.

## Install (Windows)
1. Install Python 3.8 or newer from python.org (tick Add Python to PATH).
2. Download `Install_KPA1500_SDR_Bridge.bat` from the Releases page and double-click it. It asks a few short questions and installs into its own `KPA1500_SDR_Bridge` subfolder (suggested: `C:\RadioScripts`).
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

The older Thetis-only program is at github.com/kw4ex/kpa1500-thetis-bridge (it keeps working; run only one of the two).

## Mac and Linux (experimental, untested)

**Not yet tried on a real Mac, Linux computer, KPA1500 or radio.** It passed the program's self-test and an install, start, stop and uninstall run on Linux with simulated equipment. Use `--dry-run` first (nothing is sent to the amplifier) and a dummy load for first transmissions. Thetis, Thetis HL2 and SDR-VST3 are Windows programs: from a Mac or Linux the bridge can reach them on another computer, and there are no Thetis windows.

1. Download `mac-linux/Install_KPA1500_SDR_Bridge.sh` and `mac-linux/README_Mac_Linux.txt` (or the same files from the Pre-release).
2. Open Terminal, type `bash ` (with a space), drag the `.sh` file into the window and press Enter.
3. Answer the questions (Enter accepts the answer in brackets). Follow `README_Mac_Linux.txt` for the NereusSDR settings and the safe first test.
4. To remove everything later: run `uninstall_kpa1500_sdr_bridge.sh` from the install folder.

Design and on-air testing by KW4EX. No warranty, use at your own risk. Not made, approved or supported by Elecraft, FlexRadio, Telepost, Thetis or NereusSDR.

## Status
Tested against simulated amplifier and radio programs and on one station (Thetis and NereusSDR). Reports are welcome.

## Licence
MIT, see `LICENSE`.
