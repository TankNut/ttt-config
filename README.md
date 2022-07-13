# TTT Config
A weapon configuration tool for Trouble in Terrorist Town.

Vanilla TTT doesn't like being configured, often requiring server owners to dive into the gamemode files themselves if they want to change what weapons spawn and how they're spawned. This tool aims to fix that by hooking into the gamemode through a few hacky methods and completely replaces the methods used to populate the map with entities.

## Installation

Install the addon as you would any other, either through dropping a copy from github into your addons folder or subscribing through the workshop (when uploaded there)

## Configuration

TODO

## How it works

The tool does several things based on how it's configured.

Firstly it hooks into both PreRegisterSENT and SWEP, using it to patch some base entities to ensure compatibility and to rewrite weapons/ammo based on the config file. This patching mainly targets traitor/detective shop availability, world spawning, ammo usage and slot position.

Secondly it detours ents.TTT.PlaceExtraWeapons and ents.TTT.ProcessImportScript which is where the bulk of the functionality lies.

By detouring the aforementioned functions we're effectively replacing the map population functions with our own. In these functions we essentially copy the same method the gamemode would normally use but instead of spawning entities on the map we're creating a list of entity categories (e.g. SPAWN_PISTOL, SPAWN_RIFLE, SPAWN_SNIPER) linked to a position.

This list is then fed into our own spawn script which'll look through the configuration and spawn entities (together with their ammo) based on the categories created earlier, meaning that pistols get replaced by pistols and not by rifles.

###### Why does ammo spawn with weapons instead of in the normal spots?

Because TTT that's why.

The M16 (The only 'rifle' included with the gamemode) uses pistol ammo, so while I'd like to replace ammo types 1:1 there's no way to tell if a pistol ammo box was intended for an M16 or for a pistol. There's no way to fix this so the next best step was to forgo loose ammo spawns alltogether and just spawn weapons with an ammo box next to them.

As for why there's only one box, spawning more than one ends up looking goofy so I settled on just the one. The configuration files allow you to modify how much ammo spawns in a box (including randomized amounts) so you can compensate with that.
