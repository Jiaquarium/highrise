--!Type(Module)

local Utils = require("Utils")

-- Serialized fields for UI components
--!SerializeField
local InventoryObject : GameObject = nil

local uiMap = {
    Inventory = InventoryObject,
}

--- Toggles the visibility of a specific UI component
local function ToggleUI(ui: string, visible: boolean)
    local uiComponent = uiMap[ui]
    if not uiComponent then
        print("[ToggleUI] UI component not found: " .. ui)
        return
    end

    if visible then
        Utils.ActivateObject(uiComponent)
    else
        Utils.DeactivateObject(uiComponent)
    end
end

local function ToggleUIs(uiList, visible: boolean)
    for _, ui in ipairs(uiList) do
        ToggleUI(ui, visible)
    end
end

local function ToggleAll(visible: boolean, except)
    for ui, component in pairs(uiMap) do
        if not (except and except[ui]) then
            if visible then
                Utils.ActivateObject(component)
            else
                Utils.DeactivateObject(component)
            end
        end
    end
end

function ButtonPressed(btn: string)
    if btn == "Inventory" then
        ToggleAll(false)
        ToggleUI("Inventory", true)
        -- if not InventoryUIScript then
        --     InventoryUIScript = InventoryObject:GetComponent(inventory)
        -- end
        -- local playerInventory = PlayerTracker.GetPlayerInventory()
        -- InventoryUIScript.UpdateInventory(playerInventory)
        -- AudioManager.PlaySound("paperSound1", 1.1)
        
    elseif btn == "Close" then
        ToggleAll(false)
        -- ToggleUIs({"WorldHUD"}, true)
        -- AudioManager.PlaySound("paperSound1", 0.98)

        print("Clicked CLOSE INVENTORY")
     
    else
        print("[ButtonPressed] Unhandled button: " .. btn)
    end
end