--!Type(Module)

-- Activate the object if it is not active
function ActivateObject(object)
    if not object.activeSelf then
        object:SetActive(true)
    end
end

-- Deactivate the object if it is active
function DeactivateObject(object)
    if object.activeSelf then
        object:SetActive(false)
    end
end

-- Function to add or remove a class from an element
function AddRemoveClass(element, class: string, add: boolean)
    if add then
        element:AddToClassList(class)
    else
        element:RemoveFromClassList(class)
    end
end