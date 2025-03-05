--!Type(UI)

PlayerTracker = require("GameManager")
local UIManager = require("UIManager")

--!Bind
local _closeButton : VisualElement = nil -- Close button for the inventory UI

-- Function to make life easier xD
function ButtonPressed(btn: string)
    -- Fetch the player's inventory
    -- local playerInventory = PlayerTracker.GetPlayerInventory()
  
    if btn == "close" then
        print("X clicked")
        
        --ToggleVisible()
        UIManager.ButtonPressed("Close")
        return true
    end
  
    --[[
    -- Check if the button exists in the buttons table
    local buttonInfo = buttons[btn]
    if buttonInfo then
        if state == buttonInfo.state then return end -- Already in the selected state
  
        -- Update header title
        _headerTitle.text = buttonInfo.title
  
        -- Update state
        state = buttonInfo.state
  
        -- Update classes for all buttons
        for key, info in pairs(buttons) do
            Utils.AddRemoveClass(info.element, "inventory__header__page--deselected", key ~= btn)
            Utils.AddRemoveClass(info.element, "inventory__header__page", key == btn)
        end
  
        -- Play sound and update inventory
        -- audioManager.PlaySound("paperSound1", 1)
        -- UpdateInventory(playerInventory)
        return true
    end
    ]]
  end

------------ Callbacks ------------

-- Register a callback to close the inventory UI
_closeButton:RegisterPressCallback(function()
    --self.gameObject:SetActive(false)
    ButtonPressed("close")
end, true, true, true)