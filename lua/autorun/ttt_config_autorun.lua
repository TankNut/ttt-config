if engine.ActiveGamemode() != "terrortown" then
	return
end

-- TTT enums

WEAPON_UNARMED = -1
WEAPON_NONE   = 0
WEAPON_MELEE  = 1
WEAPON_PISTOL = 2
WEAPON_HEAVY  = 3
WEAPON_NADE   = 4
WEAPON_CARRY  = 5
WEAPON_EQUIP = 6
WEAPON_EQUIP1 = 6
WEAPON_EQUIP2 = 7
WEAPON_ROLE   = 8

ROLE_INNOCENT  = 0
ROLE_TRAITOR   = 1
ROLE_DETECTIVE = 2
ROLE_NONE = ROLE_INNOCENT

-- Our own enums

SPAWN_AMMO = 1
SPAWN_RANDOM = 2
SPAWN_PISTOL = 3
SPAWN_DEAGLE = 4
SPAWN_SHOTGUN = 5
SPAWN_SMG = 6
SPAWN_GRENADE = 7
SPAWN_RIFLE = 8
SPAWN_SNIPER = 9
SPAWN_HUGE = 10

SLOT_PISTOL = 1
SLOT_RIFLE = 2
SLOT_GRENADE = 3

module("ttt_config", package.seeall)

function log(...)
	if SERVER then
		print("[ttt-config]", ...)
	end
end

if file.Exists("ttt_config/config.lua", "LUA") then
	include("ttt_config/config.lua")
else
	include("ttt_config/config_fallback.lua")
end

local function updateAmmoSENT(data, class)
	local config = Config.Ammo[class]
	local ent = data.t or data

	if class == "base_ammo_ttt" then
		log("Patching base_ammo_ttt")

		ent.PlayerCanPickup = function(self, ply)
			if ply == self:GetOwner() then return false end

			local result = hook.Call("TTTCanPickupAmmo", nil, ply, self)

			if result then
			   return result
			end

			local phys = self:GetPhysicsObject()
			local spos = phys:IsValid() and phys:GetPos() or self:OBBCenter()
			local epos = ply:GetShootPos()

			local tr = util.TraceLine({
				start = spos,
				endpos = epos,
				filter = {ply, self},
				mask = MASK_SOLID,
				collisiongroup = COLLISION_GROUP_WORLD -- Allows us to pick up ammo through other weapons/ammo
			})

			return tr.Fraction == 1.0
		end
	elseif class == "ttt_random_weapon" then
		log("Patching ttt_random_weapon")

		ent.Initialize = function(self)
			if self:MapCreationID() == -1 then -- Dynamically created ones work as normal
				Spawner.Run({
					{SPAWN_RANDOM, self:GetPos(), self:GetAngles()}
				})

				self:Remove()
			end

			-- Don't need to remove here since it'll get picked up by one of the other systems
		end
	elseif class == "ttt_random_ammo" then
		log("Patching ttt_random_ammo")

		ent.Initialize = function(self)
			if self:MapCreationID() == -1 then -- Dynamically created ones work as normal
				Spawner.Run({
					{SPAWN_AMMO, self:GetPos(), self:GetAngles()}
				})

				self:Remove()
			end

			-- Don't need to remove here since it'll get picked up by one of the other systems
		end
	elseif config then
		log("Updating ammo info:", class)

		ent.AmmoType = config.Type
		ent.AmmoAmount = config.Amount
		ent.AmmoMax = config.Max
	end
end

hook.Add("PreRegisterSENT", "ttt_config", updateAmmoSENT)

for k, v in pairs(scripted_ents.GetList()) do
	updateAmmoSENT(v, k)
end

local kindToSlot = {
	[WEAPON_MELEE] = 0,
	[WEAPON_PISTOL] = 1,
	[WEAPON_HEAVY] = 2,
	[WEAPON_NADE] = 3,
	[WEAPON_CARRY] = 4,
	[WEAPON_UNARMED] = 5,
	[WEAPON_EQUIP1] = 6,
	[WEAPON_EQUIP2] = 7,
	[WEAPON_ROLE] = 8,
}

local function updateSWEP(data, class)
	local config = Config.Weapons[class]
	local ent = data.t or data

	if config then
		if config == true then
			log("Preserving weapon info:", class)

			return
		end

		ent.Kind = config.Kind
		ent.Slot = kindToSlot[config.Kind]

		ent.Primary.Ammo = config.Ammo or ent.Primary.Ammo
		ent.AmmoEnt = config.AmmoEnt

		ent.Primary.DefaultClip = config.DefaultClip or ent.Primary.ClipSize

		ent.Limited = tobool(config.Limited)

		ent.CanBuy = config.CanBuy
		ent.InLoadoutFor = config.Loadout

		if CLIENT and not ent.EquipMenuData then
			ent.EquipMenuData = {
				type = "item_weapon",
				desc = "No description set"
			}
		end

		log("Updated weapon info:", class)
	elseif ent.Kind then
		log("Disabled weapon:", class)

		ent.Kind = WEAPON_NONE

		ent.CanBuy = nil
		ent.InLoadoutFor = nil
	end
end

hook.Add("PreRegisterSWEP", "ttt_config", updateSWEP)

for _, v in pairs(weapons.GetList()) do
	updateSWEP(v, v.ClassName)
end

if CLIENT then
	local function lang()
		if not LANG then
			return
		end

		for k, v in pairs(Config.Langs) do
			LANG.AddToLanguage("english", k, v)
		end

		log("Updated lang info")
	end

	hook.Add("Initialize", "ttt_config", lang)

	lang()
else
	local tttEnts = {
		-- Entities
		["item_ammo_357_ttt"] = SPAWN_AMMO,
		["item_ammo_pistol_ttt"] = SPAWN_AMMO,
		["item_ammo_revolver_ttt"] = SPAWN_AMMO,
		["item_ammo_smg1_ttt"] = SPAWN_AMMO,
		["item_box_buckshot_ttt"] = SPAWN_AMMO,
		["ttt_random_ammo"] = SPAWN_AMMO,
		["ttt_random_weapon"] = SPAWN_RANDOM,

		-- Weapons
		["weapon_ttt_confgrenade"] = SPAWN_GRENADE,
		["weapon_ttt_glock"] = SPAWN_PISTOL,
		["weapon_ttt_m16"] = SPAWN_RIFLE,
		["weapon_ttt_smokegrenade"] = SPAWN_GRENADE,
		["weapon_zm_mac10"] = SPAWN_SMG,
		["weapon_zm_molotov"] = SPAWN_GRENADE,
		["weapon_zm_pistol"] = SPAWN_PISTOL,
		["weapon_zm_revolver"] = SPAWN_DEAGLE,
		["weapon_zm_rifle"] = SPAWN_SNIPER,
		["weapon_zm_shotgun"] = SPAWN_SHOTGUN,
		["weapon_zm_sledge"] = SPAWN_HUGE,
	}

	local replaceList = {
		-- Entities
		["item_ammo_pistol"] = SPAWN_AMMO,
		["item_box_buckshot"] = SPAWN_AMMO,
		["item_ammo_smg1"] = SPAWN_AMMO,
		["item_ammo_357"] = SPAWN_AMMO,
		["item_ammo_357_large"] = SPAWN_AMMO,
		["item_ammo_revolver"] = SPAWN_AMMO,
		["item_ammo_ar2"] = SPAWN_AMMO,
		["item_ammo_ar2_large"] = SPAWN_AMMO,
		["item_ammo_smg1_grenade"] = SPAWN_PISTOL,
		["item_battery"] = SPAWN_AMMO,
		["item_healthkit"] = SPAWN_SHOTGUN,
		["item_suitcharger"] = SPAWN_SMG,
		["item_ammo_ar2_altfire"] = SPAWN_SMG,
		["item_rpg_round"] = SPAWN_AMMO,
		["item_ammo_crossbow"] = SPAWN_AMMO,
		["item_healthvial"] = SPAWN_GRENADE,
		["item_healthcharger"] = SPAWN_AMMO,
		["item_ammo_crate"] = SPAWN_GRENADE,
		["item_item_crate"] = SPAWN_AMMO,

		-- Weapons
		["weapon_smg1"] = SPAWN_SMG,
		["weapon_shotgun"] = SPAWN_SHOTGUN,
		["weapon_ar2"] = SPAWN_RIFLE,
		["weapon_357"] = SPAWN_SNIPER,
		["weapon_crossbow"] = SPAWN_PISTOL,
		["weapon_rpg"] = SPAWN_HUGE,
		["weapon_slam"] = SPAWN_AMMO,
		["weapon_frag"] = SPAWN_DEAGLE,
		["weapon_crowbar"] = SPAWN_GRENADE,
		["weapon_zm_improvised"] = SPAWN_GRENADE
	}

	local extraSpawns = {
		["info_player_terrorist"] = true,
		["info_player_counterterrorist"] = true,
		["hostage_entity"] = true,
		["info_player_teamspawn"] = true,
		["team_control_point"] = true,
		["team_control_point_master"] = true,
		["team_control_point_round"] = true,
		["item_ammopack_full"] = true,
		["item_ammopack_medium"] = true,
		["item_ammopack_small"] = true,
		["item_healthkit_full"] = true,
		["item_healthkit_medium"] = true,
		["item_healthkit_small"] = true,
		["item_teamflag"] = true,
		["game_intro_viewpoint"] = true,
		["info_observer_point"] = true
	}

	function SpawnEntity(class, pos, ang, wake)
		local ent = ents.Create(class)

		ent:SetPos(pos)
		ent:SetAngles(ang)
		ent:Spawn()
		ent:Activate()

		ent:PhysWake()

		return ent
	end

	include("ttt_config/import_script.lua")
	include("ttt_config/spawner.lua")

	function PlaceExtraWeapons()
		log("Overriding auto-spawn method")

		ents.TTT.RemoveRagdolls(false)

		local found = false
		local entList = ents.GetAll()

		local cache = {}

		for _, v in pairs(entList) do
			if tttEnts[v:GetClass()] or replaceList[v:GetClass()] then
				log("Found eligible entities for replacement")

				found = true
				break
			end
		end

		if found then
			for _, v in pairs(entList) do
				local class = replaceList[v:GetClass()] or tttEnts[v:GetClass()]

				if class then
					if v:MapCreationID() != -1 then
						table.insert(cache, {class, v:GetPos(), v:GetAngles()})
					end

					v:Remove()
				end
			end
		else
			log("No replacable entities found, trying expanded CS:S/TF2 entity sets")

			for _, v in pairs(entList) do
				if extraSpawns[v:GetClass()] then
					table.insert(cache, {WEAPON_RANDOM, v.Pos, v.Ang})
				end
			end
		end

		log("Spawner finished with", Spawner.Run(cache), "entities spawned")
	end

	function RemoveEntities(spawns)
		if spawns then
			for _, v in pairs(GetSpawnEnts(false, true)) do
				v.BeingRemoved = true
				v:Remove()
			end
		end

		for _, v in pairs(ents.TTT.GetSpawnableAmmo()) do
			replaceList[v] = WEAPON_AMMO
		end

		for _, v in pairs(ents.TTT.GetSpawnableSWEPs()) do
			replaceList[v.ClassName] = tttEnts[v.ClassName] or WEAPON_RANDOM
		end

		for _, v in pairs(ents.GetAll()) do
			if replaceList[v:GetClass()] then
				v:Remove()
			end
		end

		ents.TTT.RemoveRagdolls(false)
	end

	function ProcessImportScript(map)
		log("Overriding rearm script")

		local settings, entities = ImportScript.Read(map)

		RemoveEntities(settings.replacespawns)

		local cache = {}

		for _, v in pairs(entities) do
			if tttEnts[v.Class] then
				table.insert(cache, {tttEnts[v.Class], v.Pos, v.Ang})
			else
				SpawnEntity(v.Class, v.Pos, v.Ang, true)
			end
		end

		log("Spawner finished with", Spawner.Run(cache), "entities spawned")
	end

	local function install()
		ents.TTT.ReplaceWeapons = function() end
		ents.TTT.PlaceExtraWeapons = PlaceExtraWeapons
		ents.TTT.ProcessImportScript = ProcessImportScript

		log("Patched in detour functions")
	end

	hook.Add("Initialize", "ttt_config", install)

	if ents.TTT then
		install()
	end
end
