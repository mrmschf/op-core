-- Event Handler

AddEventHandler('chatMessage', function(_, _, message)
    if string.sub(message, 1, 1) == '/' then
        CancelEvent()
        return
    end
end)

AddEventHandler('playerDropped', function(reason)
    local src = source
    if not OPCore.Players[src] then return end
    local Player = OPCore.Players[src]
    TriggerEvent('qb-log:server:CreateLog', 'joinleave', 'Dropped', 'red', '**' .. GetPlayerName(src) .. '** (' .. Player.PlayerData.license .. ') left..' .. '\n **Reason:** ' .. reason)
    Player.Functions.Save()
    OPCore.Player_Buckets[Player.PlayerData.license] = nil
    OPCore.Players[src] = nil
end)

-- Player Connecting

local function onPlayerConnecting(name, _, deferrals)
    local src = source
    deferrals.defer()

    if OPCore.Config.Server.Closed and not IsPlayerAceAllowed(src, 'qbadmin.join') then
        return deferrals.done(OPCore.Config.Server.ClosedReason)
    end

    if OPCore.Config.Server.Whitelist then
        Wait(0)
        deferrals.update(string.format(Lang:t('info.checking_whitelisted'), name))
        if not OPCore.Functions.IsWhitelisted(src) then
            return deferrals.done(Lang:t('error.not_whitelisted'))
        end
    end

    Wait(0)
    deferrals.update(string.format('Hello %s. Your license is being checked', name))
    local license = OPCore.Functions.GetIdentifier(src, 'license')

    if not license then
        return deferrals.done(Lang:t('error.no_valid_license'))
    elseif OPCore.Config.Server.CheckDuplicateLicense and OPCore.Functions.IsLicenseInUse(license) then
        return deferrals.done(Lang:t('error.duplicate_license'))
    end

    Wait(0)
    deferrals.update(string.format(Lang:t('info.checking_ban'), name))

    local success, isBanned, reason = pcall(OPCore.Functions.IsPlayerBanned, src)
    if not success then return deferrals.done(Lang:t('error.connecting_database_error')) end
    if isBanned then return deferrals.done(reason) end

    Wait(0)
    deferrals.update(string.format(Lang:t('info.join_server'), name))
    deferrals.done()

    TriggerClientEvent('OPCore:Client:SharedUpdate', src, OPCore.Shared)
end

AddEventHandler('playerConnecting', onPlayerConnecting)

-- Open & Close Server (prevents players from joining)

RegisterNetEvent('OPCore:Server:CloseServer', function(reason)
    local src = source
    if OPCore.Functions.HasPermission(src, 'admin') then
        reason = reason or 'No reason specified'
        OPCore.Config.Server.Closed = true
        OPCore.Config.Server.ClosedReason = reason
        for k in pairs(OPCore.Players) do
            if not OPCore.Functions.HasPermission(k, OPCore.Config.Server.WhitelistPermission) then
                OPCore.Functions.Kick(k, reason, nil, nil)
            end
        end
    else
        OPCore.Functions.Kick(src, Lang:t('error.no_permission'), nil, nil)
    end
end)

RegisterNetEvent('OPCore:Server:OpenServer', function()
    local src = source
    if OPCore.Functions.HasPermission(src, 'admin') then
        OPCore.Config.Server.Closed = false
    else
        OPCore.Functions.Kick(src, Lang:t('error.no_permission'), nil, nil)
    end
end)

-- Callback Events --

-- Client Callback
RegisterNetEvent('OPCore:Server:TriggerClientCallback', function(name, ...)
    if OPCore.ClientCallbacks[name] then
        OPCore.ClientCallbacks[name](...)
        OPCore.ClientCallbacks[name] = nil
    end
end)

-- Server Callback
RegisterNetEvent('OPCore:Server:TriggerCallback', function(name, ...)
    local src = source
    OPCore.Functions.TriggerCallback(name, src, function(...)
        TriggerClientEvent('OPCore:Client:TriggerCallback', src, name, ...)
    end, ...)
end)

-- Player

RegisterNetEvent('OPCore:UpdatePlayer', function()
    local src = source
    local Player = OPCore.Functions.GetPlayer(src)
    if not Player then return end
    local newHunger = Player.PlayerData.metadata['hunger'] - OPCore.Config.Player.HungerRate
    local newThirst = Player.PlayerData.metadata['thirst'] - OPCore.Config.Player.ThirstRate
    if newHunger <= 0 then
        newHunger = 0
    end
    if newThirst <= 0 then
        newThirst = 0
    end
    Player.Functions.SetMetaData('thirst', newThirst)
    Player.Functions.SetMetaData('hunger', newHunger)
    TriggerClientEvent('hud:client:UpdateNeeds', src, newHunger, newThirst)
    Player.Functions.Save()
end)

RegisterNetEvent('OPCore:ToggleDuty', function()
    local src = source
    local Player = OPCore.Functions.GetPlayer(src)
    if not Player then return end
    if Player.PlayerData.job.onduty then
        Player.Functions.SetJobDuty(false)
        TriggerClientEvent('OPCore:Notify', src, Lang:t('info.off_duty'))
    else
        Player.Functions.SetJobDuty(true)
        TriggerClientEvent('OPCore:Notify', src, Lang:t('info.on_duty'))
    end

    TriggerEvent('OPCore:Server:SetDuty', src, Player.PlayerData.job.onduty)
    TriggerClientEvent('OPCore:Client:SetDuty', src, Player.PlayerData.job.onduty)
end)

-- BaseEvents

-- Vehicles
RegisterServerEvent('baseevents:enteringVehicle', function(veh, seat, modelName)
    local src = source
    local data = {
        vehicle = veh,
        seat = seat,
        name = modelName,
        event = 'Entering'
    }
    TriggerClientEvent('OPCore:Client:VehicleInfo', src, data)
end)

RegisterServerEvent('baseevents:enteredVehicle', function(veh, seat, modelName)
    local src = source
    local data = {
        vehicle = veh,
        seat = seat,
        name = modelName,
        event = 'Entered'
    }
    TriggerClientEvent('OPCore:Client:VehicleInfo', src, data)
end)

RegisterServerEvent('baseevents:enteringAborted', function()
    local src = source
    TriggerClientEvent('OPCore:Client:AbortVehicleEntering', src)
end)

RegisterServerEvent('baseevents:leftVehicle', function(veh, seat, modelName)
    local src = source
    local data = {
        vehicle = veh,
        seat = seat,
        name = modelName,
        event = 'Left'
    }
    TriggerClientEvent('OPCore:Client:VehicleInfo', src, data)
end)

-- Items

-- This event is exploitable and should not be used. It has been deprecated, and will be removed soon.
RegisterNetEvent('OPCore:Server:UseItem', function(item)
    print(string.format('%s triggered OPCore:Server:UseItem by ID %s with the following data. This event is deprecated due to exploitation, and will be removed soon. Check qb-inventory for the right use on this event.', GetInvokingResource(), source))
    OPCore.Debug(item)
end)

-- This event is exploitable and should not be used. It has been deprecated, and will be removed soon. function(itemName, amount, slot)
RegisterNetEvent('OPCore:Server:RemoveItem', function(itemName, amount)
    local src = source
    print(string.format('%s triggered OPCore:Server:RemoveItem by ID %s for %s %s. This event is deprecated due to exploitation, and will be removed soon. Adjust your events accordingly to do this server side with player functions.', GetInvokingResource(), src, amount, itemName))
end)

-- This event is exploitable and should not be used. It has been deprecated, and will be removed soon. function(itemName, amount, slot, info)
RegisterNetEvent('OPCore:Server:AddItem', function(itemName, amount)
    local src = source
    print(string.format('%s triggered OPCore:Server:AddItem by ID %s for %s %s. This event is deprecated due to exploitation, and will be removed soon. Adjust your events accordingly to do this server side with player functions.', GetInvokingResource(), src, amount, itemName))
end)

-- Non-Chat Command Calling (ex: qb-adminmenu)

RegisterNetEvent('OPCore:CallCommand', function(command, args)
    local src = source
    if not OPCore.Commands.List[command] then return end
    local Player = OPCore.Functions.GetPlayer(src)
    if not Player then return end
    local hasPerm = OPCore.Functions.HasPermission(src, 'command.' .. OPCore.Commands.List[command].name)
    if hasPerm then
        if OPCore.Commands.List[command].argsrequired and #OPCore.Commands.List[command].arguments ~= 0 and not args[#OPCore.Commands.List[command].arguments] then
            TriggerClientEvent('OPCore:Notify', src, Lang:t('error.missing_args2'), 'error')
        else
            OPCore.Commands.List[command].callback(src, args)
        end
    else
        TriggerClientEvent('OPCore:Notify', src, Lang:t('error.no_access'), 'error')
    end
end)

-- Use this for player vehicle spawning
-- Vehicle server-side spawning callback (netId)
-- use the netid on the client with the NetworkGetEntityFromNetworkId native
-- convert it to a vehicle via the NetToVeh native
OPCore.Functions.CreateCallback('OPCore:Server:SpawnVehicle', function(source, cb, model, coords, warp)
    local veh = OPCore.Functions.SpawnVehicle(source, model, coords, warp)
    cb(NetworkGetNetworkIdFromEntity(veh))
end)

-- Use this for long distance vehicle spawning
-- vehicle server-side spawning callback (netId)
-- use the netid on the client with the NetworkGetEntityFromNetworkId native
-- convert it to a vehicle via the NetToVeh native
OPCore.Functions.CreateCallback('OPCore:Server:CreateVehicle', function(source, cb, model, coords, warp)
    local veh = OPCore.Functions.CreateAutomobile(source, model, coords, warp)
    cb(NetworkGetNetworkIdFromEntity(veh))
end)

--OPCore.Functions.CreateCallback('OPCore:HasItem', function(source, cb, items, amount)
-- https://github.com/qbcore-framework/qb-inventory/blob/e4ef156d93dd1727234d388c3f25110c350b3bcf/server/main.lua#L2066
--end)
