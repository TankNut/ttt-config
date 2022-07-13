module("ttt_config.Spawner", package.seeall)

local function weightedRandom(tab)
	local sum = 0

	for _, chance in pairs(tab) do
		sum = sum + chance
	end

	local winner = math.random() * sum

	for key, chance in pairs(tab) do
		winner = winner - chance

		if winner < 0 then
			return key
		end
	end
end

local spawnEntity = ttt_config.SpawnEntity
local config = ttt_config.Config

function SpawnWeapon(class, pos, ang)
	local ent = spawnEntity(class, pos, ang)

	if ent.AmmoEnt then
		local offset = VectorRand(-10, 10)

		offset.z = 0

		local trace = util.TraceLine({
			start = pos,
			endpos = pos + offset,
			filter = ent,
			collisiongroup = COLLISION_GROUP_WORLD,
			mask = MASK_SOLID
		})

		local ammo = spawnEntity(ent.AmmoEnt, trace.HitPos - trace.HitNormal, Angle(0, math.Rand(-180, 180), 0))

		ammo:SetOwner(ent)

		local configEntry = config.Ammo[ent.AmmoEnt]

		if configEntry then
			local amount = configEntry.Amount

			if istable(amount) then
				ammo.AmmoAmount = math.random(amount[1], amount[2])
			else
				ammo.AmmoAmount = amount
			end
		end
	end
end

function Run(data)
	local count = 0

	for _, v in pairs(data) do
		local spawnType, pos, ang = v[1], v[2], v[3]

		if spawnType == SPAWN_AMMO then
			continue
		end

		local options = config.Spawning[spawnType]

		if not options then
			if config.FallbackToRandom then
				options = config.Spawning[SPAWN_RANDOM]
			else
				continue
			end
		end

		local winner = istable(options) and weightedRandom(options) or options

		SpawnWeapon(winner, pos, ang)

		count = count + 1
	end

	return count
end
