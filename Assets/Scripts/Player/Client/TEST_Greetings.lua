--!Type(Client)
scene.PlayerJoined:Connect(function(scene, player)
    print("Welcome, " .. player.name .. "!")
end)