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
    if not indienst then
        indienst = true
        exports['okokNotify']:Alert("Staff Dienst", "Welkom, "..name.."!", 5000, 'success')
    elseif indienst then
        indienst = false
        exports['okokNotify']:Alert("Staff Dienst", "Bedankt voor je dienst, "..name.."!", 5000, 'info')
    end
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
    if indienst and not NoClipStatus then
        if IsPedInAnyVehicle(PlayerPedId(), false) then
            NoClipEntity = GetVehiclePedIsIn(PlayerPedId(), false)
        else
            NoClipEntity = PlayerPedId()
        end

        SetEntityAlpha(NoClipEntity, 51, 0)
        if(NoClipEntity ~= PlayerPedId()) then
            SetEntityAlpha(PlayerPedId(), 51, 0)
        end
    elseif indienst and NoClipStatus then
        ResetEntityAlpha(NoClipEntity)
        if(NoClipEntity ~= PlayerPedId()) then
            ResetEntityAlpha(PlayerPedId())
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
    if indienst and NoClipStatus then
        TriggerEvent('karneadmin:toggleNoClip')
    elseif indienst and not NoClipStatus then
        TriggerServerEvent('karneadmin:noClip')
    elseif not indienst then
        exports['okokNotify']:Alert("Staff Dienst", "Je bent niet in dienst!", 5000, 'error')
    end
end, false)

RegisterCommand('karnenoclip_cam', function()
    FollowCamMode = not FollowCamMode
end, false)

RegisterCommand('karnenoclip_speed', function()
    if index ~= #Speeds then
        index = index + 1
        CurrentSpeed = Speeds[index].speed
    else
        CurrentSpeed = Speeds[1].speed
        index = 1
    end
end, false)

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

-------- 

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
end, false)

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
            exports['okokNotify']:Alert("Staff Fixveh", "Voertuig is weer helemaal schier!", 3000, 'info')
            ClearPedTasks(ped)
        else
            exports['okokNotify']:Alert("Staff Fixveh", "Je bent niet in de buurt van een voertuig.", 3000, 'error')
        end
    end
end

----- End of fixVeh & heal
local onlinePlayers, forceDraw = {}, false
local joostactief = false

Citizen.CreateThread(function()
    TriggerServerEvent("karne-showid:add-id")
    while true do
        Citizen.Wait(5)
        if indienst and joostactief then
            for k, v in pairs(GetNeareastPlayers()) do
                local x, y, z = table.unpack(v.coords)
                Draw3DText(x, y, z + 1.1, v.playerId, 1.0)
                Draw3DText(x, y, z + 1.20, v.topText, 1.0)
            end
        end
    end
end)

RegisterCommand("names", function(source, args, rawCommand)
    if indienst then
        joostactief = not joostactief
    elseif not indienst then
        exports['okokNotify']:Alert("Staff Dienst", "Je bent niet in dienst!", 5000, 'error')
    else
        exports['okokNotify']:Alert("Onvoldoende Rechten", "Helaas... Je bent geen staff!", 5000, 'error')
    end
end, false)

RegisterNetEvent('karne-showid:client:add-id')
AddEventHandler('karne-showid:client:add-id', function(identifier, playerSource)
    if playerSource then
        onlinePlayers[playerSource] = identifier
    else
        onlinePlayers = identifier
    end
end)

function Draw3DText(x, y, z, text, newScale)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    if onScreen then
        local dist = GetDistanceBetweenCoords(GetGameplayCamCoords(), x, y, z, 1)
        local scale = newScale * (1 / dist) * (1 / GetGameplayCamFov()) * 100
        SetTextScale(scale, scale)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextDropShadow(0, 0, 0, 0, 255)
        SetTextDropShadow()
        SetTextEdge(4, 0, 0, 0, 255)
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end

function GetNeareastPlayers()
    local playerPed = PlayerPedId()
    local players_clean = {}
    local playerCoords = GetEntityCoords(playerPed)
    if IsPedInAnyVehicle(playerPed, false) then
        local playersId = tostring(GetPlayerServerId(PlayerId()))
        table.insert(players_clean, {topText = onlinePlayers[playersId], playerId = playersId, coords = playerCoords} )
    else
        local players, _ = GetPlayersInArea(playerCoords, 200)
        for i = 1, #players, 1 do
            local playerServerId = GetPlayerServerId(players[i])
            local player = GetPlayerFromServerId(playerServerId)
            local ped = GetPlayerPed(player)
            if IsEntityVisible(ped) then
                for x, identifier in pairs(onlinePlayers) do 
                    if x == tostring(playerServerId) then
                        table.insert(players_clean, {topText = identifier:upper(), playerId = playerServerId, coords = GetEntityCoords(ped)})
                    end
                end
            end
        end
    end
   
    return players_clean
end

function GetPlayersInArea(coords, area)
	local players, playersInArea = GetPlayers(), {}
	local coords = vector3(coords.x, coords.y, coords.z)
	for i=1, #players, 1 do
		local target = GetPlayerPed(players[i])
		local targetCoords = GetEntityCoords(target)

		if #(coords - targetCoords) <= area then
			table.insert(playersInArea, players[i])
		end
	end
	return playersInArea
end

function GetPlayers()
    local players = {}
    for _, player in ipairs(GetActivePlayers()) do
        local ped = GetPlayerPed(player)
        if DoesEntityExist(ped) then
            table.insert(players, player)
        end
    end
    return players
end

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
    Wait(1)

        for i = 0, 255 do
            if NetworkIsPlayerActive(i) and GetPlayerPed(i) ~= GetPlayerPed(-1) then
                ped = GetPlayerPed(i)
                blip = GetBlipFromEntity(ped)
            
                idTesta = Citizen.InvokeNative(0xBFEFE3321A3F5015, ped, GetPlayerName(i), false, false, "", false)

                if indienst and karneblip then
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
end)