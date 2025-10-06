# BScript Combat Log Script
## Hello Masters of the Dusty Paths
Do you want to maintain role integrity on your server, prevent unfair advantages, and ensure fairness among players?
Here is a system developed precisely for this purpose: Advanced Game Exit Tracking Script – completely free, open source, performance-friendly, and user-focused.

## Features

### Active Role Game Exit Detection
- Exits (quits), disconnections (timeouts), game crashes, or fake quits occurring during a role are automatically detected and recorded by the system.

### Different Animation Support for Female and Male Characters
- Different animation features are available and defined for female and male characters.

### Detailed and Transparent Logging System
- When a player quits, the following information is automatically logged by the system and can be viewed with a single click:

- Player ID

- Steam ID

- Discord ID

- Reason for quitting

- Time of quitting

- This system was developed to facilitate support processes and increase management transparency.

### Low Resource Consumption
- The code structure is optimised to deliver high performance. It does not place extra load on the server and runs stably even in low-spec environments.

### Free and Open Source
- All features are offered free of charge, and the system is shared with an open-source code structure. It can be reviewed, customised, and integrated into different structures by developers.

# Insatllation
- Place the script folder into the resource directory.
- Navigate to your server.cfg file.
- Add `ensure BS-CombatLog` to the bottom of your server.cfg file and save it.
- Restart your server.
## VORP
- Open your `vorp_character/client/client.lua` file. 
- Add the following code to line 722.
```lua
exports("LoadPlayerComponents", LoadPlayerComponents)
```
- Save the file.

> [CFX Release Post](https://forum.cfx.re/t/free-bs-storerobbery-heist-robbery-script-npc-responsive/5280905)

# Join Discord (24/7 Support)
> [Discord](https://discord.gg/dxVJ2wxfc6)
