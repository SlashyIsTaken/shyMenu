ESX = nil
onduty = false
local savedCoords   = {}

TriggerEvent('esx:getSharedObject', function(obj) 
    ESX = obj 
end)

RegisterCommand(Config.DutyCommand, function(source, args, user)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local playername = xPlayer.getName()
    if IsPlayerAceAllowed(src, Config.AceGroup) then
		onduty = true
		TriggerClientEvent('karneadmin:syncduty', src, GetPlayerIdentifier(src, 0), playername)
        sendToDiscord("Staffdienst", GetPlayerName(xPlayer.source).." is in dienst gegaan als stafflid.", 65359)
    end
end, true)

RegisterCommand(Config.offDutyCommand, function(source, args, user)
    local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
    local playername = xPlayer.getName()
    if IsPlayerAceAllowed(src, Config.AceGroup) then
        onduty = false
        TriggerClientEvent('karneadmin:resetduty', src, GetPlayerIdentifier(src, 0), playername)
		sendToDiscord("Staffdienst", GetPlayerName(xPlayer.source).." is uit dienst gegaan als stafflid.", 16735311)
    end
end, true)

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
    PerformHttpRequest('YOUR WEBHOOK LINK HERE', function(err, text, headers) end, 'POST', json.encode({username = 'Karneadmin', embeds = connect, avatar_url = 'https://topmerken.superunie.nl/app/uploads/sites/3/2022/01/karnemelk-0-0ddb6576e575ca72e6b2741e3f146247-570x570.png'}), { ['Content-Type'] = 'application/json' })
end
sendToDiscord("KarneAdmin aan het opstarten...", "Karnelogging successfully started.", 16711851)

-- Commands
RegisterCommand("goto", function(source, args, rawCommand)
    if IsPlayerAceAllowed(src, Config.AceGroup) then
        if onduty then
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
        else
            TriggerClientEvent('okokNotify:Alert', source, "Staff Dienst", "Je bent niet in dienst!", 5000, 'error')
        end
    else
        TriggerClientEvent('okokNotify:Alert', source, "Onvoldoende Rechten", "Helaas... Je bent geen staff!", 5000, 'error')
    end
end, true)

RegisterCommand("goback", function(source, args, rawCommand)
    if IsPlayerAceAllowed(src, Config.AceGroup) then
        if onduty then
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
        else
            TriggerClientEvent('okokNotify:Alert', source, "Staff Dienst", "Je bent niet in dienst!", 5000, 'error')
        end
    else
        TriggerClientEvent('okokNotify:Alert', source, "Onvoldoende Rechten", "Helaas... Je bent geen staff!", 5000, 'error')
    end
end, true)

RegisterCommand("bring", function(source, args, rawCommand)
    if IsPlayerAceAllowed(src, Config.AceGroup) then
        if onduty then
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
        else
            TriggerClientEvent('okokNotify:Alert', source, "Staff Dienst", "Je bent niet in dienst!", 5000, 'error')
        end
    else
        TriggerClientEvent('okokNotify:Alert', source, "Onvoldoende Rechten", "Helaas... Je bent geen staff!", 5000, 'error')
    end
end, true)

RegisterCommand("bringfreezed", function(source, args, rawCommand)
    if IsPlayerAceAllowed(src, Config.AceGroup) then
        if onduty then
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
        else
            TriggerClientEvent('okokNotify:Alert', source, "Staff Dienst", "Je bent niet in dienst!", 5000, 'error')
        end
    else
        TriggerClientEvent('okokNotify:Alert', source, "Onvoldoende Rechten", "Helaas... Je bent geen staff!", 5000, 'error')
    end
end, true)

RegisterCommand("bringback", function(source, args, rawCommand)
    if IsPlayerAceAllowed(src, Config.AceGroup) then
        if onduty then
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
        else
            TriggerClientEvent('okokNotify:Alert', source, "Staff Dienst", "Je bent niet in dienst!", 5000, 'error')
        end
    else
        TriggerClientEvent('okokNotify:Alert', source, "Onvoldoende Rechten", "Helaas... Je bent geen staff!", 5000, 'error')
    end
end, true)

RegisterCommand("coords", function(source, args, rawCommand)
    if IsPlayerAceAllowed(src, Config.AceGroup) then
	    if source ~= 0 then
	    	local xPlayer = ESX.GetPlayerFromId(source)
	    	print(GetEntityCoords(GetPlayerPed(source)))
	    end
    end
end, true)

RegisterCommand("heal", function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)
    if IsPlayerAceAllowed(src, Config.AceGroup) then
        if onduty then
            if args[1] and tonumber(args[1]) then
              	local targetId = tonumber(args[1])
              	local xTarget = ESX.GetPlayerFromId(targetId)
                TriggerClientEvent("shyMenu:heal", xTarget.source, targetId, true)
                TriggerClientEvent("esx_basicneeds:healPlayer", xTarget.source)
                TriggerClientEvent('okokNotify:Alert', source, "Staff Heal", "Je hebt [ID: "..targetId.."] gehealed!", 5000, 'info')
                sendToDiscord("/heal", GetPlayerName(xPlayer.source).." heeft "..GetPlayerName(xTarget.source).." gehealed.", 65359)
            else
                TriggerClientEvent("shyMenu:heal", source, xPlayer, false)
                TriggerClientEvent("esx_basicneeds:healPlayer", source)
                TriggerClientEvent('okokNotify:Alert', source, "Staff Heal", "Je hebt jezelf gehealed!", 5000, 'info')
                sendToDiscord("/heal", GetPlayerName(xPlayer.source).." heeft zichzelf gehealed.", 65359)
            end
        else
            TriggerClientEvent('okokNotify:Alert', source, "Staff Dienst", "Je bent niet in dienst!", 5000, 'error')
        end
    else
        TriggerClientEvent('okokNotify:Alert', source, "Onvoldoende Rechten", "Helaas... Je bent geen staff!", 5000, 'error')
    end
end, true)

RegisterCommand("freeze", function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)
    if IsPlayerAceAllowed(src, Config.AceGroup) then
        if onduty then
            if args[1] and tonumber(args[1]) then
                local targetId = tonumber(args[1])
                local xTarget = ESX.GetPlayerFromId(targetId)
                FreezeEntityPosition(xTarget.source, true)
                TriggerClientEvent('okokNotify:Alert', source, "Staff Freeze", "Je hebt [ID: "..targetId.."] gefreezed!", 5000, 'info')
                sendToDiscord("/freeze", GetPlayerName(xPlayer.source).." heeft "..GetPlayerName(xTarget.source).." gefreezed.", 65359)
            else
                TriggerClientEvent('okokNotify:Alert', source, "Staff Freeze", "Specificeer een speler, a.u.b.", 5000, 'error')
            end
        else
            TriggerClientEvent('okokNotify:Alert', source, "Staff Dienst", "Je bent niet in dienst!", 5000, 'error')
        end
    else
        TriggerClientEvent('okokNotify:Alert', source, "Onvoldoende Rechten", "Helaas... Je bent geen staff!", 5000, 'error')
    end
end, true)

RegisterCommand("unfreeze", function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)
    if IsPlayerAceAllowed(src, Config.AceGroup) then
        if onduty then
            if args[1] and tonumber(args[1]) then
                local targetId = tonumber(args[1])
                local xTarget = ESX.GetPlayerFromId(targetId)
                FreezeEntityPosition(xTarget.source, false)
                TriggerClientEvent('okokNotify:Alert', source, "Staff Freeze", "Je hebt [ID: "..targetId.."] geunfreezed!", 5000, 'info')
                sendToDiscord("/freeze", GetPlayerName(xPlayer.source).." heeft "..GetPlayerName(xTarget.source).." geunfreezed.", 65359)
            else
                TriggerClientEvent('okokNotify:Alert', source, "Staff Freeze", "Specificeer een speler, a.u.b.", 5000, 'error')
            end
        else
            TriggerClientEvent('okokNotify:Alert', source, "Staff Dienst", "Je bent niet in dienst!", 5000, 'error')
        end
    else
        TriggerClientEvent('okokNotify:Alert', source, "Onvoldoende Rechten", "Helaas... Je bent geen staff!", 5000, 'error')
    end
end, true)

RegisterCommand("car", function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)
    if IsPlayerAceAllowed(src, Config.AceGroup) then
        if onduty then
            if args[1] then
                local vehicle = args[1]
                xPlayer.triggerEvent('esx:spawnVehicle', vehicle)
                sendToDiscord("/car", GetPlayerName(xPlayer.source).." heeft een "..vehicle.." ingespawned.", 65359)
            else
                TriggerClientEvent('okokNotify:Alert', source, "Staff Vehicle", "Specificeer een model, a.u.b.", 5000, 'error')
            end
        else
            TriggerClientEvent('okokNotify:Alert', source, "Staff Dienst", "Je bent niet in dienst!", 5000, 'error')
        end
    else
        TriggerClientEvent('okokNotify:Alert', source, "Onvoldoende Rechten", "Helaas... Je bent geen staff!", 5000, 'error')
    end
end, true)

RegisterCommand("kill", function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)
    if IsPlayerAceAllowed(src, Config.AceGroup) then
        if onduty then
            if args[1] and tonumber(args[1]) then
              	local targetId = tonumber(args[1])
              	local xTarget = ESX.GetPlayerFromId(targetId)
                TriggerClientEvent("karnekill", xTarget.source, targetId)
                sendToDiscord("/kill", GetPlayerName(xPlayer.source).." heeft "..GetPlayerName(xTarget.source).." gekilled.", 65359)
            end
        else
            TriggerClientEvent('okokNotify:Alert', source, "Staff Dienst", "Je bent niet in dienst!", 5000, 'error')
        end
    else
        TriggerClientEvent('okokNotify:Alert', source, "Onvoldoende Rechten", "Helaas... Je bent geen staff!", 5000, 'error')
    end
end, true)

RegisterCommand('a', function(source, args, rawCommand)
    if IsPlayerAceAllowed(src, Config.AceGroup) then
        local players = ESX.GetPlayers()
        for i = 1, #players do
            local player = ESX.GetPlayerFromId(players[i])
            if IsPlayerAceAllowed(players[i], Config.AceGroup) then
                TriggerClientEvent('shyMenu:adminchat', players[i], player, GetPlayerName(source), table.concat(args, " "))
            end
		end
	end
end, true)

RegisterCommand('tpm', function(source, args, rawCommand)
    if IsPlayerAceAllowed(src, Config.AceGroup) then
        TriggerClientEvent('shyMenu:tpm', source)
	end
end, true)

RegisterCommand('fixveh', function(source, args, rawCommand)
    if IsPlayerAceAllowed(src, Config.AceGroup) then
        TriggerClientEvent('shyMenu:fixveh', source)
	end
end, true)

RegisterCommand('kick', function(source, args, rawCommand)
	if IsPlayerAceAllowed(source, Config.AceGroup) then
		if args[3] and tonumber(args[1]) then
			local targetid = table.remove(args, 1)
			local xPlayer = ESX.GetPlayerFromId(targetid)
			xPlayer.kick(table.concat(args, " "))
		else
			TriggerClientEvent('okokNotify:Alert', source, "Hmmm...", "Specificeer een ID, en geef een kick reden op!", 5000, 'error')
		end
	end
end, true)

RegisterCommand("changeped", function(source, args, rawCommand)
	if Config.EnablePedMenu then
    	local xPlayer = ESX.GetPlayerFromId(source)
    	if IsPlayerAceAllowed(source, Config.AceGroup) then
    	    if args[1] and tonumber(args[1]) and args[2] then
    	      	local targetId = tonumber(args[1])
				local pedHash = args[2]
    	      	local xTarget = ESX.GetPlayerFromId(targetId)
    	        TriggerClientEvent('shyMenu:changePed', targetId, pedHash)
    	    end
    	else
    	    TriggerClientEvent('okokNotify:Alert', source, "Onvoldoende Rechten", "Helaas... Je bent geen staff!", 5000, 'error')
    	end
	end
end, true)

RegisterCommand('setfuel', function(source, args, rawCommand)
    if IsPlayerAceAllowed(source, Config.AceGroup) then
        local veh = GetVehiclePedIsIn(GetPlayerPed(args[1]), false)
        local amount = (tonumber(args[2]) + 0.0)
        if veh ~= 0 and amount <= 100 and amount > 0 then
            Entity(veh).state.fuel = amount
        end
    end
end)

-- Server events (& handlers)
RegisterServerEvent('shyMenu:staffmoney')
AddEventHandler('shyMenu:staffmoney', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    if IsPlayerAceAllowed(source, Config.AceGroup) then
        xPlayer.addAccountMoney('bank', Config.StaffPayout)
        TriggerClientEvent('okokNotify:Alert', source, "Topper", "Je bent een topper. Je kreeg je staffbonus van 1000 Euro.", 5000, 'success')
    end
end)

RegisterNetEvent('shyMenu:noClip')
AddEventHandler('shyMenu:noClip', function()
    if IsPlayerAceAllowed(src, Config.AceGroup) then
        if onduty then
            TriggerClientEvent('shyMenu:toggleNoClip', source)
        else
            TriggerClientEvent('okokNotify:Alert', source, "Staff Dienst", "Je bent niet in dienst!", 5000, 'error')
        end
    else
        TriggerClientEvent('okokNotify:Alert', source, "Onvoldoende Rechten", "Helaas... Je bent geen staff!", 5000, 'error')
    end
end)

AddEventHandler('playerDropped', function(reason)
	local players = ESX.GetPlayers()
	if #reason > 2 then
    	for i = 1, #players do
    	    local player = ESX.GetPlayerFromId(players[i])
    	    if IsPlayerAceAllowed(players[i], Config.AceGroup) then
    	        TriggerClientEvent('shyMenu:dropped', players[i], GetPlayerName(source), reason, source)
    	    end
		end
	end
end)