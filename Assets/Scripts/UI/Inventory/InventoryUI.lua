--!Type(UI)

local PlayerTracker = require("GameManager")
local UIManager = require("UIManager")
local Utils = require("Utils")

------------ Inventory Tabs ------------
--!Bind
local _pageButtonIngredients : VisualElement = nil -- Important do not remove
--!Bind
local _pageButtonRecipes : VisualElement = nil -- Important do not remove
--!Bind
local _pageButtonEquipment : VisualElement = nil -- Important do not remove

--!Bind
local _closeButton : VisualElement = nil -- Close button for the inventory UI

--!SerializeField
local inventorySlots : { InventorySlots } = nil

tabButtons = {
    ingredients = { element = _pageButtonIngredients, state = 0, title = "Ingredients" },
    recipes = { element = _pageButtonRecipes, state = 1, title = "Recipes" },
    equipment = { element = _pageButtonEquipment, state = 2, title = "Equipment" },
}

local state : number = 0

local function UpdateSlots()
    for key, inventorySlotsObject in ipairs(inventorySlots) do
        if inventorySlotsObject.GetTabState() == state then
            inventorySlotsObject.gameObject:SetActive(true)
        else
            inventorySlotsObject.gameObject:SetActive(false)
        end
    end
end  

-- Function to make life easier xD
function ButtonPressed(btn: string) : boolean
    -- Fetch the player's inventory
    -- local playerInventory = PlayerTracker.GetPlayerInventory()
  
    if btn == "close" then
        print("X clicked")
        
        --ToggleVisible()
        UIManager.ButtonPressed("Close")
        return true
    end
  
    -- Check if the button exists in the tabButtons table
    local buttonInfo = tabButtons[btn]
    
    print("Tab clicked: " .. buttonInfo.title .. "")
    
    if buttonInfo then
        if state ~= buttonInfo.state then
            -- Update header title
            -- _headerTitle.text = buttonInfo.title
    
            -- Update state
            state = buttonInfo.state

            -- Show slots that match with current state
            UpdateSlots()
    
            -- Update classes for all tabButtons
            for key, info in pairs(tabButtons) do
                Utils.AddRemoveClass(info.element, "inventory__header__page--deselected", key ~= btn)
                Utils.AddRemoveClass(info.element, "inventory__header__page", key == btn)
            end
            
            print("Inventory state updated on tab click: " .. state .. "")

            -- Play sound and update inventory
            -- audioManager.PlaySound("paperSound1", 1)
            -- UpdateInventory(playerInventory)
        end

        return true
    end

    return false
end

------------ Lifecycle ------------

function self:Start()
    -- Initialize state
    UpdateSlots()
end

------------ OnClick Handlers ------------

-- Register a callback to close the inventory UI
_closeButton:RegisterPressCallback(function()
    --self.gameObject:SetActive(false)
    ButtonPressed("close")
end, true, true, true)

_pageButtonIngredients:RegisterPressCallback(function()
    ButtonPressed("ingredients")
end, true, true, true)

_pageButtonRecipes:RegisterPressCallback(function()
    ButtonPressed("recipes")
end, true, true, true)

_pageButtonEquipment:RegisterPressCallback(function()
    ButtonPressed("equipment")
end, true, true, true)