KPA1500 SDR Bridge - Mac and Linux (EXPERIMENTAL)
=================================================
Design and on-air testing by KW4EX. No warranty. Use at your own risk.
Not made or approved by Elecraft, FlexRadio, Telepost, Thetis or NereusSDR.

WHAT THIS IS
  The same bridge as the Windows version: it connects your Elecraft KPA1500
  to NereusSDR (on this computer) or to Thetis (on another computer), shows
  the panel in a browser, and has the Applet window.
  The Thetis container windows (buttons inside Thetis) are Windows-only and
  are not part of this package. SDR-VST3 and Thetis HL2 are Thetis-family
  programs and run on Windows, so use them from this Mac/Linux bridge only
  by pointing the bridge at that Windows computer (option 2 in Step 4).

WHAT YOU NEED
  - Python 3.8 or newer.
      Mac:    in Terminal type  xcode-select --install   (or install from python.org)
      Linux:  sudo apt install python3 python3-venv   (Debian, Ubuntu, Raspberry Pi OS)
  - The KPA1500 switched on and on the same network as this computer.
  - NereusSDR, or Thetis running on another computer.

INSTALL - STEP BY STEP
  1. Download Install_KPA1500_SDR_Bridge.sh to your Downloads folder.
  2. Open Terminal (Mac: Applications > Utilities > Terminal).
  3. Type the word  bash  and then a space. Do not press Enter yet.
  4. Drag the file Install_KPA1500_SDR_Bridge.sh from Finder into the Terminal
     window. Its path appears. Press Enter.
  5. Answer the questions. Pressing Enter accepts the answer shown in [ ].
     The seven steps are: Python, install folder, amplifier, radio program,
     LP-100A, panel for other devices, start files and shortcuts.
  6. If the Mac says the file cannot be opened because it is from an
     unidentified developer, you ran it by double-clicking. Use the Terminal
     method above, or in Terminal type:  xattr -d com.apple.quarantine  and
     drag the file in after it, then try again.
  The default folder is RadioScripts/KPA1500_SDR_Bridge in your home folder.
  Installing again over an older copy keeps your settings and saves the old
  program as a .bak file.

SET UP NereusSDR (once)
  In NereusSDR open File > Settings > CAT & Network.
   - TCI Server page: tick Enable TCI Server, listen on 127.0.0.1, port 50001.
   - TCP/IP CAT page: tick Enable TCP CAT. CAT 1: 127.0.0.1, port 13013.
     Set VFO A = Slice A (it may show as Slice ID 0). Leave VFO B empty.
     Without the VFO A binding the knob and the TUNE button do nothing.
   - Only one radio program can use port 50001 at a time.
   - TUNE needs the NereusSDR window to hold transmit control (TXcontrol).

SAFE FIRST TEST (nothing is sent to the amplifier)
  In Terminal, in the install folder, type:
      ./start_kpa_sdr_bridge.sh --dry-run        (Mac and Linux)
  Check that the panel opens at http://127.0.0.1:8080 and NereusSDR shows as
  connected. Press Q to stop. Use a dummy load for your first transmissions.

START AND STOP
  Mac:    double-click  Start KPA1500 SDR Bridge.command  in the install folder
          (or the Desktop shortcut). Stop with Stop KPA1500 SDR Bridge.command.
  Linux:  run start_kpa_sdr_bridge.sh and stop_bridge.sh in the install folder.
  The panel is at http://127.0.0.1:8080 . Open_Applet opens the Applet window.
  Start options are in kpa1500_start.conf (edit, then start again).
  A Mac that goes to sleep stops the bridge.
  Linux automatic start is a user service. To start it with nobody signed in:
      sudo loginctl enable-linger YOURNAME
  Other devices: if you allowed them, use http://THIS-COMPUTER-ADDRESS:8080/?t=PASSWORD

COMPLETE UNINSTALL
  Mac:    double-click  Uninstall KPA1500 SDR Bridge.command  in the install folder.
  Linux:  bash ~/RadioScripts/KPA1500_SDR_Bridge/uninstall_kpa1500_sdr_bridge.sh
  It asks before each part. It: closes the running bridge, removes the login
  item or service, removes the Desktop shortcut and temporary files, and then
  (if you say yes) deletes the bridge's files, its private Python (.venv) and
  the folder itself. Your NereusSDR and Thetis settings are never touched.
  To keep your settings file for a later reinstall, answer n at that question.

IF SOMETHING GOES WRONG
  - "Python 3.8 or newer was not found": install Python as shown above.
  - No amplifier found: check it is on, on the same network, and not behind
    a different router; or type its address.
  - Port 8080 in use: start with  --web-port 8081  added in kpa1500_start.conf.
  - Run  bash start_kpa_sdr_bridge.sh  in Terminal to see the messages.
  - Self-test: python3 kpa1500_sdr_bridge.py --selftest  (last line should say ALL TESTS PASSED).
