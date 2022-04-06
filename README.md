# BuyCommands-Redux
A reworked and updated version KoreanDude's [sm_buycommands](https://github.com/KoreanDude/csgo-ze-plugins/blob/master/Buy%20Commands/sm_buycommands.sp) plugin.

## Changes
- Updated plugin to utilize New-Style Declarations
- Added Incendiary Grenade, TA Grenade, and Snowball grenade options
- Added per-weapon type restriction cvars
- Updated plugin message information and colors (including how much money needed or how many purchases left)
- Condensed weapon drop settings buy leaving it as one cvar for all
- Removed `<smlib>` and `<zombiereloaded>` dependency so plugin can be used on MG servers as well
- Added additional buy commands for plugins

## To-Do List
- Add translation file instead of hard coding plugin messages
- Possibly add per-weapon cooldown system/per-weapon restriction system (?)
- Add a `sm_guns` menu to buy weapons and/or save loadouts (?)

## Update Log
#### Version 2.0.1
- Fixed some incorrect messages