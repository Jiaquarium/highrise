--!Type(UI)
local GameManager = require("GameManager")
local UIManager = require("UIManager")

--!Bind
local _coins_count : UILabel = nil
--!Bind
local _mana_count : UILabel = nil
--!Bind
local _InventoryButton : VisualElement = nil

_InventoryButton:RegisterPressCallback(function()
    UIManager.ButtonPressed("Inventory")
end, true, true, true)

function self:Start()
    GameManager.players[client.localPlayer].playerCoins.Changed:Connect(function(coins)
        local coinsCount = GameManager.players[client.localPlayer].playerCoins.value
        _coins_count:SetPrelocalizedText(tostring(coinsCount));
    end)
    GameManager.players[client.localPlayer].playerMana.Changed:Connect(function(coins)
        local manaCount = GameManager.players[client.localPlayer].playerMana.value
        _mana_count:SetPrelocalizedText(tostring(manaCount));
    end)
end