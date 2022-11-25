-- Base
ESX = nil
local indienst = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('karneadmin:syncdienst')
AddEventHandler('karneadmin:syncdienst', function(id, name)
    indienst = true
    exports['okokNotify']:Alert("Staff Dienst", "Welkom, "..name.."!", 5000, 'success')
end)

RegisterNetEvent('karneadmin:resetdienst')
AddEventHandler('karneadmin:resetdienst', function(id, name)
    indienst = false
    NoClipStatus = false
    NoClipEntity = false
    radarEsteso = false
    karneblip = false
    joostactief = false
    exports['okokNotify']:Alert("Staff Dienst", "Bedankt voor je dienst, "..name.."!", 5000, 'info')
end)

-- ADMIN SHIT BEGINT HIER OULEHH
local Speeds = {
    { speed = 0 },
    { speed = 0.5 },
    { speed = 2 },
    { speed = 5 },
    { speed = 10 },
    { speed = 15 },
}
local Offsets = {
    y = 0.5,
    z = 0.2,
    h = 3,
}
local Controls = {
    goUp = 85, -- Q
    goDown = 48, -- Z
    turnLeft = 34, -- A
    turnRight = 35, -- D
    goForward = 32,  -- W
    goBackward = 33, -- S
}
local NoClipStatus = false
local NoClipEntity = false
local FollowCamMode = true
local index = 1
local CurrentSpeed = Speeds[index].speed


Citizen.CreateThread(function()
    while true do
        while NoClipStatus do
            DisableAllControlActions()
            EnableControlAction(1, 245, true)
            EnableControlAction(0, 1, true)
            EnableControlAction(0, 2, true)

            local yoff = 0.0
            local zoff = 0.0

			if IsDisabledControlPressed(0, Controls.goForward) then
                yoff = Offsets.y
			end
			
            if IsDisabledControlPressed(0, Controls.goBackward) then
                yoff = -Offsets.y
			end

            if IsDisabledControlPressed(0, 85) then
                zoff = Offsets.z
			end
			
            if IsDisabledControlPressed(0, Controls.goDown) then
                zoff = -Offsets.z
			end

            if not FollowCamMode and IsDisabledControlPressed(0, Controls.turnLeft) then
                SetEntityHeading(PlayerPedId(), GetEntityHeading(PlayerPedId())+Offsets.h)
			end
			
            if not FollowCamMode and IsDisabledControlPressed(0, Controls.turnRight) then
                SetEntityHeading(PlayerPedId(), GetEntityHeading(PlayerPedId())-Offsets.h)
			end
			
            local newPos = GetOffsetFromEntityInWorldCoords(NoClipEntity, 0.0, yoff * (CurrentSpeed + 0.3), zoff * (CurrentSpeed + 0.3))
            local heading = GetEntityHeading(NoClipEntity)
            
            SetEntityVelocity(NoClipEntity, 0.0, 0.0, 0.0)
            SetEntityRotation(NoClipEntity, 0.0, 0.0, 0.0, 0, false)
            if(FollowCamMode) then
                SetEntityHeading(NoClipEntity, GetGameplayCamRelativeHeading());
            else
                SetEntityHeading(NoClipEntity, heading);
            end
            SetEntityCoordsNoOffset(NoClipEntity, newPos.x, newPos.y, newPos.z, true, true, true)

            SetLocalPlayerVisibleLocally(true);
            Citizen.Wait(0)
        end
        Citizen.Wait(0)
    end
end)

RegisterNetEvent('karneadmin:toggleNoClip')
AddEventHandler('karneadmin:toggleNoClip', function()
    if indienst then
        if not NoClipStatus then
            if IsPedInAnyVehicle(PlayerPedId(), false) then
                NoClipEntity = GetVehiclePedIsIn(PlayerPedId(), false)
            else
                NoClipEntity = PlayerPedId()
            end

            SetEntityAlpha(NoClipEntity, 51, 0)
            if(NoClipEntity ~= PlayerPedId()) then
                SetEntityAlpha(PlayerPedId(), 51, 0)
            end
        elseif NoClipStatus then
            ResetEntityAlpha(NoClipEntity)
            if(NoClipEntity ~= PlayerPedId()) then
                ResetEntityAlpha(PlayerPedId())
            end
        end
    elseif not indienst then
        exports['okokNotify']:Alert("Staff Dienst", "Je bent niet in dienst!", 5000, 'error')
    else
        exports['okokNotify']:Alert("Bliep. Bloep. Bliep?", "Je bent geen staff.", 5000, 'error')
    end

    SetEntityCollision(NoClipEntity, NoClipStatus, NoClipStatus)
    FreezeEntityPosition(NoClipEntity, not NoClipStatus)
    SetEntityInvincible(NoClipEntity, not NoClipStatus)
    SetEntityVisible(NoClipEntity, NoClipStatus, not NoClipStatus);
    SetEveryoneIgnorePlayer(PlayerPedId(), not NoClipStatus);
    SetPoliceIgnorePlayer(PlayerPedId(), not NoClipStatus);

    NoClipStatus = not NoClipStatus
end)

RegisterCommand('karnenoclip', function()
    if indienst then
        if NoClipStatus then
            TriggerEvent('karneadmin:toggleNoClip')
        elseif not NoClipStatus then
            TriggerServerEvent('karneadmin:noClip')
        end
    else
        exports['okokNotify']:Alert("Staff Dienst", "Je bent niet in dienst!", 5000, 'error')
    end
end)

RegisterCommand('karnenoclip_cam', function()
    FollowCamMode = not FollowCamMode
end)

RegisterCommand('karnenoclip_speed', function()
    if index ~= #Speeds then
        index = index + 1
        CurrentSpeed = Speeds[index].speed
    else
        CurrentSpeed = Speeds[1].speed
        index = 1
    end
end)

RegisterKeyMapping('karnenoclip', 'NoClip', 'keyboard', 'DELETE')
RegisterKeyMapping('karnenoclip_cam', 'NoClip Camera', 'keyboard', 'V')
RegisterKeyMapping('karnenoclip_speed', 'NoClip Speed', 'keyboard', 'LSHIFT')

-------- EINDE VAN DIE KAULO NOCLIP VANAF HIER IETS ANDERS SWA

RegisterCommand("tpm", function(source)
    if indienst then
        TeleportToWaypoint()
    elseif not indienst then
        exports['okokNotify']:Alert("Staff Dienst", "Je bent niet in dienst!", 5000, 'error')
    else
        exports['okokNotify']:Alert("Onvoldoende Rechten", "Helaas... Je bent geen staff!", 5000, 'error')
    end
end)

TeleportToWaypoint = function()
    if indienst then
        local joostzijnmoeder = GetFirstBlipInfoId(8)
        if DoesBlipExist(joostzijnmoeder) then
            local waypointCoords = GetBlipInfoIdCoord(joostzijnmoeder)
            for height = 1, 1000 do
                SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)
                local foundGround, zPos = GetGroundZFor_3dCoord(waypointCoords["x"], waypointCoords["y"], height + 0.0)
                if foundGround then
                    SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)
                    break
                end
                Citizen.Wait(5)
            end
            exports['okokNotify']:Alert("Staff TPM", "Je wordt door het wormgat geduwd...", 3000, 'info')
        else
            exports['okokNotify']:Alert("Staff TPM", "Plaats eerst een waypoint!", 3000, 'error')
        end
    else
        exports['okokNotify']:Alert("Onvoldoende Rechten", "Helaas... Je bent geen staff!", 5000, 'error')
        -- Kunnen hier ook gewoon een ban gooien want ja door de eerste check heengekomen
    end
end

-------- MAN MAN MAN JOOST IS ECHT EEN KLEREJONG

RegisterNetEvent("karneheal")
AddEventHandler("karneheal", function(wiedansmeh, joost)
    local player = PlayerPedId(wiedansmeh)
    if indienst then
        if joost then
            SetEntityHealth(player, GetEntityMaxHealth(player))
        elseif not joost then
            SetEntityHealth(PlayerPedId(), GetEntityMaxHealth(PlayerPedId()))
        end
    end
end)

local VehicleData = nil
RegisterCommand("fixveh", function(source, args, rawCommand)
    if indienst then
        happetee()
    elseif not indienst then
        exports['okokNotify']:Alert("Staff Dienst", "Je bent niet in dienst!", 5000, 'error')
    else
        exports['okokNotify']:Alert("Onvoldoende Rechten", "Helaas... Je bent geen staff!", 5000, 'error')
    end
end)

function happetee()
    if indienst then
        local ped = PlayerPedId()
        local pedcoords = GetEntityCoords(ped)
        VehicleData = ESX.Game.GetClosestVehicle()

        local dist = #(pedcoords - GetEntityCoords(VehicleData))
        if dist <= 3 then
            RequestAnimDict('missfinale_c2ig_11')
            while not HasAnimDictLoaded("missfinale_c2ig_11") do
                Wait(10)
            end
            TaskPlayAnim(ped, 'missfinale_c2ig_11', 'pushcar_offcliff_m', 2.0, -8.0, -1, 35, 0, 0, 0, 0)
            Wait(2*1000)
            local carCoords = GetEntityRotation(VehicleData, 2)
            SetEntityRotation(VehicleData, carCoords[1], 0, carCoords[3], 2, true)
            SetVehicleFixed(VehicleData)
	        SetVehicleDeformationFixed(VehicleData)
            SetVehicleOnGroundProperly(VehicleData)
            SetVehicleDoorsLocked(VehicleData, 1)
            exports['okokNotify']:Alert("Staff Fixveh", "Voertuig is weer helemaal schier!", 3000, 'info')
            ClearPedTasks(ped)
        else
            exports['okokNotify']:Alert("Staff Fixveh", "Je bent niet in de buurt van een voertuig.", 3000, 'error')
        end
    end
end

--- End of fixVeh & heal
-- local onlinePlayers, forceDraw = {}, false
-- local joostactief = false

-- Citizen.CreateThread(function()
--     TriggerServerEvent("karne-showid:add-id")
--     while true do
--         Citizen.Wait(5)
--         if indienst then
--             if joostactief then
--                 for k, v in pairs(GetNeareastPlayers()) do
--                     local x, y, z = table.unpack(v.coords)
--                     Draw3DText(x, y, z + 1.1, v.playerId, 1.0)
--                     Draw3DText(x, y, z + 1.20, v.topText, 1.0)
--                 end
--             end
--         end
--     end
-- end)

-- RegisterCommand("names", function(source, args, rawCommand)
--     if indienst then
--         joostactief = not joostactief
--         TriggerServerEvent("karne-showid:add-id")
--     elseif not indienst then
--         exports['okokNotify']:Alert("Staff Dienst", "Je bent niet in dienst!", 5000, 'error')
--     else
--         exports['okokNotify']:Alert("Onvoldoende Rechten", "Helaas... Je bent geen staff!", 5000, 'error')
--     end
-- end)

-- RegisterNetEvent('karne-showid:client:add-id')
-- AddEventHandler('karne-showid:client:add-id', function(identifier, playerSource)
--     if playerSource then
--         onlinePlayers[playerSource] = identifier
--     else
--         onlinePlayers = identifier
--     end
-- end)

-- function Draw3DText(x, y, z, text, newScale)
--     local onScreen, _x, _y = World3dToScreen2d(x, y, z)
--     if onScreen then
--         SetTextScale(0.5, 0.5)
--         SetTextFont(4)
--         SetTextProportional(1)
--         SetTextColour(255, 255, 255, 255)
--         SetTextDropShadow(0, 0, 0, 0, 255)
--         SetTextDropShadow()
--         SetTextEdge(4, 0, 0, 0, 255)
--         SetTextOutline()
--         SetTextEntry("STRING")
--         SetTextCentre(1)
--         AddTextComponentString(text)
--         DrawText(_x, _y)
--     end
-- end

-- function GetNeareastPlayers()
--     local playerPed = PlayerPedId()
--     local players_clean = {}
--     local playerCoords = GetEntityCoords(playerPed)
--     if IsPedInAnyVehicle(playerPed, false) then
--         local playersId = tostring(GetPlayerServerId(PlayerId()))
--         table.insert(players_clean, {topText = onlinePlayers[playersId], playerId = playersId, coords = playerCoords} )
--     else
--         local players, _ = GetPlayersInArea(playerCoords, 200)
--         for i = 1, #players, 1 do
--             local playerServerId = GetPlayerServerId(players[i])
--             local player = GetPlayerFromServerId(playerServerId)
--             local ped = GetPlayerPed(player)
--             if IsEntityVisible(ped) then
--                 for x, identifier in pairs(onlinePlayers) do 
--                     if x == tostring(playerServerId) then
--                         table.insert(players_clean, {topText = identifier:upper(), playerId = playerServerId, coords = GetEntityCoords(ped)})
--                     end
--                 end
--             end
--         end
--     end
   
--     return players_clean
-- end

-- function GetPlayersInArea(coords, area)
-- 	local players, playersInArea = GetPlayers(), {}
-- 	local coords = vector3(coords.x, coords.y, coords.z)
-- 	for i=1, #players, 1 do
-- 		local target = GetPlayerPed(players[i])
-- 		local targetCoords = GetEntityCoords(target)

-- 		if #(coords - targetCoords) <= area then
-- 			table.insert(playersInArea, players[i])
-- 		end
-- 	end
-- 	return playersInArea
-- end

-- function GetPlayers()
--     local players = {}
--     for _, player in ipairs(GetActivePlayers()) do
--         local ped = GetPlayerPed(player)
--         if DoesEntityExist(ped) then
--             table.insert(players, player)
--         end
--     end
--     return players
-- end

----- End of Names
local radarEsteso = false
local karneblip = false

RegisterNetEvent('karneblips')
AddEventHandler('karneblips', function()
    if indienst then
        karneblip = not karneblip
        if karneblip then
            karneblip = true
        else
            karneblip = false
        end
    end
end)

Citizen.CreateThread(function()
    while true do
    Wait(100)
        for i = 0, 255 do
            if NetworkIsPlayerActive(i) and GetPlayerPed(i) ~= GetPlayerPed(-1) then
            ped = GetPlayerPed(i)
            blip = GetBlipFromEntity(ped)
            if indienst then
                if karneblip then
                    if not DoesBlipExist(blip) then
                        blip = AddBlipForEntity(ped)
                        SetBlipSprite(blip, 1) 
                        Citizen.InvokeNative(0x5FBCA48327B914DF, blip, true)
                    else 
                        veh = GetVehiclePedIsIn(ped, false) 
                        blipSprite = GetBlipSprite(blip)
                        if not GetEntityHealth(ped) then 
                            if blipSprite ~= 274 then
                                SetBlipSprite(blip, 274)
                                Citizen.InvokeNative(0x5FBCA48327B914DF, blip, false) 
                            end
                        elseif veh then 
                            calsseVeicolo = GetVehicleClass(veh)
                            modelloVeicolo = GetEntityModel(veh)
                            if calsseVeicolo == 15 then 
                                if blipSprite ~= 422 then 
                                    SetBlipSprite(blip, 422) 
                                    Citizen.InvokeNative(0x5FBCA48327B914DF, blip, false) 
                                end
                            elseif calsseVeicolo == 16 then 
                                if modelloVeicolo == GetHashKey("besra") or modelloVeicolo == GetHashKey("hydra") or modelloVeicolo == GetHashKey("lazer") then -- controllo se il modello è un jet militare
                                    if blipSprite ~= 424 then
                                        SetBlipSprite(blip, 424)
                                        Citizen.InvokeNative(0x5FBCA48327B914DF, blip, false)
                                    end
                                elseif blipSprite ~= 423 then
                                    SetBlipSprite(blip, 423)
                                    Citizen.InvokeNative (0x5FBCA48327B914DF, blip, false) 
                                end
                            elseif calsseVeicolo == 14 then 
                                if blipSprite ~= 427 then
                                    SetBlipSprite(blip, 427)
                                    Citizen.InvokeNative(0x5FBCA48327B914DF, blip, false) 
                                end
                            elseif modelloVeicolo == GetHashKey("insurgent") or modelloVeicolo == GetHashKey("insurgent2") or modelloVeicolo == GetHashKey("limo2") then
                                    if blipSprite ~= 426 then
                                        SetBlipSprite(blip, 426)
                                        Citizen.InvokeNative(0x5FBCA48327B914DF, blip, false) 
                                    end
                                elseif modelloVeicolo == GetHashKey("rhino") then
                                    if blipSprite ~= 421 then
                                        SetBlipSprite(blip, 421)
                                        Citizen.InvokeNative(0x5FBCA48327B914DF, blip, false) 
                                    end
                                elseif blipSprite ~= 1 then 
                                    SetBlipSprite(blip, 1)
                                    Citizen.InvokeNative(0x5FBCA48327B914DF, blip, true)
                                end
                            
                                passengers = GetVehicleNumberOfPassengers(veh)
                                if passengers then
                                    if not IsVehicleSeatFree(veh, -1) then
                                        passengers = passengers + 1
                                    end
                                    ShowNumberOnBlip(blip, passengers)
                                else
                                    HideNumberOnBlip(blip)
                                end
                            else
                            
                                HideNumberOnBlip(blip)
                                if blipSprite ~= 1 then
                                    SetBlipSprite(blip, 1)
                                    Citizen.InvokeNative(0x5FBCA48327B914DF, blip, true) 
                                end
                            end
                            SetBlipRotation(blip, math.ceil(GetEntityHeading(veh))) 
                            SetBlipNameToPlayerName(blip, i) 
                            SetBlipScale(blip, 0.85) 
                            if IsPauseMenuActive() then
                                SetBlipAlpha(blip, 255)
                            else 
                                x1, y1 = table.unpack(GetEntityCoords(GetPlayerPed(-1), true)) 
                                x2, y2 = table.unpack(GetEntityCoords(GetPlayerPed(i), true)) 
                                distanza = (math.floor(math.abs(math.sqrt((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2))) / -1)) + 900
                                if distanza < 0 then
                                    distanza = 0
                                elseif distanza > 255 then
                                    distanza = 255
                                end
                                SetBlipAlpha(blip, distanza)
                            end
                        end
                    else
                        RemoveBlip(blip)
                    end
                end
            end
        end
    end
end)
-- Reports alleen als je in dienst bent
RegisterNetEvent('karnemelk:laatmaarkomen')
AddEventHandler('karnemelk:laatmaarkomen', function()
    if indienst then
        exports['okokNotify']:Alert("NIEUWE REPORT", "Er is een nieuwe report aangemaakt.", 5000, 'info')
    end
end)
-- Loon
Citizen.CreateThread(function()
    local sleep = 60000*15
    while true do
        Citizen.Wait(sleep)
        if indienst then
            TriggerServerEvent('karnemelk:dikgeldverdienen')
        end
    end
end)
-- kill
RegisterNetEvent("karnekill")
AddEventHandler("karnekill", function(wiedansmeh)
    local player = PlayerPedId(wiedansmeh)
    if indienst then
        SetEntityHealth(player, 0)
    end
end)
--showinv

RegisterNetEvent("karneinv")
AddEventHandler("karneinv", function(wiedan)
    if indienst then
        OpenBodySearchMenu(wiedan)
    end
end)

function OpenBodySearchMenu(player)
    ESX.TriggerServerCallback('karnemelk:getOtherPlayerData', function(data)

        local elements = {}

        table.insert(elements, {
            label = '<b>JOB & GELD</b>',
            value = nil
        })

        table.insert(elements, {
            label = data.job,
            value = nil
        })

        for i = 1, #data.accounts, 1 do

            if data.accounts[i].name == 'black_money' and data.accounts[i].money > 0 then

                table.insert(elements, {
                    label = 'Zwart Geld: €'..ESX.Math.Round(data.accounts[i].money),
                    value = 'black_money',
                    itemType = 'item_account',
                    amount = data.accounts[i].money
                })

            end
            if data.accounts[i].name == 'money' and data.accounts[i].money > 0 then
                table.insert(elements, {
                    label = 'Cash Geld: €'..ESX.Math.Round(data.accounts[i].money),
                    value = 'money',
                    itemType = 'item_account',
                    amount = data.accounts[i].money
                })
            end
            if data.accounts[i].name == 'bank' and data.accounts[i].money > 0 then
                table.insert(elements, {
                    label = 'Bank: €'..ESX.Math.Round(data.accounts[i].money),
                    value = 'bank',
                    itemType = 'item_account',
                    amount = data.accounts[i].money
                })
                break
            end
        end

        table.insert(elements, {
            label = '<b>WAPENS</b>',
            value = nil
        })

        for i = 1, #data.weapons, 1 do
            table.insert(elements, {
                label = ESX.GetWeaponLabel(data.weapons[i].name).." met "..data.weapons[i].ammo.." kogels",
                value = data.weapons[i].name,
                itemType = 'item_weapon',
                amount = data.weapons[i].ammo
            })
        end

        table.insert(elements, {
            label = '<b>ITEMS</b>',
            value = nil
        })

        for i = 1, #data.inventory, 1 do
            if data.inventory[i].count > 0 then
                table.insert(elements, {
                    label = data.inventory[i].count.."x "..data.inventory[i].label,
                    value = data.inventory[i].name,
                    itemType = 'item_standard',
                    amount = data.inventory[i].count
                })
            end
        end

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'body_search', {
            title = 'Staff Search 🥛',
            align = 'top-right',
            elements = elements
        }, function(data, menu)

            local itemType = data.current.itemType
            local itemName = data.current.value
            local amount = data.current.amount

            if data.current.value ~= nil then
                TriggerServerEvent('karnemelk:wegermee', player, itemType, itemName,
                    amount)
                OpenBodySearchMenu(player)
            end

        end, function(data, menu)
            menu.close()
        end)

    end, player)

end

RegisterNetEvent('BanSql:Respond')
AddEventHandler('BanSql:Respond', function()
	TriggerServerEvent("BanSql:CheckMe")
end)

RegisterNetEvent('karnechat:lekkerchatten', function(id, name, message)
    if indienst then
	    TriggerEvent('chat:addMessage', {
	    	template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(255,32,19, 0.6); border-radius: 3px;"><i class="fas fa-user"></i> <b>[{0}]:</b> {1}</div>',
	    	args = { name, message }
	    })
    end
end)