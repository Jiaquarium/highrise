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

local buttons = {
    ingredients = { element = _pageButtonIngredients, state = 0, title = "Ingredients" },
    recipes = { element = _pageButtonRecipes, state = 1, title = "Recipes" },
    equipment = { element = _pageButtonEquipment, state = 2, title = "Equipment" },
}

local state : number = 0

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
  
    -- Check if the button exists in the buttons table
    local buttonInfo = buttons[btn]
    
    print("Tab clicked: " .. buttonInfo.title .. "")
    
    if buttonInfo then
        if state == buttonInfo.state then return true end -- Already in the selected state
  
        -- Update header title
        -- _headerTitle.text = buttonInfo.title
  
        -- Update state
        state = buttonInfo.state
  
        -- Update classes for all buttons
        for key, info in pairs(buttons) do
            Utils.AddRemoveClass(info.element, "inventory__header__page--deselected", key ~= btn)
            Utils.AddRemoveClass(info.element, "inventory__header__page", key == btn)
        end
        
        print("Inventory state updated on tab click: " .. state .. "")

        -- Play sound and update inventory
        -- audioManager.PlaySound("paperSound1", 1)
        -- UpdateInventory(playerInventory)
        return true
    end

    return false
  end

------------ Callbacks ------------

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