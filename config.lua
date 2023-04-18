Config = {}

Config.Webhook = "WEBHOOK"

Config.onDutyCommand = "onduty" -- Change to whatever the on duty command should be.
Config.offDutyCommand = "offduty" -- Change to whatever the off duty command should be.

Config.AceGroup = "karneadmin" -- Change to whichever ace group would be allowed to use the admin system.

-- Default noclip keys. These can be changed in the keybind settings ingame. Keys can be found at https://docs.fivem.net/docs/game-references/input-mapper-parameter-ids/keyboard/
Config.NoclipKey = "DELETE" -- Noclip toggle key.
Config.AlterCameraKey = "V" -- Noclip camera key
Config.AlterSpeedKey = "LSHIFT" -- Noclip speed key.

Config.EnableStaffPayout = true -- Toggle for staff payouts.
Config.StaffPayout = 1000 -- If above is true, this is how much staff gets each 15 minutes.

Config.EnableLeaveNotifications = true -- Enable or disable player disconnects being broadcasted to the chat.

Config.EnablePedMenu = true -- Enables or disables the ability to change peds via the command /changeped <id> <ped>.

Config.Translations = {
    -- Notification Titles
    dutytitle = "Staff Duty",
    newreporttitle = "New Report",
    notstafftitle = "Beep. Bloop. Bleep?",
    gototitle = "Goto",
    bringtitle = "Bring",
    stafftitle = "<CITY> Staff Team",
    healtitle = "Heal",
    freezetitle = "Freeze",
    cartitle = "Car Spawn",
    kicktitle = "Kick",
    paytitle = "Payday!",

    -- Notification Contents
    welcome = "Welcome",
    thanks = "Thanks for your time",
    offduty = "You are off duty!",
    notstaff = "You are not a member off staff.",
    tpmsuccess = "Sent you through the wormhole!",
    nowp = "No waypoint set.",
    fixedveh = "Fixed this vehicle!",
    noveh = "No vehicle found.",
    newreport = "A new report has been created.",
    gotp = "You were teleported.",
    backtp = "You were teleported back.",
    offline = "This identifier is offline",
    invalid = "Invalid Input.",
    coorderror = "Couldn't retrieve your old coords.",
    bringplayer = "Bringing the player...",
    tptostaff = "You were teleported to a staff member.",
    couldnottp = "Could not bring the player back.",
    tpback = "You were teleported back by a staff member.",
    bringback = "Bringing the player back...",
    heal = "You have healed",
    healself = "You have healed yourself.",
    freezed = "You have freezed",
    unfreezed = "Unfreezed",
    payday = "You were paid an extra dollar because of your duty status.",

    -- Discord Log stuffs
    dutytoggletitle = "Duty Toggle",
    enterduty = "has gone on duty",
    leaveduty = "has gone off duty",
    teleportedto = "has teleported to",
    brought = "has brought",
    healed = "has healed",
    healedself = "has healed himself",
    froze = "froze",
    defroze = "defrosted",
    kill = "killed",
    carspawn = "spawned a"
}