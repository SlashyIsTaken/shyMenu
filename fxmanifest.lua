fx_version 'cerulean'
game 'gta5'

author 'Slashy // Karnemelk'
description 'Admin Mode for SpringbankRP'

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    "server/server.lua"
}

client_script "client/client.lua"

shared_script "config.lua"