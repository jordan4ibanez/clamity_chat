local S = minetest.get_translator("mcl_commands")

minetest.register_chatcommand("kill", {
	description = "Kill yourself to respawn",
	func = function(name)
		local player = minetest.get_player_by_name(name)
		if player then
			if minetest.settings:get_bool("enable_damage") then
				--mcl_death_messages.player_damage(player, S("@1 committed suicide.", name))
				if player and player:is_player() and player:get_player_name() then
					minetest.chat_send_all(player:get_player_name() .. " committed suicide.")
				end
				player:set_hp(0)
				return true
			else
				for _, callback in pairs(minetest.registered_on_respawnplayers) do
					if callback(player) then
						return true
					end
				end

				-- There doesn't seem to be a way to get a default spawn pos
				-- from the lua API
				return false, "No static_spawnpoint defined"
			end
		else
			-- Show error message if used when not logged in, eg: from IRC mod
			return false, "You need to be online to be killed!"
		end
	end
})

function minetest.send_join_message(player_name)
	if not minetest.is_singleplayer() then
		minetest.chat_send_all(minetest.colorize("#d3d34f", " " .. player_name .. " Joined"))
	end
end

function minetest.send_leave_message(player_name, timed_out)
	if not minetest.is_singleplayer() then
		minetest.chat_send_all(minetest.colorize("#d3d34f", " " .. player_name .. " Left"))
	end
end

minetest.register_chatcommand("me", {
	params = "<action>",
	description = "Show chat action (e.g., '/me orders a pizza' displays '<player name> orders a pizza')",
	privs = {shout = true},
	func = function(name, param)
		if param:find("<") or param:find(">") then
			param = minetest.strip_colors(param)
		end
		minetest.chat_send_all(" " .. minetest.colorize("#B0B0B0", name .. " " .. param))
		return true
	end,
})

minetest.register_chatcommand("greentext", {
	params = "<action>",
	description = "Sends a message in greentext",
	privs = {shout = true},
	func = function(name, param)
		minetest.chat_send_all(minetest.colorize("#789922", " <" .. name .. ">: >" .. param))
		return true
	end,
})
