--!Type(Module)

-- Importing required modules
local Utils : Utils = require("Utils") -- Utility functions

-- Define the PlayerData type, which holds information about a player
export type PlayerData = {
	PlayerId: string, -- Unique identifier for the player
	Coins: number, -- Primary in-game currency
	Mana: number,
	RestartCount: number,
}

local PlayerDataKey = "playerData" -- Key used to store player data

-- Callback function to be called when player data is loaded
local _onLoadCallback: (playerData: PlayerData) -> () = nil

-- Table to hold player data for all players on the server
local _serverPlayerSaveList: { [string]: PlayerData } = {}

-- Client-side player data
local _clientPlayerData: PlayerData = nil

-- Events for data loading and saving
local LoadDataRequestEvent = Event.new("LoadDataRequestEvent")
local LoadDataResponseEvent = Event.new("LoadDataResponseEvent")
local SaveDataRequestEvent = Event.new("SaveDataRequestEvent")
local SaveDataResponseEvent = Event.new("SaveDataResponseEvent")
SaveDataLoadedEvent = Event.new("SaveDataLoadedEvent")

-- Baking Events
-- local CompleteBakingRequestEvent = Event.new("CompleteBakingRequestEvent")
-- local CompleteBakingResponseEvent = Event.new("CompleteBakingRequestEvent")

-------------------------------------------------------------------------------
-- Server Functions
-------------------------------------------------------------------------------

-- Function to create new player save data
function CreateNewPlayerSaveData(player: Player): PlayerData
	return {
		PlayerId = player.user.id, -- Set player ID
		Coins = 0, -- Initialize repeat count to zero
		Mana = 0,
        RestartCount = 0,
	}
end

-- Function to validate and initialize player data fields
local function Validate(playerData: PlayerData)
	if playerData.Coins == nil then
		playerData.Coins = 0
	end
	if playerData.Mana == nil then
		playerData.Mana = 0
	end
    if playerData.RestartCount == nil then
		playerData.RestartCount = 0
	end
end

-- Function to load player data from storage
local function ServerLoadPlayerData(player: Player)
	LoadDataForPlayer(player, PlayerDataKey, function(playerData)
		print("Data loaded for player " .. player.user.id)
		if not playerData then
			print("Creating new player data")
			playerData = CreateNewPlayerSaveData(player)
		end
		Validate(playerData)
		_serverPlayerSaveList[player.user.id] = playerData -- Store data in server list
		LoadDataResponseEvent:FireClient(player, playerData) -- Send data back to client
	end)
end

-- Function to handle save data requests from the client
function OnSaveDataRequest(player: Player, data: any)
	ServerSavePlayerData(player, data.playerData, nil, true) -- Save player data
end

-- Function to save player data to storage
function ServerSavePlayerData(
	player: Player,
	playerData: PlayerData,
	callback: (() -> ()) | nil,
	sendClientResponse: boolean
)
	Storage.SetPlayerValue(player, PlayerDataKey, playerData, function(err: StorageError)
		if err ~= StorageError.None then
			error("Failed to save player data: " .. tostring(err)) -- Log error if saving fails
		else
			_serverPlayerSaveList[player.user.id] = playerData -- Update server data list
		end
		if sendClientResponse then
			SaveDataResponseEvent:FireClient(player, playerData) -- Send response back to client
		end
		if callback then
			callback() -- Call the provided callback if it exists
		end
	end)
end

-- Function to load data for a specific player
function LoadDataForPlayer(player: Player, key: string, callback: (data: any) -> ())
	Storage.GetPlayerValue(player, key, function(data)
		callback(data) -- Call the provided callback with the loaded data
	end)
end

-- Function to save data for a specific player
function SaveDataForPlayer(player: Player, key: string, data: any)
	Storage.SetPlayerValue(player, key, data, function(err: StorageError)
		if err ~= StorageError.None then
			error("Failed to save player data: " .. tostring(err)) -- Log error if saving fails
		end
	end)
end

-- Function to delete data for a specific player
function DeleteDataForPlayer(player: Player, key: string)
	Storage.DeletePlayerValue(player, key, function(err: StorageError)
		if err ~= StorageError.None then
			error("Failed to delete player data: " .. tostring(err)) -- Log error if deletion fails
		end
	end)
end

-- Function to load global data
function LoadGlobalData(key: string, callback: (data: any) -> ())
	Storage.GetValue(key, function(data)
		callback(data) -- Call the provided callback with the loaded global data
	end)
end

-- Function to save global data
function SaveGlobalData(key: string, data: any)
	Storage.SetValue(key, data, function(err: StorageError)
		if err ~= StorageError.None then
			error("Failed to save global data: " .. tostring(err)) -- Log error if saving fails
		end
	end)
end

-- Function to update global data with a validator function
function UpdateGlobalData(key: string, validator: (data: any) -> any?, callback: (data: any) -> any)
	Storage.UpdateValue(key, function(data)
		return validator(data) -- Validate and return updated data
	end, callback) -- Call the provided callback with the updated data
end

-- Function to delete global data
function DeleteGlobalData(key: string)
	Storage.DeleteValue(key, function(err: StorageError)
		if err ~= StorageError.None then
			error("Failed to delete global data: " .. tostring(err)) -- Log error if deletion fails
		end
	end)
end

-- Function to get player data from the server list
function ServerGetPlayerData(id: string): PlayerData
	return _serverPlayerSaveList[id] -- Return the player data for the given ID
end

-- Function to handle requests to restart quests for a player
local function OnRequestRestartData(player: Player)
	local playerData = ServerGetPlayerData(player.user.id) -- Get player data
	if not playerData then
		print("Player data not found for player " .. player.user.id) -- Log if data not found
		return
	end

	playerData.RepeatCount = playerData.RepeatCount + 1 -- Increment repeat count

	ServerSavePlayerData(player, playerData, nil, false) -- Save updated player data
	-- RestartQuestsResponseEvent:FireClient(player, playerData) -- Send response back to client
end

-- Function to initialize server-side events
function self.ServerAwake()
	print("server awake")
    LoadDataRequestEvent:Connect(ServerLoadPlayerData) -- Connect load data request event
	SaveDataRequestEvent:Connect(OnSaveDataRequest) -- Connect save data request event
end

-------------------------------------------------------------------------------
-- Client Functions
-------------------------------------------------------------------------------

-- Function to get the current client player data
function GetClientPlayerData(): PlayerData
	return _clientPlayerData -- Return client player data
end

-- Function to check if player data is loaded
function IsPlayerDataLoaded(): boolean
	return _clientPlayerData ~= nil -- Return true if player data is loaded
end

-- Function to set the client player data
function ClientSetPlayerData(playerData: PlayerData)
	_clientPlayerData = playerData -- Set client player data
end

-- Function to load player data from the server
function LoadPlayerData(OnLoaded: (playerData: PlayerData) -> ())
	_onLoadCallback = OnLoaded -- Set the callback for when data is loaded
	LoadDataRequestEvent:FireServer() -- Request data from the server
end

-- Function to save player data to the server
function SavePlayerData()
	print("Saving data") -- Log saving data
	local data = {
		playerData = _clientPlayerData, -- Prepare data to send
	}

	SaveDataRequestEvent:FireServer(data) -- Send data to the server
end

-- Function to handle data loaded from the server
local function OnDataLoaded(playerData: PlayerData)
	_clientPlayerData = playerData -- Set the loaded player data
	if _onLoadCallback then
		_onLoadCallback(playerData) -- Call the load callback if it exists
	end
	SaveDataLoadedEvent:Fire() -- Fire the data loaded event
end

-- Function to clear player data and create new data
function ClearData()
	_clientPlayerData = CreateNewPlayerSaveData(client.localPlayer) -- Create new player data
	SavePlayerData() -- Save the new data
end

-- Function to initialize client-side events
function self.ClientAwake()
	LoadDataResponseEvent:Connect(OnDataLoaded) -- Connect load data response event

	SaveDataResponseEvent:Connect(function(playerData: PlayerData)
		_clientPlayerData = playerData -- Update client player data on save response
		print("Data saved") -- Log data saved
	end)
end