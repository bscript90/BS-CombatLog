local TempData = {}
local function GetIDs(src)
    local discord = GetPlayerIdentifierByType(src,'discord')
    local steam = GetPlayerIdentifierByType(src,'steam')
    if not discord then discord = "NULL" end
    if not steam then steam = "NULL" end
    return {
        discord = discord,
        steam = steam,
    }
end

RegisterNetEvent('BS-CombatLog:server:getData',function()
    local src = source

    TempData[src] = {
        name = BSGetCharacterName(src),
        uid = BSGetCharId(src)
    }
end)

RegisterCommand('combatlogdebug',function(source, args)
    local src = tonumber(args[1]) or source
    local identifiers = GetIDs(src)
    local array = {}
    BSGetCharData(TempData[src].uid,function(data)
        array = {
            src = src,
            name = Settings.ShowICName and TempData[src].name or GetPlayerName(src),
            identifiers = identifiers,
            coords = vector3(data.coords.x,data.coords.y,data.coords.z),
            outfit = data.outfit,
            date = os.date("%H:%M:%S"),
            reason = args[2] or 'Exiting - 2'
        }
        TriggerClientEvent('BS-CombatLog:client:addData',-1,array)
        TempData[src] = nil -- not needed anymore
    end)
end)

AddEventHandler('playerDropped', function (reason, resourceName, clientDropReason)
    local src = source
    local identifiers = GetIDs(src)
    local array = {}
    BSGetCharData(TempData[src].uid,function(data)
        array = {
            src = src,
            name = Settings.ShowICName and TempData[src].name or GetPlayerName(src),
            identifiers = identifiers,
            coords = vector3(data.coords.x,data.coords.y,data.coords.z),
            outfit = data.outfit,
            date = os.date("%H:%M:%S"),
            reason = reason..' - '..clientDropReason
        }
        TriggerClientEvent('BS-CombatLog:client:addData',-1,array)
        TempData[src] = nil -- not needed anymore
    end)
end)