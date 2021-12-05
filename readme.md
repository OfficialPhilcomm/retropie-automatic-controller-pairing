# Introduction

This package adds the ability for RetroPie to detect Bluetooth Gamepads that are in pairing mode and automatically connect them to the system.  
There is a chance that some controllers are not compatible with this script. For more info on that, check out [Tested Controllers](#tested-controllers)
This is a work in progress, not everything works well yet, and not all planned features are implemented. See [To-Do List](#to-do-list) for more information.

# Installation

Run this command on the device:

```
wget -P /home/pi/RetroPie-Setup/ext/dev_philcomm/scriptmodules/supplementary/ "https://raw.githubusercontent.com/OfficialPhilcomm/retropie-automatic-controller-pairing/master/automatic-gamepad-pairing.sh"
```

This will add the scriptmodule to RetroPie-Setup. You will then be able to find it in `Manage Packages -> Optional`.

# Tested Controllers
Confirmed to work:
- 8BitDo FC30 Pro
- 8BitDo SF30 Pro
- Dualshock 4 (doen't 100% work, like with the RetroPie built in bluetooth manager)

Confirmed incompability:
So far none :tada:

# To-Do List
- [ ] Make only devices that are in pairing mode discoverable
- [ ] Add systemd service
- [ ] Add retropie scriptmodule
