local Framework = GetResourceState('vorp_core') == 'started' and 'VORP' or (GetResourceState('rsg-core') == 'started' and 'RSG' or false)
if IsDuplicityVersion() then
    -- Server Side Functions
    
    if Framework == 'VORP' then
        local VorpCore = exports.vorp_core:GetCore()
        print('^3[^2'..GetCurrentResourceName()..'^3] ^5VORP Framework Object Loaded!^0')
        function BSGetCharacterName(src)
            local Character = VorpCore.getUser(src)?.getUsedCharacter
            if not Character then return 'Not Logged In' end
            return Character.firstname..' '..Character.lastname
        end

        function BSGetCharId(src)
            local Character = VorpCore.getUser(src)?.getUsedCharacter
            if not Character then return false end
            return Character.charIdentifier
        end

        function BSGetCharData(uid,cb)
            local function ConvertTable(comps, compTints)
                local NewComps = {}

                for k, comp in pairs(comps) do
                    NewComps[k] = { comp = comp, tint0 = 0, tint1 = 0, tint2 = 0, palette = 0 }

                    if compTints and compTints[k] and compTints[k][tostring(comp)] then
                        local compTint = compTints[k][tostring(comp)]
                        NewComps[k].tint0 = compTint.tint0 or 0
                        NewComps[k].tint1 = compTint.tint1 or 0
                        NewComps[k].tint2 = compTint.tint2 or 0
                        NewComps[k].palette = compTint.palette or 0
                    end
                end

                return NewComps
            end

            exports['oxmysql']:execute('SELECT * FROM `characters` WHERE charidentifier = ?', {uid},function(result)
                if not result[1] then return cb(false) end

                local components = ConvertTable(json.decode(result[1].compPlayer), json.decode(result[1].compTints))

                cb({
                    outfit = {
                        skin = json.decode(result[1].skinPlayer),
                        components = components,
                    },
                    coords = json.decode(result[1].coords)
                })
            end)
        end
    elseif Framework == 'RSG' then
        print('^3[^2'..GetCurrentResourceName()..'^3] ^5RSG Framework Object Loaded!^0')
        local RSGCore = exports['rsg-core']:GetCoreObject()
        function BSGetCharacterName(src)
            local Player = RSGCore.Functions.GetPlayer(src)
            if not Player then return 'Not Logged In' end
            return Player.PlayerData.charinfo.firstname.. ' '..Player.PlayerData.charinfo.lastname
        end

        function BSGetCharId(src)
             local Player = RSGCore.Functions.GetPlayer(src)
            if not Player then return 'Not Logged In' end
            return Player.PlayerData.citizenid
        end

        function BSGetCharData(uid,cb)
            exports['oxmysql']:execute('SELECT * FROM `playerskins` WHERE citizenid = ?', {uid},function(result)
                if not result[1] then return cb(false) end
                exports['oxmysql']:execute('SELECT * FROM `players` WHERE citizenid = ?', {uid},function(result2)
                    cb({
                        outfit = {
                            skin = json.decode(result[1].skin),
                            clothes = json.decode(result[1].clothes),
                        },
                        coords = json.decode(result2[1].position)
                    })
                end)
            end)
        end
    end
else
    -- Client Side Functions
    if Framework == 'VORP' then
        RegisterNetEvent('vorp:SelectedCharacter',function()
            TriggerServerEvent('BS-CombatLog:server:getData')
        end)

        function BSCreatePed(coords,data)
            local model = data.skin.sex
            local animation = {
                dict = "amb_camp@world_camp_fire_sit_cold@male@idle_a",
                name = "idle_a"
            }
            if data.skin.sex == "mp_female" then
                animation = {
                    dict = "amb_camp@world_camp_fire_sit_ground@female_a@react_look@active_look",
                    name = "active_look_front"
                }
            end
            local modelHash = GetHashKey(model)
            RequestModel(modelHash)
            while not HasModelLoaded(modelHash) do
                Citizen.Wait(10)
            end
            local ped = CreatePed(modelHash, coords.x, coords.y, coords.z-1, 90.0, false, 0)
            FreezeEntityPosition(ped, true)
            Citizen.InvokeNative(0x283978A15512B2FE, ped, true)
            SetEntityCanBeDamaged(ped, false)
            SetEntityInvincible(ped, true)
            SetEntityCollision(ped,false,true)
            SetEntityAlpha(ped, 200)
            SetBlockingOfNonTemporaryEvents(ped, true)
            SetPedCanRagdoll(ped, false)
            SetModelAsNoLongerNeeded(modelHash)
            SetEntityAsMissionEntity(ped, true, true)
            exports['vorp_character']:LoadPlayerComponents(ped,data.skin or {},data.components or {},false)
            PlaceEntityOnGroundProperly(ped,true)
            RequestAnimDict(animation.dict)
            while not HasAnimDictLoaded(animation.dict) do
                Citizen.Wait(10)
            end 
            TaskPlayAnim(ped, animation.dict, animation.name, 8.0, -8.0, -1, 1, 0, false, false, false)
            return ped
        end

        function BSCreateObject(coords)
            local model = "p_arthur_grave_g"
            local modelHash = GetHashKey(model)
            RequestModel(modelHash)
            while not HasModelLoaded(modelHash) do
                Citizen.Wait(10)
            end
            local obj = CreateObject(modelHash, coords.x, coords.y, coords.z-1, false, false, false)
            FreezeEntityPosition(obj,true)
            SetEntityHeading(obj, 270.0)
            SetModelAsNoLongerNeeded(modelHash)
            SetEntityAsMissionEntity(obj, true, true)
            PlaceEntityOnGroundProperly(obj,true)
            return obj
        end
    elseif Framework == 'RSG' then
        RegisterNetEvent('RSGCore:Client:OnPlayerLoaded',function()
            TriggerServerEvent('BS-CombatLog:server:getData')
        end)

        function BSCreatePed(coords,data)
            local model = "mp_male"
            local animation = {
                dict = "amb_camp@world_camp_fire_sit_cold@male@idle_a",
                name = "idle_a"
            }
            if data.skin.sex == 2 then
                model = "mp_female"
                animation = {
                    dict = "amb_camp@world_camp_fire_sit_ground@female_a@react_look@active_look",
                    name = "active_look_front"
                }
            end
            local modelHash = GetHashKey(model)
            RequestModel(modelHash)
            while not HasModelLoaded(modelHash) do
                Citizen.Wait(10)
            end
            local ped = CreatePed(modelHash, coords.x, coords.y, coords.z-1, 90.0, false, 0)
            FreezeEntityPosition(ped, true)
            Citizen.InvokeNative(0x283978A15512B2FE, ped, true)
            SetEntityCanBeDamaged(ped, false)
            SetEntityInvincible(ped, true)
            SetEntityCollision(ped,false,true)
            SetBlockingOfNonTemporaryEvents(ped, true)
            SetPedCanRagdoll(ped, false)
            SetModelAsNoLongerNeeded(modelHash)
            SetEntityAsMissionEntity(ped, true, true)

            exports['rsg-appearance']:ApplySkinMultiChar(data.skin or {},ped,data.clothes or {})
            SetEntityAlpha(ped, 200)
            PlaceEntityOnGroundProperly(ped,true)
            RequestAnimDict(animation.dict)
            while not HasAnimDictLoaded(animation.dict) do
                Citizen.Wait(10)
            end 
            TaskPlayAnim(ped, animation.dict, animation.name, 8.0, -8.0, -1, 1, 0, false, false, false)
            return ped
        end

        function BSCreateObject(coords)
            local model = "p_arthur_grave_g"
            local modelHash = GetHashKey(model)
            RequestModel(modelHash)
            while not HasModelLoaded(modelHash) do
                Citizen.Wait(10)
            end
            local obj = CreateObject(modelHash, coords.x, coords.y, coords.z-1, false, false, false)
            FreezeEntityPosition(obj,true)
            SetEntityHeading(obj, 270.0)
            SetModelAsNoLongerNeeded(modelHash)
            SetEntityAsMissionEntity(obj, true, true)
            PlaceEntityOnGroundProperly(obj, true)
            return obj
        end
    else
        Citizen.CreateThread(function()
            while true do
                print('^3[^2'..GetCurrentResourceName()..'^3] ^5Framework Object Not Found!^0')
                Citizen.Wait(5000)
            end
        end)
    end
end

function Lang(key, subs)
  local translate = Settings.Locale[Settings.Language][key] and Settings.Locale[Settings.Language][key] or 'Locale ['..key..'] doesn\'t exits'
  subs = subs and subs or {}
  for k, v in pairs(subs) do
      local templateToFind = '%${' .. k .. '}'
      local safeValue = tostring(v):gsub("%%", "%%%%")
      translate = translate:gsub(templateToFind, safeValue)
  end
  translate = tostring(translate):gsub("%%%%", "%%")
  return tostring(translate)
end

function Notify(data)
    local text = data.text
    local time = data.time or 5000  
    local type = data.type 
    local src = data.src

    if IsDuplicityVersion() then
        if Framework == "RSG" then
            TriggerClientEvent('ox_lib:notify', src, { title = text, type = type, duration = time })
        elseif Framework == "VORP" then
            TriggerClientEvent("vorp:TipBottom",src, text, time, type)
        end
    else
        if Framework == "RSG" then
            TriggerEvent('ox_lib:notify', { title = text, type = type, duration = time })
        elseif Framework == "VORP" then
            TriggerEvent("vorp:TipBottom", text, time, type)
        end
    end
end