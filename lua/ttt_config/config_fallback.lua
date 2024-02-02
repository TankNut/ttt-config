AddCSLuaFile()

module("ttt_config.Config", package.seeall)

-- Ammo defines

Ammo = {
	["item_ammo_357_ttt"] = {Type = "357", Amount = 10, Max = 20},
	["item_ammo_pistol_ttt"] = {Type = "Pistol", Amount = 20, Max = 60},
	["item_ammo_revolver_ttt"] = {Type = "AlyxGun", Amount = 12, Max = 36},
	["item_ammo_smg1_ttt"] = {Type = "SMG1", Amount = 30, Max = 60},
	["item_box_buckshot_ttt"] = {Type = "Buckshot", Amount = 8, Max = 24}
}

-- Weapon defines

Weapons = {
	-- Default weapons we want to leave untouched

	["weapon_ttt_binoculars"] = true,
	["weapon_ttt_c4"] = true,
	["weapon_ttt_cse"] = true,
	["weapon_ttt_decoy"] = true,
	["weapon_ttt_defuser"] = true,
	["weapon_ttt_flaregun"] = true,
	["weapon_ttt_health_station"] = true,
	["weapon_ttt_knife"] = true,
	["weapon_ttt_phammer"] = true,
	["weapon_ttt_push"] = true,
	["weapon_ttt_radio"] = true,
	["weapon_ttt_sipistol"] = true,
	["weapon_ttt_stungun"] = true,
	["weapon_ttt_teleport"] = true,
	["weapon_ttt_unarmed"] = true,
	["weapon_ttt_wtester"] = true,
	["weapon_zm_carry"] = true,
	["weapon_zm_improvised"] = true,

	["weapon_ttt_confgrenade"] = true,
	["weapon_ttt_glock"] = true,
	["weapon_ttt_m16"] = true,
	["weapon_ttt_smokegrenade"] = true,
	["weapon_zm_mac10"] = true,
	["weapon_zm_molotov"] = true,
	["weapon_zm_pistol"] = true,
	["weapon_zm_revolver"] = true,
	["weapon_zm_rifle"] = true,
	["weapon_zm_shotgun"] = true,
	["weapon_zm_sledge"] = true
}

-- Spawn rules

FallbackToRandom = false

Spawning = {
	[SPAWN_RANDOM] = {
		["weapon_ttt_confgrenade"] = 1,
		["weapon_ttt_glock"] = 1,
		["weapon_ttt_m16"] = 1,
		["weapon_ttt_smokegrenade"] = 1,
		["weapon_zm_mac10"] = 1,
		["weapon_zm_molotov"] = 1,
		["weapon_zm_pistol"] = 1,
		["weapon_zm_revolver"] = 1,
		["weapon_zm_rifle"] = 1,
		["weapon_zm_shotgun"] = 1,
		["weapon_zm_sledge"] = 1
	},
	[SPAWN_PISTOL] = {
		["weapon_ttt_glock"] = 1,
		["weapon_zm_pistol"] = 1
	},
	[SPAWN_DEAGLE] = "weapon_zm_revolver",
	[SPAWN_SHOTGUN] = "weapon_zm_shotgun",
	[SPAWN_SMG] = "weapon_zm_mac10",
	[SPAWN_GRENADE] = {
		["weapon_ttt_confgrenade"] = 1,
		["weapon_ttt_smokegrenade"] = 1,
		["weapon_zm_molotov"] = 1
	},
	[SPAWN_RIFLE] = "weapon_ttt_m16",
	[SPAWN_SNIPER] = "weapon_zm_rifle",
	[SPAWN_HUGE] = "weapon_zm_sledge"
}

Langs = {}
