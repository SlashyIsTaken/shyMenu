# karneadmin
Simple, ESX, duty-based admin commands

Hey there, just for everyone's information; this is my first repo on github. Bear with me if you have any questions, I probably won't know a thing about how this all works.

This is a very basic, duty-based & ace permission based system that allows the use of admin commands only when the designated admin is on duty. Utilizes okokNotify but of course you can replace the export with your own.

The script is written for a dutch server, and thus is translated in dutch, has some stupid inside-joke-variable names, and probably won't make sense to most of you. Perhaps I'll throw a translation in the future.

As for the functions, I'd say half of it is copy-pasted from existing scripts. I can't really remember which scripts I used to combine them together into this. If you think you recognise a script made by someone else that I have integrated in here, please tell me so I can credit the original creator.

# Command overview:
/staffdienst (staffduty) | Toggles the duty on/off <br>
/blips | Toggles player blips on/off. Only works in a radius of 255 (configurable) <br>
/names | Toggles names on/off. Only shows names in line of sight of the admin <br>
/bring <id> | Brings a player to you <br>
/bringfreezed <id> | Brings a player to you in a freezed state <br>
/bringback <id> | Brings the player back to where they were before the /bring command was invoked by the admin. If the player was freezed, it unfreezes them. <br>
/car <model> | Spawns a car <br>
/coords | Prints Vector3 Coords to F8 <br>
/fixveh | Repairs & Flips nearest vehicle <br>
/freeze <id> | Freezes a player <br>
/unfreeze <id> | Unfreezes a player <br>
/goto <id> | Go to a player <br>
/goback | Go back to your original coords <br>
/heal <id> | Heals a player, or heals yourself if <id> is left empty <br>
/noclip | Toggles Noclip on/off. Doesnt feature scaleforms. Controls are configurable in client.lua <br>
/revive <id> | Revives a player, or yourself if <id> is left empty <br>
/staffonline | Shows the amount of staff players are on duty <br>
/tpm | Teleport to coords. <br>