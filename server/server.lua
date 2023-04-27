ESX = nil
onduty = false
local Webhook = 'WEBHOOK'
local savedCoords   = {}

TriggerEvent('esx:getSharedObject', function(obj) 
    ESX = obj 
end)

RegisterCommand(Config.onDutyCommand, function(source, args, user)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local playername = xPlayer.getName()
    if IsPlayerAceAllowed(src, Config.AceGroup) then
		onduty = true
		TriggerClientEvent('shyMenu:syncduty', src, GetPlayerIdentifier(src, 0), playername)
        sendToDiscord(Config.Translations.dutytoggletitle, GetPlayerName(xPlayer.source).." "..Config.Translations.enterduty, 65359)
    end
end, true)

RegisterCommand(Config.offDutyCommand, function(source, args, user)
    local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
    local playername = xPlayer.getName()
    if IsPlayerAceAllowed(src, Config.AceGroup) then
        onduty = false
        TriggerClientEvent('shyMenu:resetduty', src, GetPlayerIdentifier(src, 0), playername)
		sendToDiscord(Config.Translations.dutytoggletitle, GetPlayerName(xPlayer.source).." "..Config.Translations.leaveduty, 16735311)
    end
end, true)

function sendToDiscord(name, message, color)
    local connect = {
          {
              ["color"] = color,
              ["title"] = "**".. name .."**",
              ["description"] = message,
              ["footer"] = {
                  ["text"] = "Made with <3 by Slashy#3200",
              },
          }
      }
    PerformHttpRequest(Webhook, function(err, text, headers) end, 'POST', json.encode({username = 'shyMenu', embeds = connect, avatar_url = 'https://static.vecteezy.com/system/resources/previews/006/428/710/original/cool-fox-with-sharp-eyes-mascot-logo-design-free-vector.jpg'}), { ['Content-Type'] = 'application/json' })
end
sendToDiscord("Script Restarted", "New logging session initialized.", 16711851)

-- Commands
RegisterCommand("goto", function(source, args, rawCommand)
    if IsPlayerAceAllowed(source, Config.AceGroup) then
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
                        sendToDiscord("/goto", GetPlayerName(xPlayer.source).." "..Config.Translations.teleportedto.." "..GetPlayerName(xTarget.source), 65359)
                        TriggerClientEvent('shyMenu:notify', source, Config.Translations.gototitle, Config.Translations.gotp, 'info')
              		else
                		TriggerClientEvent('shyMenu:notify', source, Config.Translations.gototitle, Config.Translations.offline, 'error')
              		end
            	else
                    TriggerClientEvent('shyMenu:notify', source, Config.Translations.gototitle, Config.Translations.invalid, 'error')
            	end
	        end
        else
            TriggerClientEvent('shyMenu:notify', source, Config.Translations.dutytitle, Config.Translations.offduty, "error")
        end
    else
        TriggerClientEvent('shyMenu:notify', source, Config.Translations.notstafftitle, Config.Translations.notstaff, "error")
    end
end, true)

RegisterCommand("goback", function(source, args, rawCommand)
    if IsPlayerAceAllowed(source, Config.AceGroup) then
        if onduty then
	        if source ~= 0 then
	          	local xPlayer = ESX.GetPlayerFromId(source)
	            local playerCoords = savedCoords[source]
	            if playerCoords then
	            	xPlayer.setCoords(playerCoords)
	        		TriggerClientEvent('shyMenu:notify', source, Config.Translations.gototitle, Config.Translations.backtp, 'info')
	            	savedCoords[source] = nil
	            else
                    TriggerClientEvent('shyMenu:notify', source, Config.Translations.gototitle, Config.Translations.coorderror, 'error')
	            end
	        end
        else
            TriggerClientEvent('shyMenu:notify', source, Config.Translations.dutytitle, Config.Translations.offduty, "error")
        end
    else
        TriggerClientEvent('shyMenu:notify', source, Config.Translations.notstafftitle, Config.Translations.notstaff, "error")
    end
end, true)

RegisterCommand("bring", function(source, args, rawCommand)
    if IsPlayerAceAllowed(source, Config.AceGroup) then
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
                        TriggerClientEvent('shyMenu:notify', source, Config.Translations.bringtitle, Config.Translations.bringplayer, 'info')
                        TriggerClientEvent('shyMenu:notify', xTarget.source, Config.Translations.stafftitle, Config.Translations.tptostaff, 'info')
                        sendToDiscord("/bring", GetPlayerName(xPlayer.source).." "..Config.Translations.brought.." "..GetPlayerName(xTarget.source), 65359)
              		else
                		TriggerClientEvent('shyMenu:notify', source, Config.Translations.bringtitle, Config.Translations.offline, 'error')
              		end
            	else
                    TriggerClientEvent('shyMenu:notify', source, Config.Translations.bringtitle, Config.Translations.invalid, 'error')
            	end
	        end
        else
            TriggerClientEvent('shyMenu:notify', source, Config.Translations.dutytitle, Config.Translations.offduty, "error")
        end
    else
        TriggerClientEvent('shyMenu:notify', source, Config.Translations.notstafftitle, Config.Translations.notstaff, "error")
    end
end, true)

RegisterCommand("bringfreezed", function(source, args, rawCommand)
    if IsPlayerAceAllowed(source, Config.AceGroup) then
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
                        TriggerClientEvent('shyMenu:notify', source, Config.Translations.bringtitle, Config.Translations.bringplayer, 'info')
                        TriggerClientEvent('shyMenu:notify', xTarget.source, Config.Translations.stafftitle, Config.Translations.tptostaff, 'info')
                        sendToDiscord("/bringfreezed", GetPlayerName(xPlayer.source).." "..Config.Translations.brought.." "..GetPlayerName(xTarget.source).." bevroren naar zich toe.", 65359)
                        Citizen.Wait(100)
                        FreezeEntityPosition(xTarget.source, true)
              		else
                		TriggerClientEvent('shyMenu:notify', source, Config.Translations.bringtitle, Config.Translations.offline, 'error')
              		end
            	else
                    TriggerClientEvent('shyMenu:notify', source, Config.Translations.bringtitle, Config.Translations.invalid, 'error')
            	end
	        end
        else
            TriggerClientEvent('shyMenu:notify', source, Config.Translations.dutytitle, Config.Translations.offduty, "error")
        end
    else
        TriggerClientEvent('shyMenu:notify', source, Config.Translations.notstafftitle, Config.Translations.notstaff, "error")
    end
end, true)

RegisterCommand("bringback", function(source, args, rawCommand)
    if IsPlayerAceAllowed(source, Config.AceGroup) then
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
                		TriggerClientEvent('shyMenu:notify', source, Config.Translations.bringtitle, Config.Translations.bringback, 'info')
                		TriggerClientEvent('shyMenu:notify', xTarget.source, Config.Translations.stafftitle, Config.Translations.tpback, 'info')
                		savedCoords[targetId] = nil
                	    else
                		    TriggerClientEvent('shyMenu:notify', source, Config.Translations.bringtitle, Config.Translations.couldnottp, 'error')
                	    end
              	    else
                		TriggerClientEvent('shyMenu:notify', source, Config.Translations.bringtitle, Config.Translations.offline, 'error')
              	    end
                else
                    TriggerClientEvent('shyMenu:notify', source, Config.Translations.bringtitle, Config.Translations.invalid, 'error')
                end
	        end
        else
            TriggerClientEvent('shyMenu:notify', source, Config.Translations.dutytitle, Config.Translations.offduty, "error")
        end
    else
        TriggerClientEvent('shyMenu:notify', source, Config.Translations.notstafftitle, Config.Translations.notstaff, "error")
    end
end, true)

RegisterCommand("coords", function(source, args, rawCommand)
    if IsPlayerAceAllowed(source, Config.AceGroup) then
	    if source ~= 0 then
	    	local xPlayer = ESX.GetPlayerFromId(source)
	    	print(GetEntityCoords(GetPlayerPed(source)))
	    end
    end
end, true)

RegisterCommand("heal", function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)
    if IsPlayerAceAllowed(source, Config.AceGroup) then
        if onduty then
            if args[1] and tonumber(args[1]) then
              	local targetId = tonumber(args[1])
              	local xTarget = ESX.GetPlayerFromId(targetId)
                TriggerClientEvent("shyMenu:heal", xTarget.source, targetId, true)
                TriggerClientEvent("esx_basicneeds:healPlayer", xTarget.source)
                TriggerClientEvent('shyMenu:notify', source, Config.Translations.healtitle, Config.Translations.heal.." ID: "..targetId, 'info')
                sendToDiscord("/heal", GetPlayerName(xPlayer.source).." "..Config.Translations.healed.." "..GetPlayerName(xTarget.source), 65359)
            else
                TriggerClientEvent("shyMenu:heal", source, xPlayer, false)
                TriggerClientEvent("esx_basicneeds:healPlayer", source)
                TriggerClientEvent('shyMenu:notify', source, Config.Translations.healtitle, Config.Translations.healself, 'info')
                sendToDiscord("/heal", GetPlayerName(xPlayer.source).." "..Config.Translations.healedself, 65359)
            end
        else
            TriggerClientEvent('shyMenu:notify', source, Config.Translations.dutytitle, Config.Translations.offduty, "error")
        end
    else
        TriggerClientEvent('shyMenu:notify', source, Config.Translations.notstafftitle, Config.Translations.notstaff, "error")
    end
end, true)

RegisterCommand("freeze", function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)
    if IsPlayerAceAllowed(source, Config.AceGroup) then
        if onduty then
            if args[1] and tonumber(args[1]) then
                local targetId = tonumber(args[1])
                local xTarget = ESX.GetPlayerFromId(targetId)
                FreezeEntityPosition(xTarget.source, true)
                TriggerClientEvent('shyMenu:notify', source, Config.Translations.freezetitle, Config.Translations.freezed.." ID: "..targetId, 'info')
                sendToDiscord("/freeze", GetPlayerName(xPlayer.source).." "..Config.Translations.froze.." "..GetPlayerName(xTarget.source), 65359)
            else
                TriggerClientEvent('shyMenu:notify', source, Config.Translations.freezetitle, Config.Translations.invalid, 'error')
            end
        else
            TriggerClientEvent('shyMenu:notify', source, Config.Translations.dutytitle, Config.Translations.offduty, "error")
        end
    else
        TriggerClientEvent('shyMenu:notify', source, Config.Translations.notstafftitle, Config.Translations.notstaff, "error")
    end
end, true)

RegisterCommand("unfreeze", function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)
    if IsPlayerAceAllowed(source, Config.AceGroup) then
        if onduty then
            if args[1] and tonumber(args[1]) then
                local targetId = tonumber(args[1])
                local xTarget = ESX.GetPlayerFromId(targetId)
                FreezeEntityPosition(xTarget.source, false)
                TriggerClientEvent('shyMenu:notify', source, Config.Translations.freezetitle, Config.Translations.unfreezed.." ID: "..targetId, 'info')
                sendToDiscord("/freeze", GetPlayerName(xPlayer.source).." "..Config.Translations.defroze.." "..GetPlayerName(xTarget.source), 65359)
            else
                TriggerClientEvent('shyMenu:notify', source, Config.Translations.freezetitle, Config.Translations.invalid, 'error')
            end
        else
            TriggerClientEvent('shyMenu:notify', source, Config.Translations.dutytitle, Config.Translations.offduty, "error")
        end
    else
        TriggerClientEvent('shyMenu:notify', source, Config.Translations.notstafftitle, Config.Translations.notstaff, "error")
    end
end, true)

RegisterCommand("car", function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)
    if IsPlayerAceAllowed(source, Config.AceGroup) then
        if onduty then
            if args[1] then
                local vehicle = args[1]
                xPlayer.triggerEvent('esx:spawnVehicle', vehicle)
                sendToDiscord("/car", GetPlayerName(xPlayer.source).." "..Config.Translations.carspawn.." "..vehicle, 65359)
            else
                TriggerClientEvent('shyMenu:notify', source, Config.Translations.cartitle, Config.Translations.invalid, 'error')
            end
        else
            TriggerClientEvent('shyMenu:notify', source, Config.Translations.dutytitle, Config.Translations.offduty, "error")
        end
    else
        TriggerClientEvent('shyMenu:notify', source, Config.Translations.notstafftitle, Config.Translations.notstaff, "error")
    end
end, true)

RegisterCommand("kill", function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)
    if IsPlayerAceAllowed(source, Config.AceGroup) then
        if onduty then
            if args[1] and tonumber(args[1]) then
              	local targetId = tonumber(args[1])
              	local xTarget = ESX.GetPlayerFromId(targetId)
                TriggerClientEvent("shyMenu:kill", xTarget.source, targetId)
                sendToDiscord("/kill", GetPlayerName(xPlayer.source).." "..Config.Translations.kill.." "..GetPlayerName(xTarget.source), 65359)
            end
        else
            TriggerClientEvent('shyMenu:notify', source, Config.Translations.dutytitle, Config.Translations.offduty, "error")
        end
    else
        TriggerClientEvent('shyMenu:notify', source, Config.Translations.notstafftitle, Config.Translations.notstaff, "error")
    end
end, true)

RegisterCommand('a', function(source, args, rawCommand)
    if IsPlayerAceAllowed(source, Config.AceGroup) then
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
    if IsPlayerAceAllowed(source, Config.AceGroup) then
        TriggerClientEvent('shyMenu:tpm', source)
	end
end, true)

RegisterCommand('fixveh', function(source, args, rawCommand)
    if IsPlayerAceAllowed(source, Config.AceGroup) then
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
			TriggerClientEvent('shyMenu:notify', source, Config.Translations.kicktitle, Config.Translations.invalid, 'error')
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
    	    TriggerClientEvent('shyMenu:notify', source, Config.Translations.notstafftitle, Config.Translations.notstaff, "error")
    	end
	end
end, true)

-- Server events (& handlers)
RegisterServerEvent('shyMenu:staffmoney')
AddEventHandler('shyMenu:staffmoney', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    if IsPlayerAceAllowed(source, Config.AceGroup) then
        xPlayer.addAccountMoney('bank', Config.StaffPayout)
        TriggerClientEvent('shyMenu:notify', source, Config.Translations.paytitle, Config.Translations.payday, 'success')
    end
end)

RegisterNetEvent('shyMenu:noClip')
AddEventHandler('shyMenu:noClip', function()
    if IsPlayerAceAllowed(source, Config.AceGroup) then
        if onduty then
            TriggerClientEvent('shyMenu:toggleNoClip', source)
        else
            TriggerClientEvent('shyMenu:notify', source, Config.Translations.dutytitle, Config.Translations.offduty, "error")
        end
    else
        TriggerClientEvent('shyMenu:notify', source, Config.Translations.notstafftitle, Config.Translations.notstaff, "error")
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