--!Type(UI)
local UIManager = require("UIManager")

--!Bind
local _InventoryButton : VisualElement = nil

_InventoryButton:RegisterPressCallback(function()
    UIManager.ButtonPressed("Inventory")
end, true, true, true)