CreateThread(function()
    while true do
        local sleep = 0
        if LocalPlayer.state.isLoggedIn then
            sleep = (1000 * 60) * OPCore.Config.UpdateInterval
            TriggerServerEvent('OPCore:UpdatePlayer')
        end
        Wait(sleep)
    end
end)

CreateThread(function()
    while true do
        if LocalPlayer.state.isLoggedIn then
            if (OPCore.PlayerData.metadata['hunger'] <= 0 or OPCore.PlayerData.metadata['thirst'] <= 0) and not (OPCore.PlayerData.metadata['isdead'] or OPCore.PlayerData.metadata['inlaststand']) then
                local ped = PlayerPedId()
                local currentHealth = GetEntityHealth(ped)
                local decreaseThreshold = math.random(5, 10)
                SetEntityHealth(ped, currentHealth - decreaseThreshold)
            end
        end
        Wait(OPCore.Config.StatusInterval)
    end
end)
