--!Type(UI)
local GameManager = require("GameManager")

--!Bind
local _coins_count : UILabel = nil
--!Bind
local _Button : UIButton = nil

local counter = 0 -- Initialize the counter

function self:Start()
    GameManager.players[client.localPlayer].playerCoins.Changed:Connect(function(coins)
        local coinsCount = GameManager.players[client.localPlayer].playerCoins.value
        _coins_count:SetPrelocalizedText(tostring(coinsCount));
    end)
end