--!Type(UI)

local InventoryConsts = require("InventoryConstants")

type InventorySlot = {
    element : VisualElement
}

--!Bind
local _inventorySlot0 : VisualElement = nil
--!Bind
local _inventorySlot1 : VisualElement = nil
--!Bind
local _inventorySlot2 : VisualElement = nil
--!Bind
local _inventorySlot3 : VisualElement = nil
--!Bind
local _inventorySlot4 : VisualElement = nil
--!Bind
local _inventorySlot5 : VisualElement = nil
--!Bind
local _inventorySlot6 : VisualElement = nil
--!Bind
local _inventorySlot7 : VisualElement = nil
--!Bind
local _inventorySlot8 : VisualElement = nil
--!Bind
local _inventorySlot9 : VisualElement = nil

--!SerializeField
local tabState : number = 0

local slots : { InventorySlot } = {
    { element = _inventorySlot0 },
    { element = _inventorySlot1 },
    { element = _inventorySlot2 },
    { element = _inventorySlot3 },
    { element = _inventorySlot4 },
    { element = _inventorySlot5 },
    { element = _inventorySlot6 },
    { element = _inventorySlot7 },
    { element = _inventorySlot8 },
    { element = _inventorySlot9 },
}

function GetTabState() : number
    return tabState
end

local function OnSlotClick()
    print("CLICKED inventory slot TAB STATE: " .. tabState .. "")
end

function self:Awake()
    print(InventoryConsts.TABS.INGREDIENTS.TITLE)
    
    -- Register OnClick Handlers
    for _, item in pairs(slots) do
        local element = item.element
        element:RegisterPressCallback(OnSlotClick, true, true, true)
        
        -- Get first child
        local label = element:ElementAt(0)
        local newText = nil

        for i, tab in pairs(InventoryConsts.TABS) do
            if tabState == tab.STATE then
                newText = tab.TITLE
            end
        end

        label.text = newText
    end
end