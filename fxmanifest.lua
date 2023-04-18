fx_version 'cerulean'
game 'gta5'

author 'Slashy // Shy'
description 'Admin system, created for Springbank Roleplay'

shared_script "config.lua"

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    "server/server.lua",
    "sqlban/sqlban.lua"
}

client_scripts {
    "client/client.lua",
    "notify.lua"
}