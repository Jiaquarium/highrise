--!Type(Module)

export type PlayerStats = {
	playerCoins: number, -- Primary in-game currency
}

local clientJoinRequets = Event.new("ClientJoinRequest")
local playerDataLoadedEvent = Event.new("PlayerDataLoadedEvent")

players = {}

------------ Player Tracking ------------
function TrackPlayers(game, characterCallback)
	scene.PlayerJoined:Connect(function(scene, player)
		players[player] = {
			player = player,
			playerCoins = IntValue.new("PlayerCoins" .. tostring(player.id), 0, player),
		}

		print("Tracked player: " .. player.name .. "");
		print("Tracked player with initial value coins: " .. players[player].playerCoins.value .. "");

		player.CharacterChanged:Connect(function(player, character) 
            local playerinfo = players[player]
            if (character == nil) then
                return
            end

            if characterCallback then
                characterCallback(playerinfo)
            end
        end)
	end)

	game.PlayerDisconnected:Connect(function(player)
        players[player] = nil
    end)
end

------------ Client ------------
function self:ClientAwake()
	clientJoinRequets:FireServer()
	
	TrackPlayers(client, nil)
end

------------ Server ------------
function self:ServerAwake()
    TrackPlayers(server)

    clientJoinRequets:Connect(function(player)
        GetPlayerStatsFromStorage(player)

		print("Got coins from Storage API: " .. players[player].playerCoins.value .. "")
    end)
end

------------ Utils ------------
function GetPlayerStatsFromStorage(player)
    if players[player] == nil then
        print("Error: Player not found.")
        return
    end

    Storage.GetPlayerValue(player, "PlayerStats", function(playerStats: PlayerStats | nil)
        if playerStats == nil then
            -- Default values if no data found
            print("No player stats found for " .. player.name .. ". Defaulting to new game.")
            playerStats = {
                playerCoins = 0
            }
        end

        -- Ensure all stats exist and default to valid values
		-- (must null-check again to avoid type error)
		if playerStats ~= nil then
        	players[player].playerCoins.value = playerStats.playerCoins or 0
		end

        -- Print the player's stats
        print(player.name .. "'s stats: ")
        print("Player coins: " .. tostring(players[player].playerCoins.value))

    end) 
end

function StorePlayerStats(player)
    if players[player] == nil then
        print("Error: Player not found.")
        return
    end

    local playerInfo = players[player]
    local playerStats = {
        playerCoins = playerInfo.playerCoins.value,
    }

    Storage.SetPlayerValue(player, "PlayerStats", playerStats, function(err)
        if err ~= StorageError.None then print("Error: " .. err) end
    end)

	print("Set server coins to current network coins: " .. playerStats.playerCoins .. "")
end