# BuyCommands-Redux
A reworked and updated version KoreanDude's [sm_buycommands](https://github.com/KoreanDude/csgo-ze-plugins/blob/master/Buy%20Commands/sm_buycommands.sp) plugin. This plugin allows players to purchase weapons and equipments via several commands (etc. `sm_bizon` or `sm_p90`). Unfortunately, this does not have advanced features such as the popular ZBuy plugin used on several servers, but this is still an alternative for a more simple approach and is supported even on servers without Zombie:Reloaded plugin.

## Thanks and Credits
- Credits to [KoreanDude](https://github.com/KoreanDude) for making/releasing the original plugin
- Thanks to [Detroid](https://steamcommunity.com/id/2132423/) for testing and reporting errors in the plugin
- Thanks to [tilgep](https://github.com/tilgep) for fixing `sm_p2000` giving the incorrect pistol due to [weapon prefabs](https://ibb.co/BgxGmSK)

## Changes
- Updated plugin to utilize New-Style Declarations
- Added Incendiary Grenade, TA Grenade, and Snowball grenade options
- Added per-weapon type restriction cvars
- Updated plugin message information and colors (including how much money needed or how many purchases left)
- Condensed weapon drop settings buy leaving it as one cvar
- Removed `<smlib>` and `<zombiereloaded>` dependency so plugin can be used on MG servers as well
- Added additional buy commands for weapons
- Utilizes a translation file for easier customizability of plugin messages

## Change Logs
### Version 2.0.1
- Fixed some incorrect messages
### Version 2.0.2
- Reworked source code formatting
### Version 2.1.0
- Fixed `Command_HKP2000` giving incorrect pistol *(Thanks tilgep!)*
- Code refactoring to utilize translation files