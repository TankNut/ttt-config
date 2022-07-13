AddCSLuaFile()

module("ttt_config.Config", package.seeall)

-- Ammo defines

Ammo = {
	["item_ammo_pistol_ttt"] = {Name = "Pistol ammo", Type = "Pistol", Amount = 20, Max = 60},
	["item_ammo_revolver_ttt"] = {Name = "357 ammo", Type = "AlyxGun", Amount = 6, Max = 24},
	["item_ammo_smg1_ttt"] = {Name = "SMG ammo", Type = "SMG1", Amount = 30, Max = 90},
	["item_ammo_ar2_ttt"] = {Name = "Pulse ammo", Type = "AR2", Amount = 30, Max = 90},
	["item_box_buckshot_ttt"] = {Name = "Buckshot shells", Type = "Buckshot", Amount = 8, Max = 24},
	["item_ammo_357_ttt"] = {Name = "Sniper ammo", Type = "357", Amount = 6, Max = 24},
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
	["weapon_ttt_smokegrenade"] = true,
	["weapon_zm_molotov"] = true,

	["simple_hl2_pistol"] = {Kind = WEAPON_PISTOL, Ammo = "Pistol", AmmoEnt = "item_ammo_pistol_ttt"},
	["simple_hl2_357"] = {Kind = WEAPON_PISTOL, Ammo = "AlyxGun", AmmoEnt = "item_ammo_revolver_ttt"},
	["simple_hl2_smg1"] = {Kind = WEAPON_HEAVY, Ammo = "SMG1", AmmoEnt = "item_ammo_smg1_ttt"},
	["simple_hl2_ar2"] = {Kind = WEAPON_HEAVY, Ammo = "AR2", AmmoEnt = "item_ammo_ar2_ttt"},
	["simple_hl2_shotgun"] = {Kind = WEAPON_HEAVY, Ammo = "Buckshot", AmmoEnt = "item_box_buckshot_ttt"},
	["simple_hl2_crossbow"] = {Kind = WEAPON_HEAVY, Ammo = "XBowBolt"},
	["simple_css_awp"] = {Kind = WEAPON_HEAVY, Ammo = "357", AmmoEnt = "item_ammo_357_ttt"},
}

-- Spawn rules

FallbackToRandom = true

Spawning = {
	[SPAWN_RANDOM] = {
		["simple_hl2_pistol"] = 1,
		["simple_hl2_357"] = 1,
		["simple_hl2_smg1"] = 1,
		["simple_hl2_ar2"] = 1,
		["simple_hl2_shotgun"] = 1,
		["weapon_ttt_confgrenade"] = 1,
		["weapon_ttt_smokegrenade"] = 1,
		["weapon_zm_molotov"] = 1
	},
	[SPAWN_PISTOL] = "simple_hl2_pistol",
	[SPAWN_DEAGLE] = "simple_hl2_357",
	[SPAWN_SHOTGUN] = "simple_hl2_shotgun",
	[SPAWN_SMG] = "simple_hl2_smg1",
	[SPAWN_GRENADE] = {
		["weapon_ttt_confgrenade"] = 1,
		["weapon_ttt_smokegrenade"] = 1,
		["weapon_zm_molotov"] = 1
	},
	[SPAWN_RIFLE] = "simple_hl2_ar2",
	[SPAWN_SNIPER] = "simple_css_awp",
	[SPAWN_HUGE] = "simple_hl2_crossbow"
}
