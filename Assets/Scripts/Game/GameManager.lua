--!Type(Module)
local SaveManager = require("SaveManager")

local function OnPlayerDataLoaded(
	playerData : SaveManager.PlayerData,
	callback: (() -> ()) | nil
)
	print("Coins: " .. playerData.Coins .. "")
	print("Mana: " .. playerData.Mana .. "")
	-- local newPlayerData = playerData;
	-- newPlayerData.Coins = 0;
	-- SaveManager.ClientSetPlayerData(newPlayerData);
	-- SaveManager.SavePlayerData()
end

function self:ClientAwake()
	SaveManager.LoadPlayerData(OnPlayerDataLoaded)
end
