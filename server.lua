ESX = nil
local indienst = false
local count = 0

TriggerEvent('esx:getSharedObject', function(obj) 
    ESX = obj 
end)

RegisterCommand('staffdienst', function(source, args, user)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local playername = xPlayer.getName()

    if IsPlayerAceAllowed(src, "karneadmin") then
        TriggerClientEvent('karneadmin:syncdienst', src, GetPlayerIdentifier(src, 0), playername)
        indienst = not indienst
        if indienst then
            sendToDiscord("Staffdienst", GetPlayerName(xPlayer.source).." is in dienst gegaan als stafflid.", 65359)
            count = count + 1
        elseif not indienst then
            sendToDiscord("Staffdienst", GetPlayerName(xPlayer.source).." is uit dienst gegaan als stafflid.", 16735311)
            count = count - 1
        end
    else
        TriggerClientEvent('okokNotify:Alert', src, "Onvoldoende Rechten", "Helaas... Je bent geen staff!", 5000, 'error')
    end
end)

function sendToDiscord(name, message, color)
    local connect = {
          {
              ["color"] = color,
              ["title"] = "**".. name .."**",
              ["description"] = message,
              ["footer"] = {
                  ["text"] = "Gemaakt met liefde door je boy karnemelk",
              },
          }
      }
    PerformHttpRequest('INSERTYOURWEBHOOKHERE', function(err, text, headers) end, 'POST', json.encode({username = 'Karneadmin', embeds = connect, avatar_url = 'https://topmerken.superunie.nl/app/uploads/sites/3/2022/01/karnemelk-0-0ddb6576e575ca72e6b2741e3f146247-570x570.png'}), { ['Content-Type'] = 'application/json' })
end
sendToDiscord("KarneAdmin aan het opstarten...", "Karnelogging successfully started.", 16711851)
-- ADMIN SHIT BEGINT HIER OULEHH

RegisterNetEvent('karneadmin:noClip')
AddEventHandler('karneadmin:noClip', function()
    if IsPlayerAceAllowed(source, "karneadmin") and indienst then
        TriggerClientEvent('karneadmin:toggleNoClip', source)
        TriggerClientEvent('okokNotify:Alert', source, "Staff Noclip", "Noclip ingeschakeld.", 2000, 'info')
        sendToDiscord("/noclip", GetPlayerName(source).." heeft NoClip aangezet.", 65359)
    elseif IsPlayerAceAllowed(source, "karneadmin") and not indienst then
        TriggerClientEvent('okokNotify:Alert', source, "Staff Dienst", "Je bent niet in dienst!", 5000, 'error')
    else
        TriggerClientEvent('okokNotify:Alert', source, "Onvoldoende Rechten", "Helaas... Je bent geen staff!", 5000, 'error')
    end
end)

-------- EINDE VAN DIE KAULO NOCLIP VANAF HIER IETS ANDERS SWA

local savedCoords   = {}
RegisterCommand("goto", function(source, args, rawCommand)
    if IsPlayerAceAllowed(source, "karneadmin") and indienst then
	    if source ~= 0 then
  	    	local xPlayer = ESX.GetPlayerFromId(source)
        	if args[1] and tonumber(args[1]) then
          		local targetId = tonumber(args[1])
          		local xTarget = ESX.GetPlayerFromId(targetId)
          		if xTarget then
            		local targetCoords = xTarget.getCoords()
            		local playerCoords = xPlayer.getCoords()
            		savedCoords[source] = playerCoords
            		xPlayer.setCoords(targetCoords)
                    sendToDiscord("/goto", GetPlayerName(xPlayer.source).." is naar "..GetPlayerName(xTarget.source).." geteleporteerd.", 65359)
                    TriggerClientEvent('okokNotify:Alert', source, "Staff Goto", "Je werd geteleporteerd!", 5000, 'info')
          		else
            		TriggerClientEvent('okokNotify:Alert', source, "Staff Goto", "Deze identifier is niet online!", 3000, 'error')
          		end
        	else
                TriggerClientEvent('okokNotify:Alert', source, "Staff Goto", "Ongeldige invoer!", 3000, 'error')
        	end
	    end
    elseif IsPlayerAceAllowed(source, "karneadmin") and not indienst then
        TriggerClientEvent('okokNotify:Alert', source, "Staff Dienst", "Je bent niet in dienst!", 5000, 'error')
    else
        TriggerClientEvent('okokNotify:Alert', source, "Onvoldoende Rechten", "Helaas... Je bent geen staff!", 5000, 'error')
    end
end, true)

RegisterCommand("goback", function(source, args, rawCommand)
    if IsPlayerAceAllowed(source, "karneadmin") and indienst then
	    if source ~= 0 then
	      	local xPlayer = ESX.GetPlayerFromId(source)
	        local playerCoords = savedCoords[source]
	        if playerCoords then
	        	xPlayer.setCoords(playerCoords)
	    		TriggerClientEvent('okokNotify:Alert', source, "Staff Goto", "Je werd weer terug geteleporteerd!", 5000, 'info')
	        	savedCoords[source] = nil
	        else
                TriggerClientEvent('okokNotify:Alert', source, "Staff Goto", "Fout bij het ophalen van je oude coords!", 5000, 'error')
	        end
	    end
    elseif IsPlayerAceAllowed(source, "karneadmin") and not indienst then
        TriggerClientEvent('okokNotify:Alert', source, "Staff Dienst", "Je bent niet in dienst!", 5000, 'error')
    else
        TriggerClientEvent('okokNotify:Alert', source, "Onvoldoende Rechten", "Helaas... Je bent geen staff!", 5000, 'error')
    end
end, true)

-------- Einde van /goto & /goback

RegisterCommand("bring", function(source, args, rawCommand)
    if IsPlayerAceAllowed(source, "karneadmin") and indienst then
	    if source ~= 0 then
  	    	local xPlayer = ESX.GetPlayerFromId(source)
        	if args[1] and tonumber(args[1]) then
          		local targetId = tonumber(args[1])
          		local xTarget = ESX.GetPlayerFromId(targetId)
          		if xTarget then
            		local targetCoords = xTarget.getCoords()
            		local playerCoords = xPlayer.getCoords()
            		savedCoords[targetId] = targetCoords
            		xTarget.setCoords(playerCoords)
                    TriggerClientEvent('okokNotify:Alert', source, "Staff Bring", "Speler word opgehaald...", 5000, 'info')
                    TriggerClientEvent('okokNotify:Alert', xTarget.source, "Springbank Staff", "Je werd geteleporteerd naar een stafflid.", 5000, 'info')
                    sendToDiscord("/bring", GetPlayerName(xPlayer.source).." bracht "..GetPlayerName(xTarget.source).." naar zich toe.", 65359)
          		else
            		TriggerClientEvent('okokNotify:Alert', source, "Staff Bring", "Deze identifier is niet online!", 3000, 'error')
          		end
        	else
                TriggerClientEvent('okokNotify:Alert', source, "Staff Bring", "Ongeldige invoer!", 3000, 'error')
        	end
	    end
    elseif IsPlayerAceAllowed(source, "karneadmin") and not indienst then
        TriggerClientEvent('okokNotify:Alert', source, "Staff Dienst", "Je bent niet in dienst!", 5000, 'error')
    else
        TriggerClientEvent('okokNotify:Alert', source, "Onvoldoende Rechten", "Helaas... Je bent geen staff!", 5000, 'error')
    end
end, true)

RegisterCommand("bringfreezed", function(source, args, rawCommand)
    if IsPlayerAceAllowed(source, "karneadmin") and indienst then
	    if source ~= 0 then
  	    	local xPlayer = ESX.GetPlayerFromId(source)
        	if args[1] and tonumber(args[1]) then
          		local targetId = tonumber(args[1])
          		local xTarget = ESX.GetPlayerFromId(targetId)
          		if xTarget then
            		local targetCoords = xTarget.getCoords()
            		local playerCoords = xPlayer.getCoords()
            		savedCoords[targetId] = targetCoords
            		xTarget.setCoords(playerCoords)
                    TriggerClientEvent('okokNotify:Alert', source, "Staff Bring", "Speler word opgehaald en gefreezed...", 5000, 'info')
                    TriggerClientEvent('okokNotify:Alert', xTarget.source, "Springbank Staff", "Je werd geteleporteerd naar een stafflid.", 5000, 'info')
                    sendToDiscord("/bringfreezed", GetPlayerName(xPlayer.source).." bracht "..GetPlayerName(xTarget.source).." bevroren naar zich toe.", 65359)
                    Citizen.Wait(100)
                    FreezeEntityPosition(xTarget.source, true)
          		else
            		TriggerClientEvent('okokNotify:Alert', source, "Staff Bring", "Deze identifier is niet online!", 3000, 'error')
          		end
        	else
                TriggerClientEvent('okokNotify:Alert', source, "Staff Bring", "Ongeldige invoer!", 3000, 'error')
        	end
	    end
    elseif IsPlayerAceAllowed(source, "karneadmin") and not indienst then
        TriggerClientEvent('okokNotify:Alert', source, "Staff Dienst", "Je bent niet in dienst!", 5000, 'error')
    else
        TriggerClientEvent('okokNotify:Alert', source, "Onvoldoende Rechten", "Helaas... Je bent geen staff!", 5000, 'error')
    end
end, true)

RegisterCommand("bringback", function(source, args, rawCommand)
    if IsPlayerAceAllowed(source, "karneadmin") and indienst then
	    if source ~= 0 then
  	    	local xPlayer = ESX.GetPlayerFromId(source)
        	if args[1] and tonumber(args[1]) then
          		local targetId = tonumber(args[1])
          		local xTarget = ESX.GetPlayerFromId(targetId)
          		if xTarget then
            		local playerCoords = savedCoords[targetId]
            		if playerCoords then
                    FreezeEntityPosition(xTarget.source, false)
            		xTarget.setCoords(playerCoords)
            		TriggerClientEvent('okokNotify:Alert', source, "Staff Bring", "Speler terug geteleporteerd!", 5000, 'info')
            		TriggerClientEvent('okokNotify:Alert', xTarget.source, "Springbank Staff", "Je wordt terug geteleporteerd...", 5000, 'info')
            		savedCoords[targetId] = nil
            	    else
            		    TriggerClientEvent('okokNotify:Alert', source, "Staff Bring", "Speler kon niet terug worden geteleporteerd.", 5000, 'error')
            	    end
          	    else
            		TriggerClientEvent('okokNotify:Alert', source, "Staff Bring", "Deze identifier is niet online!", 3000, 'error')
          	    end
            else
                TriggerClientEvent('okokNotify:Alert', source, "Staff Bring", "Ongeldige invoer!", 3000, 'error')
            end
	    end
    elseif IsPlayerAceAllowed(source, "karneadmin") and not indienst then
        TriggerClientEvent('okokNotify:Alert', source, "Staff Dienst", "Je bent niet in dienst!", 5000, 'error')
    else
        TriggerClientEvent('okokNotify:Alert', source, "Onvoldoende Rechten", "Helaas... Je bent geen staff!", 5000, 'error')
    end
end, true)

------ Einde van /bring, /bringfreezed & /bringback

RegisterCommand("coords", function(source, args, rawCommand)
    if IsPlayerAceAllowed(source, "karneadmin") then
	    if source ~= 0 then
	    	local xPlayer = ESX.GetPlayerFromId(source)
	    	print(GetEntityCoords(GetPlayerPed(source)))
	    end
    end
end, false)

RegisterCommand("heal", function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)
    if IsPlayerAceAllowed(source, "karneadmin") and indienst then
        if args[1] and tonumber(args[1]) then
          	local targetId = tonumber(args[1])
          	local xTarget = ESX.GetPlayerFromId(targetId)
            TriggerClientEvent("karneheal", xTarget.source, targetId, true)
            TriggerClientEvent('okokNotify:Alert', source, "Staff Heal", "Je hebt [ID: "..targetId.."] gehealed!", 5000, 'info')
            sendToDiscord("/heal", GetPlayerName(xPlayer.source).." heeft "..GetPlayerName(xTarget.source).." gehealed.", 65359)
        else
            TriggerClientEvent("karneheal", source, xPlayer, false)
            TriggerClientEvent("esx_basicneeds:healPlayer", source)
            TriggerClientEvent('okokNotify:Alert', source, "Staff Heal", "Je hebt jezelf gehealed!", 5000, 'info')
            sendToDiscord("/heal", GetPlayerName(xPlayer.source).." heeft zichzelf gehealed.", 65359)
        end
    elseif IsPlayerAceAllowed(source, "karneadmin") and not indienst then
        TriggerClientEvent('okokNotify:Alert', source, "Staff Dienst", "Je bent niet in dienst!", 5000, 'error')
    else
        TriggerClientEvent('okokNotify:Alert', source, "Onvoldoende Rechten", "Helaas... Je bent geen staff!", 5000, 'error')
    end
end, true)

-- RegisterCommand("revive", function(source, args, rawCommand)
--     local xPlayer = ESX.GetPlayerFromId(source)
--     if IsPlayerAceAllowed(source, "karneadmin") and indienst then
--         if args[1] and tonumber(args[1]) then
--           	local targetId = tonumber(args[1])
--           	local xTarget = ESX.GetPlayerFromId(targetId)
--             TriggerEvent("esx_ambulancejob:revive", xTarget.source)
--             TriggerClientEvent('okokNotify:Alert', source, "Staff Revive", "Je hebt [ID: "..targetId.."] gerevived!", 5000, 'info')
--             sendToDiscord("/revive", GetPlayerName(xPlayer.source).." heeft "..GetPlayerName(xTarget.source).." gerevived.", 65359)
--         else
--             TriggerEvent("esx_ambulancejob:revive", source)
--             TriggerClientEvent('okokNotify:Alert', source, "Staff Revive", "Je hebt jezelf gerevived!", 5000, 'info')
--             sendToDiscord("/revive", GetPlayerName(xPlayer.source).." heeft zichzelf gerevived.", 65359)
--         end
--     elseif IsPlayerAceAllowed(source, "karneadmin") and not indienst then
--         TriggerClientEvent('okokNotify:Alert', source, "Staff Dienst", "Je bent niet in dienst!", 5000, 'error')
--     else
--         TriggerClientEvent('okokNotify:Alert', source, "Onvoldoende Rechten", "Helaas... Je bent geen staff!", 5000, 'error')
--     end
-- end, true)

RegisterCommand("freeze", function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)
    if IsPlayerAceAllowed(source, "karneadmin") and indienst then
        if args[1] and tonumber(args[1]) then
            local targetId = tonumber(args[1])
            local xTarget = ESX.GetPlayerFromId(targetId)
            FreezeEntityPosition(xTarget.source, true)
            TriggerClientEvent('okokNotify:Alert', source, "Staff Freeze", "Je hebt [ID: "..targetId.."] gefreezed!", 5000, 'info')
            sendToDiscord("/freeze", GetPlayerName(xPlayer.source).." heeft "..GetPlayerName(xTarget.source).." gefreezed.", 65359)
        else
            TriggerClientEvent('okokNotify:Alert', source, "Staff Freeze", "Specificeer een speler, a.u.b.", 5000, 'error')
        end
    elseif IsPlayerAceAllowed(source, "karneadmin") and not indienst then
        TriggerClientEvent('okokNotify:Alert', source, "Staff Dienst", "Je bent niet in dienst!", 5000, 'error')
    else
        TriggerClientEvent('okokNotify:Alert', source, "Onvoldoende Rechten", "Helaas... Je bent geen staff!", 5000, 'error')
    end
end, true)

RegisterCommand("unfreeze", function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)
    if IsPlayerAceAllowed(source, "karneadmin") and indienst then
        if args[1] and tonumber(args[1]) then
            local targetId = tonumber(args[1])
            local xTarget = ESX.GetPlayerFromId(targetId)
            FreezeEntityPosition(xTarget.source, false)
            TriggerClientEvent('okokNotify:Alert', source, "Staff Freeze", "Je hebt [ID: "..targetId.."] geunfreezed!", 5000, 'info')
            sendToDiscord("/freeze", GetPlayerName(xPlayer.source).." heeft "..GetPlayerName(xTarget.source).." geunfreezed.", 65359)
        else
            TriggerClientEvent('okokNotify:Alert', source, "Staff Freeze", "Specificeer een speler, a.u.b.", 5000, 'error')
        end
    elseif IsPlayerAceAllowed(source, "karneadmin") and not indienst then
        TriggerClientEvent('okokNotify:Alert', source, "Staff Dienst", "Je bent niet in dienst!", 5000, 'error')
    else
        TriggerClientEvent('okokNotify:Alert', source, "Onvoldoende Rechten", "Helaas... Je bent geen staff!", 5000, 'error')
    end
end, true)
--- End of /heal /revive /coords /freeze
onlinePlayers = {}

RegisterServerEvent('karne-showid:add-id')
AddEventHandler('karne-showid:add-id', function()
    if IsPlayerAceAllowed(source, "karneadmin") and indienst then
        TriggerClientEvent("karne-showid:client:add-id", source, onlinePlayers)
        local topText = GetPlayerName(source)
        local identifiers = GetPlayerIdentifiers(source)
        onlinePlayers[tostring(source)] = topText
        TriggerClientEvent("karne-showid:client:add-id", -1, topText, tostring(source))
    end
end)

AddEventHandler('playerDropped', function(reason)
    onlinePlayers[tostring(source)] = nil
end)

--- End of names

RegisterCommand("car", function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)
    if IsPlayerAceAllowed(source, "karneadmin") and indienst then
        if args[1] then
            local vehicle = args[1]
            xPlayer.triggerEvent('esx:spawnVehicle', vehicle)
            sendToDiscord("/car", GetPlayerName(xPlayer.source).." heeft een "..vehicle.." ingespawned.", 65359)
        else
            TriggerClientEvent('okokNotify:Alert', source, "Staff Vehicle", "Specificeer een model, a.u.b.", 5000, 'error')
        end
    elseif IsPlayerAceAllowed(source, "karneadmin") and not indienst then
        TriggerClientEvent('okokNotify:Alert', source, "Staff Dienst", "Je bent niet in dienst!", 5000, 'error')
    else
        TriggerClientEvent('okokNotify:Alert', source, "Onvoldoende Rechten", "Helaas... Je bent geen staff!", 5000, 'error')
    end
end, true)

---- End of veh

RegisterCommand("blips", function(source, args, rawCommand)
    if IsPlayerAceAllowed(source, "karneadmin") and indienst then
        TriggerClientEvent('karneblips', source)
        sendToDiscord("/blips", GetPlayerName(source).." heeft blips aangezet", 65359)
        TriggerClientEvent('okokNotify:Alert', source, "Staff Blips", "Blips aangezet!", 5000, 'info')
    elseif IsPlayerAceAllowed(source, "karneadmin") and not indienst then
        TriggerClientEvent('okokNotify:Alert', source, "Staff Dienst", "Je bent niet in dienst!", 5000, 'error')
    else
        TriggerClientEvent('okokNotify:Alert', source, "Onvoldoende Rechten", "Helaas... Je bent geen staff!", 5000, 'error')
    end
end, true)

RegisterCommand('staffonline', function(source, args, rawCommand)
    if IsPlayerAceAllowed(source, "karneadmin") then
        TriggerClientEvent('okokNotify:Alert', source, "Staff in Dienst", "Staff in dienst: "..count, 5000, 'info')
    else
        TriggerClientEvent('okokNotify:Alert', source, "Onvoldoende Rechten", "Helaas... Je bent geen staff!", 5000, 'error')
    end
end, true)

RegisterCommand("skin", function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)
    if IsPlayerAceAllowed(source, "karneadmin") and indienst then
        if args[1] and tonumber(args[1]) then
          	local targetId = tonumber(args[1])
          	local xTarget = ESX.GetPlayerFromId(targetId)
            TriggerClientEvent("esx_skin:openSaveableMenu", xTarget.source)
            TriggerClientEvent('okokNotify:Alert', source, "Staff Skin", "Je hebt [ID: "..targetId.."] een skin menu gegeven!", 5000, 'info')
            sendToDiscord("/skin", GetPlayerName(xPlayer.source).." heeft "..GetPlayerName(xTarget.source).." een skin menu gegeven.", 65359)
        else
            TriggerClientEvent("esx_skin:openSaveableMenu", source)
            TriggerClientEvent('okokNotify:Alert', source, "Staff Heal", "Je hebt jezelf een skin menu gegeven!", 5000, 'info')
            sendToDiscord("/skin", GetPlayerName(xPlayer.source).." heeft zichzelf een skin menu gegeven.", 65359)
        end
    elseif IsPlayerAceAllowed(source, "karneadmin") and not indienst then
        TriggerClientEvent('okokNotify:Alert', source, "Staff Dienst", "Je bent niet in dienst!", 5000, 'error')
    else
        TriggerClientEvent('okokNotify:Alert', source, "Onvoldoende Rechten", "Helaas... Je bent geen staff!", 5000, 'error')
    end
end, true)