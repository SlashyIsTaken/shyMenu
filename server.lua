ESX = nil
local indienst = false
local count = 0

TriggerEvent('esx:getSharedObject', function(obj) 
    ESX = obj 
end)

RegisterCommand('instaff', function(source, args, user)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local playername = xPlayer.getName()
    if IsPlayerAceAllowed(src, "karneadmin") then
		indienst = true
		count = count + 1
		TriggerClientEvent('karneadmin:syncdienst', src, GetPlayerIdentifier(src, 0), playername)
        sendToDiscord("Staffdienst", GetPlayerName(xPlayer.source).." is in dienst gegaan als stafflid.", 65359)
    end
end, true)

RegisterCommand('uitstaff', function(source, args, user)
    local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
    local playername = xPlayer.getName()
    if IsPlayerAceAllowed(src, "karneadmin") then
        indienst = false
		count = count - 1
        TriggerClientEvent('karneadmin:resetdienst', src, GetPlayerIdentifier(src, 0), playername)
		sendToDiscord("Staffdienst", GetPlayerName(xPlayer.source).." is uit dienst gegaan als stafflid.", 16735311)
    end
end, true)

AddEventHandler('playerDropped', function(reason)
    if indienst then
		count = count - 1
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
    PerformHttpRequest('YOUR WEBHOOK LINK HERE', function(err, text, headers) end, 'POST', json.encode({username = 'Karneadmin', embeds = connect, avatar_url = 'https://topmerken.superunie.nl/app/uploads/sites/3/2022/01/karnemelk-0-0ddb6576e575ca72e6b2741e3f146247-570x570.png'}), { ['Content-Type'] = 'application/json' })
end
sendToDiscord("KarneAdmin aan het opstarten...", "Karnelogging successfully started.", 16711851)
-- ADMIN SHIT BEGINT HIER OULEHH

RegisterNetEvent('karneadmin:noClip')
AddEventHandler('karneadmin:noClip', function()
    if IsPlayerAceAllowed(source, "karneadmin") then
        if indienst then
            TriggerClientEvent('karneadmin:toggleNoClip', source)
        else
            TriggerClientEvent('okokNotify:Alert', source, "Staff Dienst", "Je bent niet in dienst!", 5000, 'error')
        end
    else
        TriggerClientEvent('okokNotify:Alert', source, "Onvoldoende Rechten", "Helaas... Je bent geen staff!", 5000, 'error')
    end
end)

-------- EINDE VAN DIE KAULO NOCLIP VANAF HIER IETS ANDERS SWA

local savedCoords   = {}
RegisterCommand("goto", function(source, args, rawCommand)
    if IsPlayerAceAllowed(source, "karneadmin") then
        if indienst then
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
    if IsPlayerAceAllowed(source, "karneadmin") then
        if indienst then
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

-------- Einde van /goto & /goback

RegisterCommand("bring", function(source, args, rawCommand)
    if IsPlayerAceAllowed(source, "karneadmin") then
        if indienst then
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
    if IsPlayerAceAllowed(source, "karneadmin") then
        if indienst then
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
    if IsPlayerAceAllowed(source, "karneadmin") then
        if indienst then
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

------ Einde van /bring, /bringfreezed & /bringback

RegisterCommand("coords", function(source, args, rawCommand)
    if IsPlayerAceAllowed(source, "karneadmin") then
	    if source ~= 0 then
	    	local xPlayer = ESX.GetPlayerFromId(source)
	    	print(GetEntityCoords(GetPlayerPed(source)))
	    end
    end
end, true)

RegisterCommand("heal", function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)
    if IsPlayerAceAllowed(source, "karneadmin") then
        if indienst then
            if args[1] and tonumber(args[1]) then
              	local targetId = tonumber(args[1])
              	local xTarget = ESX.GetPlayerFromId(targetId)
                TriggerClientEvent("karneheal", xTarget.source, targetId, true)
                TriggerClientEvent("esx_basicneeds:healPlayer", xTarget.source)
                TriggerClientEvent('okokNotify:Alert', source, "Staff Heal", "Je hebt [ID: "..targetId.."] gehealed!", 5000, 'info')
                sendToDiscord("/heal", GetPlayerName(xPlayer.source).." heeft "..GetPlayerName(xTarget.source).." gehealed.", 65359)
            else
                TriggerClientEvent("karneheal", source, xPlayer, false)
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
    if IsPlayerAceAllowed(source, "karneadmin") then
        if indienst then
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
    if IsPlayerAceAllowed(source, "karneadmin") then
        if indienst then
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
--- End of /heal /revive /coords /freeze
-- onlinePlayers = {}

-- RegisterServerEvent('karne-showid:add-id')
-- AddEventHandler('karne-showid:add-id', function()
--     if IsPlayerAceAllowed(source, "karneadmin") then
--         if indienst then
--             TriggerClientEvent("karne-showid:client:add-id", source, onlinePlayers)
--             local topText = GetPlayerName(source)
--             local identifiers = GetPlayerIdentifiers(source)
--             onlinePlayers[tostring(source)] = topText
--             TriggerClientEvent("karne-showid:client:add-id", -1, topText, tostring(source))
--         end
--     end
-- end)

-- AddEventHandler('playerDropped', function(reason)
--     onlinePlayers[tostring(source)] = nil
-- end)

--- End of names

RegisterCommand("car", function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)
    if IsPlayerAceAllowed(source, "karneadmin") then
        if indienst then
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

---- End of veh

RegisterCommand("blips", function(source, args, rawCommand)
    if IsPlayerAceAllowed(source, "karneadmin") then
        if indienst then
            TriggerClientEvent('karneblips', source)
            sendToDiscord("/blips", GetPlayerName(source).." heeft blips aangezet", 65359)
            TriggerClientEvent('okokNotify:Alert', source, "Staff Blips", "Blips aan/uit gezet!", 5000, 'info')
        else
            TriggerClientEvent('okokNotify:Alert', source, "Staff Dienst", "Je bent niet in dienst!", 5000, 'error')
        end
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
    if IsPlayerAceAllowed(source, "karneadmin") then
        if indienst then
            if args[1] and tonumber(args[1]) then
              	local targetId = tonumber(args[1])
              	local xTarget = ESX.GetPlayerFromId(targetId)
                TriggerClientEvent("esx_skin:openSaveableMenu", xTarget.source)
                TriggerClientEvent('okokNotify:Alert', source, "Staff Skin", "Je hebt [ID: "..targetId.."] een skin menu gegeven!", 5000, 'info')
                sendToDiscord("/skin", GetPlayerName(xPlayer.source).." heeft "..GetPlayerName(xTarget.source).." een skin menu gegeven.", 65359)
            else
                TriggerClientEvent("esx_skin:openSaveableMenu", source)
                TriggerClientEvent('okokNotify:Alert', source, "Staff Skin", "Je hebt jezelf een skin menu gegeven!", 5000, 'info')
                sendToDiscord("/skin", GetPlayerName(xPlayer.source).." heeft zichzelf een skin menu gegeven.", 65359)
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
    if IsPlayerAceAllowed(source, "karneadmin") then
        if indienst then
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

RegisterServerEvent('karnemelk:dikgeldverdienen')
AddEventHandler('karnemelk:dikgeldverdienen', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    if IsPlayerAceAllowed(source, "karneadmin") then
        xPlayer.addAccountMoney('bank', 1000)
        TriggerClientEvent('okokNotify:Alert', source, "Topper", "Je bent een topper. Je kreeg je staffbonus van 1000 Euro.", 5000, 'success')
    end
end)

-- showinv

RegisterCommand("bekijkinv", function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)
    if IsPlayerAceAllowed(source, "karneadmin") then
        if indienst then
            if args[1] and tonumber(args[1]) then
              	local targetId = tonumber(args[1])
              	local xTarget = ESX.GetPlayerFromId(targetId)
                TriggerClientEvent("karneinv", source, targetId)
                sendToDiscord("/bekijkinv", GetPlayerName(xPlayer.source).." heeft "..GetPlayerName(xTarget.source).." zijn inventory bekeken.", 65359)
            end
        else
            TriggerClientEvent('okokNotify:Alert', source, "Staff Dienst", "Je bent niet in dienst!", 5000, 'error')
        end
    else
        TriggerClientEvent('okokNotify:Alert', source, "Onvoldoende Rechten", "Helaas... Je bent geen staff!", 5000, 'error')
    end
end, true)

ESX.RegisterServerCallback('karnemelk:getOtherPlayerData', function(source, cb, target)
	local xPlayer = ESX.GetPlayerFromId(target)
	local result = MySQL.Sync.fetchAll('SELECT firstname, lastname, sex, dateofbirth, height, job FROM users WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	})
	local firstname = result[1].firstname
	local lastname  = result[1].lastname
	local sex       = result[1].sex
	local dob       = result[1].dateofbirth
	local height    = result[1].height
    local job       = result[1].job
	local data = {
		name      = GetPlayerName(target),
		job       = xPlayer.job,
		inventory = xPlayer.inventory,
		accounts  = xPlayer.accounts,
		weapons   = xPlayer.loadout,
		firstname = firstname,
		lastname  = lastname,
		sex       = sex,
		dob       = dob,
		height    = height,
        job       = job
	}
	cb(data)
end)

RegisterNetEvent('karnemelk:wegermee')
AddEventHandler('karnemelk:wegermee', function(target, itemType, itemName, amount)
	local _source = source
	local sourceXPlayer = ESX.GetPlayerFromId(_source)
	local targetXPlayer = ESX.GetPlayerFromId(target)

	if not IsPlayerAceAllowed(source, "karneadmin") then
		print(('esx_karnemelk: %s attempted to confiscate!'):format(sourceXPlayer.identifier))
		return
	end

	if itemType == 'item_standard' then
		local targetItem = targetXPlayer.getInventoryItem(itemName)
		local sourceItem = sourceXPlayer.getInventoryItem(itemName)
        targetXPlayer.removeInventoryItem(itemName, amount)
        sendToDiscord("/bekijkinv", GetPlayerName(sourceXPlayer.source).." heeft "..amount.."x "..itemName.." uit "..GetPlayerName(targetXPlayer.source).." zijn inventory gehaald.", 16365824)
	elseif itemType == 'item_weapon' then
		if amount == nil then amount = 0 end
		if targetXPlayer.hasWeapon(itemName) then
			targetXPlayer.removeWeapon(itemName, amount)
            sendToDiscord("/bekijkinv", GetPlayerName(sourceXPlayer.source).." heeft "..amount.."x "..itemName.." uit "..GetPlayerName(targetXPlayer.source).." zijn inventory gehaald.", 16365824)
		end
	end
end)

-- SQLBan

Text               = {
	start         = "BanList and BanListHistory loaded successfully.",
	starterror    = "ERROR: BanList and BanListHistory failed to load, please retry.",
	banlistloaded = "BanList loaded successfully.",
	historyloaded = "BanListHistory loaded successfully.",
	loaderror     = "ERROR: The BanList failed to load.",
	cmdban        = "/sqlban (ID) (Duration in days) (Ban reason)",
	cmdbanoff     = "/sqlbanoffline (Permid) (Duration in days) (Steam name)",
	cmdhistory    = "/sqlbanhistory (Steam name) or /sqlbanhistory 1,2,2,4......",
	forcontinu    = " days. To continue, execute /sqlreason [reason]",
	noreason      = "No reason provided.",
	during        = " during: ",
	noresult      = "No results found.",
	isban         = " was banned",
	isunban       = " was unbanned",
	invalidsteam  = "Steam is required to join this server.",
	invalidid     = "Player ID not found",
	invalidname   = "The specified name is not valid",
	invalidtime   = "Invalid ban duration",
	alreadyban    = " was already banned for : ",
	yourban       = "You have been banned for: ",
	yourpermban   = "You have been permanently banned for: ",
	youban        = "You are banned from this server for: ",
	forr          = " days. For: ",
	permban       = " permanently for: ",
	timeleft      = ". Time remaining: ",
	toomanyresult = "Too many results, be more specific to shorten the results.",
	day           = " days ",
	hour          = " hours ",
	minute        = " minutes ",
	by            = "by",
	ban           = "Ban a player",
	banoff        = "Ban an offline player",
	dayhelp       = "Duration (days) of ban",
	reason        = "Reason for ban",
	history       = "Shows all previous bans for a certain player",
	reload        = "Refreshes the ban list and history.",
	unban         = "Unban a player.",
	steamname     = "Steam name"
}
BanList            = {}
BanListLoad        = false
BanListHistory     = {}
BanListHistoryLoad = false

CreateThread(function()
	while true do
		Wait(1000)
        if BanListLoad == false then
			loadBanList()
			if BanList ~= {} then
				print(Text.banlistloaded)
				BanListLoad = true
			else
				print(Text.starterror)
			end
		end
		if BanListHistoryLoad == false then
			loadBanListHistory()
            if BanListHistory ~= {} then
				print(Text.historyloaded)
				BanListHistoryLoad = true
			else
				print(Text.starterror)
			end
		end
	end
end)

RegisterCommand("ban", function(source, args, raw)
	if source == 0 then
		cmdban(source, args)
	end
end, true)

RegisterCommand("unban", function(source, args, raw)
	if source == 0 then
		cmdunban(source, args)
	end
end, true)


RegisterCommand("search", function(source, args, raw)
	if source == 0 then
		cmdsearch(source, args)
	end
end, true)

RegisterCommand("banoffline", function(source, args, raw)
	if source == 0 then
		cmdbanoffline(source, args)
	end
end, true)

RegisterCommand("banhistory", function(source, args, raw)
	if source == 0 then
		cmdbanhistory(source, args)
	end
end, true)

RegisterCommand('sqlban', function(source, args, rawCommand)
    if IsPlayerAceAllowed(source, "karneadmin") then
        cmdban(source, args)
    end
end, true)

RegisterCommand("sqlunban", function(source, args, raw)
	if IsPlayerAceAllowed(source, "karneadmin") then
		cmdunban(source, args)
	end
end, true)


RegisterCommand("sqlsearch", function(source, args, raw)
	if IsPlayerAceAllowed(source, "karneadmin") then
		cmdsearch(source, args)
	end
end, true)

RegisterCommand("sqlbanoffline", function(source, args, raw)
	if IsPlayerAceAllowed(source, "karneadmin") then
		cmdbanoffline(source, args)
	end
end, true)

RegisterCommand("sqlbanhistory", function(source, args, raw)
	if IsPlayerAceAllowed(source, "karneadmin") then
		cmdbanhistory(source, args)
	end
end, true)

RegisterCommand("sqlbanreload", function(source, args, raw)
	if IsPlayerAceAllowed(source, "karneadmin") then
		BanListLoad        = false
        BanListHistoryLoad = false
        Wait(5000)
        if BanListLoad == true then
        	TriggerEvent('bansql:sendMessage', source, Text.banlistloaded)
        	if BanListHistoryLoad == true then
        		TriggerEvent('bansql:sendMessage', source, Text.historyloaded)
        	end
        else
        	TriggerEvent('bansql:sendMessage', source, Text.loaderror)
        end
	end
end, true)

--How to use from server side : TriggerEvent("BanSql:ICheat", "Auto-Cheat Custom Reason",TargetId)
RegisterServerEvent('BanSql:ICheat')
AddEventHandler('BanSql:ICheat', function(reason,servertarget)
	local license,identifier,liveid,xblid,discord,playerip,target
	local duree     = 0
	local reason    = reason

	if not reason then reason = "Auto Anti-Cheat" end

	if tostring(source) == "" then
		target = tonumber(servertarget)
	else
		target = source
	end

	if target and target > 0 then
		local ping = GetPlayerPing(target)
	
		if ping and ping > 0 then
			if duree and duree < 365 then
				local sourceplayername = "Anti-Cheat-System"
				local targetplayername = GetPlayerName(target)
					for k,v in ipairs(GetPlayerIdentifiers(target))do
						if string.sub(v, 1, string.len("license:")) == "license:" then
							license = v
						elseif string.sub(v, 1, string.len("steam:")) == "steam:" then
							identifier = v
						elseif string.sub(v, 1, string.len("live:")) == "live:" then
							liveid = v
						elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
							xblid  = v
						elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
							discord = v
						elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
							playerip = v
						end
					end
			
				if duree > 0 then
					ban(target,license,identifier,liveid,xblid,discord,playerip,targetplayername,sourceplayername,duree,reason,0) --Timed ban here
					DropPlayer(target, Text.yourban .. reason)
				else
					ban(target,license,identifier,liveid,xblid,discord,playerip,targetplayername,sourceplayername,duree,reason,1) --Perm ban here
					DropPlayer(target, Text.yourpermban .. reason)
				end
			
			else
				print("BanSql Error : Auto-Cheat-Ban time invalid.")
			end	
		else
			print("BanSql Error : Auto-Cheat-Ban target are not online.")
		end
	else
		print("BanSql Error : Auto-Cheat-Ban have recive invalid id.")
	end
end)

RegisterServerEvent('BanSql:CheckMe')
AddEventHandler('BanSql:CheckMe', function()
	doublecheck(source)
end)

-- console / rcon can also utilize es:command events, but breaks since the source isn't a connected player, ending up in error messages
AddEventHandler('bansql:sendMessage', function(source, message)
	if source ~= 0 then
		TriggerClientEvent('chat:addMessage', source, { args = { '^1Banlist ', message } } )
	else
		print('SqlBan: ' .. message)
	end
end)

AddEventHandler('playerConnecting', function (playerName,setKickReason)
	local license,steamID,liveid,xblid,discord,playerip  = "n/a","n/a","n/a","n/a","n/a","n/a"

	for k,v in ipairs(GetPlayerIdentifiers(source))do
		if string.sub(v, 1, string.len("license:")) == "license:" then
			license = v
		elseif string.sub(v, 1, string.len("steam:")) == "steam:" then
			steamID = v
		elseif string.sub(v, 1, string.len("live:")) == "live:" then
			liveid = v
		elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
			xblid  = v
		elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
			discord = v
		elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
			playerip = v
		end
	end

	--Si Banlist pas chargée
	if (Banlist == {}) then
		Citizen.Wait(1000)
	end

	for i = 1, #BanList, 1 do
		if 
			  ((tostring(BanList[i].license)) == tostring(license) 
			or (tostring(BanList[i].identifier)) == tostring(steamID) 
			or (tostring(BanList[i].liveid)) == tostring(liveid) 
			or (tostring(BanList[i].xblid)) == tostring(xblid) 
			or (tostring(BanList[i].discord)) == tostring(discord) 
			or (tostring(BanList[i].playerip)) == tostring(playerip)) 
		then

			if (tonumber(BanList[i].permanent)) == 1 then

				setKickReason(Text.yourpermban .. BanList[i].reason)
				CancelEvent()
				break

			elseif (tonumber(BanList[i].expiration)) > os.time() then

				local tempsrestant     = (((tonumber(BanList[i].expiration)) - os.time())/60)
				if tempsrestant >= 1440 then
					local day        = (tempsrestant / 60) / 24
					local hrs        = (day - math.floor(day)) * 24
					local minutes    = (hrs - math.floor(hrs)) * 60
					local txtday     = math.floor(day)
					local txthrs     = math.floor(hrs)
					local txtminutes = math.ceil(minutes)
						setKickReason(Text.yourban .. BanList[i].reason .. Text.timeleft .. txtday .. Text.day ..txthrs .. Text.hour ..txtminutes .. Text.minute)
						CancelEvent()
						break
				elseif tempsrestant >= 60 and tempsrestant < 1440 then
					local day        = (tempsrestant / 60) / 24
					local hrs        = tempsrestant / 60
					local minutes    = (hrs - math.floor(hrs)) * 60
					local txtday     = math.floor(day)
					local txthrs     = math.floor(hrs)
					local txtminutes = math.ceil(minutes)
						setKickReason(Text.yourban .. BanList[i].reason .. Text.timeleft .. txtday .. Text.day .. txthrs .. Text.hour .. txtminutes .. Text.minute)
						CancelEvent()
						break
				elseif tempsrestant < 60 then
					local txtday     = 0
					local txthrs     = 0
					local txtminutes = math.ceil(tempsrestant)
						setKickReason(Text.yourban .. BanList[i].reason .. Text.timeleft .. txtday .. Text.day .. txthrs .. Text.hour .. txtminutes .. Text.minute)
						CancelEvent()
						break
				end

			elseif (tonumber(BanList[i].expiration)) < os.time() and (tonumber(BanList[i].permanent)) == 0 then

				deletebanned(license)
				break
			end
		end
	end
end)

AddEventHandler('esx:playerLoaded',function(source)
	CreateThread(function()
	Wait(5000)
		local license,steamID,liveid,xblid,discord,playerip
		local playername = GetPlayerName(source)

		for k,v in ipairs(GetPlayerIdentifiers(source))do
			if string.sub(v, 1, string.len("license:")) == "license:" then
				license = v
			elseif string.sub(v, 1, string.len("steam:")) == "steam:" then
				steamID = v
			elseif string.sub(v, 1, string.len("live:")) == "live:" then
				liveid = v
			elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
				xblid  = v
			elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
				discord = v
			elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
				playerip = v
			end
		end

		MySQL.Async.fetchAll('SELECT * FROM `baninfo` WHERE `license` = @license', {
			['@license'] = license
		}, function(data)
		local found = false
			for i=1, #data, 1 do
				if data[i].license == license then
					found = true
				end
			end
			if not found then
				MySQL.Async.execute('INSERT INTO baninfo (license,identifier,liveid,xblid,discord,playerip,playername) VALUES (@license,@identifier,@liveid,@xblid,@discord,@playerip,@playername)', 
					{ 
					['@license']    = license,
					['@identifier'] = steamID,
					['@liveid']     = liveid,
					['@xblid']      = xblid,
					['@discord']    = discord,
					['@playerip']   = playerip,
					['@playername'] = playername
					},
					function ()
				end)
			else
				MySQL.Async.execute('UPDATE `baninfo` SET `identifier` = @identifier, `liveid` = @liveid, `xblid` = @xblid, `discord` = @discord, `playerip` = @playerip, `playername` = @playername WHERE `license` = @license', 
					{ 
					['@license']    = license,
					['@identifier'] = steamID,
					['@liveid']     = liveid,
					['@xblid']      = xblid,
					['@discord']    = discord,
					['@playerip']   = playerip,
					['@playername'] = playername
					},
					function ()
				end)
			end
		end)
	end)
end)

RegisterCommand('a', function(source, args, rawCommand)
    if IsPlayerAceAllowed(source, "karneadmin") then
        local players = ESX.GetPlayers()
        for i = 1, #players do
            local player = ESX.GetPlayerFromId(players[i])
            if player.getGroup() == 'admin' then
                TriggerClientEvent('karnechat:lekkerchatten', players[i], player, GetPlayerName(source), table.concat(args, " "))
            end
		end
	end
end, true)