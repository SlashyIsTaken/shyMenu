ESX = exports['es_extended']:getSharedObject()

local onduty = false
local Speeds = {
    { speed = 0 },
    { speed = 0.5 },
    { speed = 2 },
    { speed = 5 },
    { speed = 10 },
    { speed = 15 }
}
local Offsets = {
    y = 0.5,
    z = 0.2,
    h = 3
}
local Controls = {
    goUp = 85, -- Q
    goDown = 48, -- Z
    turnLeft = 34, -- A
    turnRight = 35, -- D
    goForward = 32,  -- W
    goBackward = 33 -- S
}
local NoClipStatus = false
local NoClipEntity = false
local FollowCamMode = true
local index = 1
local CurrentSpeed = Speeds[index].speed
local VehicleData = nil

-- Don't touch
RegisterNetEvent('shyMenu:syncduty')
AddEventHandler('shyMenu:syncduty', function(id, name)
    onduty = true
    Notify(Config.Translations.dutytitle, Config.Translations.welcome..", "..name.."!", "success")
end)

RegisterNetEvent('shyMenu:resetduty')
AddEventHandler('shyMenu:resetduty', function(id, name)
    onduty = false
    NoClipStatus = false
    Notify(Config.Translations.dutytitle, Config.Translations.thanks..", "..name.."!", "info")
end)

RegisterNetEvent('shyMenu:notify')
AddEventHandler('shyMenu:notify', function(title, text, style)
    Notify(title, text, style)
end)

-- Noclip
Citizen.CreateThread(function()
    while true do
        while NoClipStatus do
            -- Disables all controls, then enables some crucial again. Feel free to add or remove some.
            DisableAllControlActions()
            EnableControlAction(0, 1, true) -- Pan
            EnableControlAction(0, 2, true) -- Tilt
            EnableControlAction(0, 18, true) -- Enter
            EnableControlAction(0, 24, true) -- RMB
            EnableControlAction(0, 25, true) -- LMB
            EnableControlAction(0, 26, true) -- C
            EnableControlAction(0, 36, true) -- Left Control
            EnableControlAction(1, 245, true) -- T
            EnableControlAction(0, 249, true) -- N

            local yoff = 0.0
            local zoff = 0.0

			if IsDisabledControlPressed(0, Controls.goForward) then
                yoff = Offsets.y
			end
			
            if IsDisabledControlPressed(0, Controls.goBackward) then
                yoff = -Offsets.y
			end

            if IsDisabledControlPressed(0, Controls.goUp) then
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

RegisterNetEvent('shyMenu:toggleNoClip')
AddEventHandler('shyMenu:toggleNoClip', function()
    if onduty then
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
    elseif not onduty then
        Notify(Config.Translations.dutytitle, Config.Translations.offduty, "error")
    else
        Notify("Beep, Boop, Bleep?", Config.Translations.notstaff, "error")
    end

    SetEntityCollision(NoClipEntity, NoClipStatus, NoClipStatus)
    FreezeEntityPosition(NoClipEntity, not NoClipStatus)
    SetEntityInvincible(NoClipEntity, not NoClipStatus)
    SetEntityVisible(NoClipEntity, NoClipStatus, not NoClipStatus);
    SetEveryoneIgnorePlayer(PlayerPedId(), not NoClipStatus);
    SetPoliceIgnorePlayer(PlayerPedId(), not NoClipStatus);

    NoClipStatus = not NoClipStatus
end)

RegisterCommand('shynoclip', function()
    if onduty then
        if NoClipStatus then
            TriggerEvent('shyMenu:toggleNoClip')
        elseif not NoClipStatus then
            TriggerServerEvent('shyMenu:noClip')
        end
    else
        Notify(Config.Translations.dutytitle, Config.Translations.offduty, "error")
    end
end)

RegisterCommand('shy_cam', function()
    FollowCamMode = not FollowCamMode
end)

RegisterCommand('shy_speed', function()
    if index ~= #Speeds then
        index = index + 1
        CurrentSpeed = Speeds[index].speed
    else
        CurrentSpeed = Speeds[1].speed
        index = 1
    end
end)

RegisterKeyMapping('shynoclip', 'NoClip', 'keyboard', Config.NoclipKey)
RegisterKeyMapping('shy_cam', 'NoClip Camera', 'keyboard', Config.AlterCameraKey)
RegisterKeyMapping('shy_speed', 'NoClip Speed', 'keyboard', Config.AlterSpeedKey)

-- Teleport to waypoint
RegisterNetEvent("shyMenu:tpm")
AddEventHandler("shyMenu:tpm", function()
    if onduty then
        TeleportToWaypoint()
    elseif not onduty then
        Notify(Config.Translations.dutytitle, Config.Translations.offduty, "error")
    else
        Notify("Beep, Boop, Bleep?", Config.Translations.notstaff, "error")
    end
end)

TeleportToWaypoint = function()
    if onduty then
        local waypoint = GetFirstBlipInfoId(8)
        if DoesBlipExist(waypoint) then
            local waypointCoords = GetBlipInfoIdCoord(waypoint)
            for height = 1, 1000 do
                SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)
                local foundGround, zPos = GetGroundZFor_3dCoord(waypointCoords["x"], waypointCoords["y"], height + 0.0)
                if foundGround then
                    SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)
                    break
                end
                Citizen.Wait(5)
            end
            Notify("TPM", Config.Translations.tpmsuccess, "success")
        else
            Notify("TPM", Config.Translations.nowp, "error")
        end
    end
end

-- Healing yourself or others
RegisterNetEvent("shyMenu:heal")
AddEventHandler("shyMenu:heal", function(who, bool)
    local player = PlayerPedId(who)
    if onduty then
        if bool then
            SetEntityHealth(player, GetEntityMaxHealth(player))
        elseif not bool then
            SetEntityHealth(PlayerPedId(), GetEntityMaxHealth(PlayerPedId()))
        end
    end
end)

-- Fixing vehicles
RegisterNetEvent("shyMenu:fixveh")
AddEventHandler("shyMenu:fixveh", function()
    if onduty then
        vehiclefix()
    elseif not onduty then
        Notify(Config.Translations.dutytitle, Config.Translations.offduty, "error")
    else
        Notify("Beep, Boop, Bleep?", Config.Translations.notstaff, "error")
    end
end)

function vehiclefix()
    if onduty then
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
            Notify("Vehicle Fix", Config.Translations.fixedveh, "success")
            ClearPedTasks(ped)
        else
            Notify("Vehicle Fix", Config.Translations.noveh, "error")
        end
    end
end

-- If you are using a report system, paste 'TriggerClientEvent('shyMenu:newreport', source)' in the report function server side, or 'TriggerEvent('shyMenu:newreport')' in the function client side.
RegisterNetEvent('shyMenu:newreport')
AddEventHandler('shyMenu:newreport', function()
    if onduty then
        Notify(Config.Translations.newreporttitle, Config.Translations.newreport, "info")
    end
end)

-- Money for staff members, toggled in config.
Citizen.CreateThread(function()
    if Config.EnableStaffPayout then
        local sleep = 60000*15 -- every 15 minutes
        while true do
            Citizen.Wait(sleep)
            if onduty then
                TriggerServerEvent('shyMenu:staffmoney')
            end
        end
    end
end)

-- kill
RegisterNetEvent("shyMenu:kill")
AddEventHandler("shyMenu:kill", function(who)
    local player = PlayerPedId(who)
    SetEntityHealth(player, 0)
end)

-- Admin Chat
RegisterNetEvent('shyMenu:adminchat', function(id, name, message)
    if onduty then
	    TriggerEvent('chat:addMessage', {
	    	template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(255,32,19, 0.6); border-radius: 3px;"><i class="fas fa-user"></i> <b>[{0}]:</b> {1}</div>',
	    	args = { name, message }
	    })
    end
end)

-- Altering peds
RegisterNetEvent('shyMenu:changePed')
AddEventHandler('shyMenu:changePed', function(pedHash)
    local ped_hash = GetHashKey(pedHash)
    if ped_hash ~= nil then
        RequestModel(ped_hash)
        while not HasModelLoaded(ped_hash) do
            Citizen.Wait(1)
        end
        SetPlayerModel(PlayerId(), ped_hash)
        SetPedDefaultComponentVariation(PlayerPedId())
        SetModelAsNoLongerNeeded(ped_hash)
    end
end)

-- Player leave notifications
RegisterNetEvent('shyMenu:dropped', function(name, reason, id)
    if Config.EnableLeaveNotifications then
        if onduty then
	        TriggerEvent('chat:addMessage', {
	        	template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(19,32,255, 0.6); border-radius: 3px;"><i class="fas fa-info"></i>  | <b>ID: {0} - {1}</b> has disconnected: {2}</div>',
	        	args = { id, name, reason }
	        })
        end
    end
end)