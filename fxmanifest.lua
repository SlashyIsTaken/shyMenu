fx_version 'cerulean'
game 'gta5'

author 'Slashy // Karnemelk'
description 'Admin Mode for SpringbankRP'

shared_script "config.lua"

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    "server/server.lua",
    "sqlban/sqlban.lua"
}

client_script "client/client.lua"