OPCore = {}
OPCore.PlayerData = {}
OPCore.Config = OPConfig
OPCore.Shared = OPShared
OPCore.ClientCallbacks = {}
OPCore.ServerCallbacks = {}

exports('GetCoreObject', function()
    return OPCore
end)

-- To use this export in a script instead of manifest method
-- Just put this line of code below at the very top of the script
-- local OPCore = exports['qb-core']:GetCoreObject()
