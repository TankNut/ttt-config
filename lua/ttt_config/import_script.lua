module("ttt_config.ImportScript", package.seeall)

local log = ttt_config.log

local mapName = function(map) return "maps/" .. map .. "_ttt.txt" end
local classRemap = {
	ttt_playerspawn = "info_player_deathmatch"
}

function Read(map)
	local settings = {}
	local entities = {}

	local fileName = mapName(map)

	log("Reading rearm script:", fileName)

	for k, line in pairs(string.Explode("\n", file.Read(fileName, "GAME"))) do
		if line[1] == "#" then
			continue
		elseif string.match(line, "^setting") then
			local key, val = string.match(line, "^setting:\t(%w*) ([0-9]*)")

			if key and val then
				settings[key] = tonumber(val)
			end
		elseif line != "" and string.byte(line) != 0 then
			local class, pos, ang, kv = unpack(string.Explode("\t", line))

			if not pos or not ang then
				continue
			end

			if classRemap[class] then
				class = classRemap[class]
			end

			pos = Vector(pos)
			ang = Angle(ang)

			if kv then
				local key, val = unpack(string.Explode(" ", kv))

				if key and val then
					kv = {[key] = val}
				end
			end

			table.insert(entities, {
				Class = class,
				Pos = pos,
				Ang = ang,
				KeyValues = kv
			})
		end
	end

	log("Read", table.Count(settings), "setting(s) and ", #entities, "entities")

	return settings, entities
end
