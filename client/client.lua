-- p_menusign01x
RegisterNetEvent('BS-CombatLog:client:addData',function(data)
    local array = data
    local minute = 1000 * 60 * Settings.DeletionPeriod
    local endTime = GetGameTimer() + minute
    Citizen.CreateThread(function()
        SendNUIMessage({
            action = "add",
            array = array,
        })
       
        while endTime >= GetGameTimer() do
            local sleep = 500
            local dist = #(GetEntityCoords(PlayerPedId()) - array.coords)

            if dist < 5 and (array.PED or not Settings.ShowPed) then
                sleep = 1
                local onScreen, _x, _y = GetScreenCoordFromWorldCoord(array.uiCoords.x, array.uiCoords.y, array.uiCoords.z)
                if onScreen then
                    SendNUIMessage({
                        action = "update",
                        array = array,
                        onscreen = true,
                        left = _x * 100,
                        top = _y * 100, 
                        dist = math.floor(dist)
                    })
                else
                    SendNUIMessage({
                        action = "update",
                        onscreen = false,
                        array = array,
                    })
                end
                if IsControlPressed(0,0x760A9C6F) then
                    local identifiers = ""
                    if Settings.Identifiers then
                        if Settings.Identifiers.discord then
                            identifiers = array.identifiers.discord
                        end 
                        if Settings.Identifiers.steam then
                            identifiers = identifiers..'\n '..array.identifiers.steam
                        end
                    end
                    local text = Lang('combatLogText', {
                        playerId = array.src,
                        playerName = array.name,
                        reason = array.reason,
                        identifiers = identifiers,
                        time = array.date
                    })
                    SendNUIMessage({
                        action = "copy",
                        value = text
                    })
                    Wait(100)
                    Notify({
                        text = Lang('copied'),
                        time = 5000,
                        type = "success"
                    })
                end
            elseif dist <= 40 and (not array.PED and Settings.ShowPed) then
                array.PED = BSCreatePed(array.coords, array.outfit)
                array.objCoords  = GetOffsetFromEntityInWorldCoords(array.PED,-1.0,0.0,0.0)
                array.uiCoords = GetOffsetFromEntityInWorldCoords(array.PED,-1.0,0.0,1.3)
                array.OBJ = BSCreateObject(array.objCoords)
                sleep = 50
                SendNUIMessage({
                    action = "update",
                    onscreen = false,
                    array = array,
                })
            elseif dist > 40 and array.PED then
                DeleteEntity(array.PED)
                DeleteEntity(array.OBJ)
                array.PED = nil
                array.OBJ = nil
                SendNUIMessage({
                    action = "update",
                    onscreen = false,
                    array = array,
                })
            else
                SendNUIMessage({
                    action = "update",
                    onscreen = false,
                    array = array,
                })
            end
            Wait(sleep)
        end
        if array.PED then
            DeleteEntity(array.PED)
            DeleteEntity(array.OBJ)
        end
        SendNUIMessage({
            action = "remove",
            array = array,
        })
    end)
end)

RegisterCommand('load',function()
    TriggerServerEvent('BS-CombatLog:server:getData')
end)