-- Add or change (a) method(s) in the OPCore.Functions table
local function SetMethod(methodName, handler)
    if type(methodName) ~= 'string' then
        return false, 'invalid_method_name'
    end

    OPCore.Functions[methodName] = handler

    TriggerEvent('OPCore:Server:UpdateObject')

    return true, 'success'
end

OPCore.Functions.SetMethod = SetMethod
exports('SetMethod', SetMethod)

-- Add or change (a) field(s) in the OPCore table
local function SetField(fieldName, data)
    if type(fieldName) ~= 'string' then
        return false, 'invalid_field_name'
    end

    OPCore[fieldName] = data

    TriggerEvent('OPCore:Server:UpdateObject')

    return true, 'success'
end

OPCore.Functions.SetField = SetField
exports('SetField', SetField)

-- Single add job function which should only be used if you planning on adding a single job
local function AddJob(jobName, job)
    if type(jobName) ~= 'string' then
        return false, 'invalid_job_name'
    end

    if OPCore.Shared.Jobs[jobName] then
        return false, 'job_exists'
    end

    OPCore.Shared.Jobs[jobName] = job

    TriggerClientEvent('OPCore:Client:OnSharedUpdate', -1, 'Jobs', jobName, job)
    TriggerEvent('OPCore:Server:UpdateObject')
    return true, 'success'
end

OPCore.Functions.AddJob = AddJob
exports('AddJob', AddJob)

-- Multiple Add Jobs
local function AddJobs(jobs)
    local shouldContinue = true
    local message = 'success'
    local errorItem = nil

    for key, value in pairs(jobs) do
        if type(key) ~= 'string' then
            message = 'invalid_job_name'
            shouldContinue = false
            errorItem = jobs[key]
            break
        end

        if OPCore.Shared.Jobs[key] then
            message = 'job_exists'
            shouldContinue = false
            errorItem = jobs[key]
            break
        end

        OPCore.Shared.Jobs[key] = value
    end

    if not shouldContinue then return false, message, errorItem end
    TriggerClientEvent('OPCore:Client:OnSharedUpdateMultiple', -1, 'Jobs', jobs)
    TriggerEvent('OPCore:Server:UpdateObject')
    return true, message, nil
end

OPCore.Functions.AddJobs = AddJobs
exports('AddJobs', AddJobs)

-- Single Remove Job
local function RemoveJob(jobName)
    if type(jobName) ~= 'string' then
        return false, 'invalid_job_name'
    end

    if not OPCore.Shared.Jobs[jobName] then
        return false, 'job_not_exists'
    end

    OPCore.Shared.Jobs[jobName] = nil

    TriggerClientEvent('OPCore:Client:OnSharedUpdate', -1, 'Jobs', jobName, nil)
    TriggerEvent('OPCore:Server:UpdateObject')
    return true, 'success'
end

OPCore.Functions.RemoveJob = RemoveJob
exports('RemoveJob', RemoveJob)

-- Single Update Job
local function UpdateJob(jobName, job)
    if type(jobName) ~= 'string' then
        return false, 'invalid_job_name'
    end

    if not OPCore.Shared.Jobs[jobName] then
        return false, 'job_not_exists'
    end

    OPCore.Shared.Jobs[jobName] = job

    TriggerClientEvent('OPCore:Client:OnSharedUpdate', -1, 'Jobs', jobName, job)
    TriggerEvent('OPCore:Server:UpdateObject')
    return true, 'success'
end

OPCore.Functions.UpdateJob = UpdateJob
exports('UpdateJob', UpdateJob)

-- Single add item
local function AddItem(itemName, item)
    if type(itemName) ~= 'string' then
        return false, 'invalid_item_name'
    end

    if OPCore.Shared.Items[itemName] then
        return false, 'item_exists'
    end

    OPCore.Shared.Items[itemName] = item

    TriggerClientEvent('OPCore:Client:OnSharedUpdate', -1, 'Items', itemName, item)
    TriggerEvent('OPCore:Server:UpdateObject')
    return true, 'success'
end

OPCore.Functions.AddItem = AddItem
exports('AddItem', AddItem)

-- Single update item
local function UpdateItem(itemName, item)
    if type(itemName) ~= 'string' then
        return false, 'invalid_item_name'
    end
    if not OPCore.Shared.Items[itemName] then
        return false, 'item_not_exists'
    end
    OPCore.Shared.Items[itemName] = item
    TriggerClientEvent('OPCore:Client:OnSharedUpdate', -1, 'Items', itemName, item)
    TriggerEvent('OPCore:Server:UpdateObject')
    return true, 'success'
end

OPCore.Functions.UpdateItem = UpdateItem
exports('UpdateItem', UpdateItem)

-- Multiple Add Items
local function AddItems(items)
    local shouldContinue = true
    local message = 'success'
    local errorItem = nil

    for key, value in pairs(items) do
        if type(key) ~= 'string' then
            message = 'invalid_item_name'
            shouldContinue = false
            errorItem = items[key]
            break
        end

        if OPCore.Shared.Items[key] then
            message = 'item_exists'
            shouldContinue = false
            errorItem = items[key]
            break
        end

        OPCore.Shared.Items[key] = value
    end

    if not shouldContinue then return false, message, errorItem end
    TriggerClientEvent('OPCore:Client:OnSharedUpdateMultiple', -1, 'Items', items)
    TriggerEvent('OPCore:Server:UpdateObject')
    return true, message, nil
end

OPCore.Functions.AddItems = AddItems
exports('AddItems', AddItems)

-- Single Remove Item
local function RemoveItem(itemName)
    if type(itemName) ~= 'string' then
        return false, 'invalid_item_name'
    end

    if not OPCore.Shared.Items[itemName] then
        return false, 'item_not_exists'
    end

    OPCore.Shared.Items[itemName] = nil

    TriggerClientEvent('OPCore:Client:OnSharedUpdate', -1, 'Items', itemName, nil)
    TriggerEvent('OPCore:Server:UpdateObject')
    return true, 'success'
end

OPCore.Functions.RemoveItem = RemoveItem
exports('RemoveItem', RemoveItem)

-- Single Add Gang
local function AddGang(gangName, gang)
    if type(gangName) ~= 'string' then
        return false, 'invalid_gang_name'
    end

    if OPCore.Shared.Gangs[gangName] then
        return false, 'gang_exists'
    end

    OPCore.Shared.Gangs[gangName] = gang

    TriggerClientEvent('OPCore:Client:OnSharedUpdate', -1, 'Gangs', gangName, gang)
    TriggerEvent('OPCore:Server:UpdateObject')
    return true, 'success'
end

OPCore.Functions.AddGang = AddGang
exports('AddGang', AddGang)

-- Multiple Add Gangs
local function AddGangs(gangs)
    local shouldContinue = true
    local message = 'success'
    local errorItem = nil

    for key, value in pairs(gangs) do
        if type(key) ~= 'string' then
            message = 'invalid_gang_name'
            shouldContinue = false
            errorItem = gangs[key]
            break
        end

        if OPCore.Shared.Gangs[key] then
            message = 'gang_exists'
            shouldContinue = false
            errorItem = gangs[key]
            break
        end

        OPCore.Shared.Gangs[key] = value
    end

    if not shouldContinue then return false, message, errorItem end
    TriggerClientEvent('OPCore:Client:OnSharedUpdateMultiple', -1, 'Gangs', gangs)
    TriggerEvent('OPCore:Server:UpdateObject')
    return true, message, nil
end

OPCore.Functions.AddGangs = AddGangs
exports('AddGangs', AddGangs)

-- Single Remove Gang
local function RemoveGang(gangName)
    if type(gangName) ~= 'string' then
        return false, 'invalid_gang_name'
    end

    if not OPCore.Shared.Gangs[gangName] then
        return false, 'gang_not_exists'
    end

    OPCore.Shared.Gangs[gangName] = nil

    TriggerClientEvent('OPCore:Client:OnSharedUpdate', -1, 'Gangs', gangName, nil)
    TriggerEvent('OPCore:Server:UpdateObject')
    return true, 'success'
end

OPCore.Functions.RemoveGang = RemoveGang
exports('RemoveGang', RemoveGang)

-- Single Update Gang
local function UpdateGang(gangName, gang)
    if type(gangName) ~= 'string' then
        return false, 'invalid_gang_name'
    end

    if not OPCore.Shared.Gangs[gangName] then
        return false, 'gang_not_exists'
    end

    OPCore.Shared.Gangs[gangName] = gang

    TriggerClientEvent('OPCore:Client:OnSharedUpdate', -1, 'Gangs', gangName, gang)
    TriggerEvent('OPCore:Server:UpdateObject')
    return true, 'success'
end

OPCore.Functions.UpdateGang = UpdateGang
exports('UpdateGang', UpdateGang)

local resourceName = GetCurrentResourceName()
local function GetCoreVersion(InvokingResource)
    local resourceVersion = GetResourceMetadata(resourceName, 'version')
    if InvokingResource and InvokingResource ~= '' then
        print(('%s called qbcore version check: %s'):format(InvokingResource or 'Unknown Resource', resourceVersion))
    end
    return resourceVersion
end

OPCore.Functions.GetCoreVersion = GetCoreVersion
exports('GetCoreVersion', GetCoreVersion)

local function ExploitBan(playerId, origin)
    local name = GetPlayerName(playerId)
    MySQL.insert('INSERT INTO bans (name, license, discord, ip, reason, expire, bannedby) VALUES (?, ?, ?, ?, ?, ?, ?)', {
        name,
        OPCore.Functions.GetIdentifier(playerId, 'license'),
        OPCore.Functions.GetIdentifier(playerId, 'discord'),
        OPCore.Functions.GetIdentifier(playerId, 'ip'),
        origin,
        2147483647,
        'Anti Cheat'
    })
    DropPlayer(playerId, Lang:t('info.exploit_banned', { discord = OPCore.Config.Server.Discord }))
    TriggerEvent('qb-log:server:CreateLog', 'anticheat', 'Anti-Cheat', 'red', name .. ' has been banned for exploiting ' .. origin, true)
end

exports('ExploitBan', ExploitBan)
