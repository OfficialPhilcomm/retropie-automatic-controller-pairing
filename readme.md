# Introduction

This package adds the ability for RetroPie to detect Bluetooth Gamepads that are in pairing mode and automatically connect them to the system.  
There is a chance that some controllers are not compatible with this script. For more info on that, check out [Tested Controllers](#tested-controllers)
This is a work in progress, not everything works well yet, and not all planned features are implemented. See [To-Do List](#to-do-list) for more information.

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
