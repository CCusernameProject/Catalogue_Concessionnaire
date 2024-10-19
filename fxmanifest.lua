fx_version 'adamant'
game 'gta5'

client_scripts {
    'src/RageUI/RMenu.lua',
    'src/RageUI/menu/RageUI.lua',
    'src/RageUI/menu/Menu.lua',
    'src/RageUI/menu/MenuController.lua',
    'src/RageUI/components/*.lua',
    'src/RageUI/menu/elements/*.lua',
    'src/RageUI/menu/items/*.lua',
    'src/RageUI/menu/panels/*.lua',
    'src/RageUI/menu/panels/*.lua',
    'src/RageUI/menu/windows/*.lua',
}

client_scripts {
    '@es_extended/locale.lua',
    'config.lua',
    'locales/en.lua',
    'locales/fr.lua',
    'clt/client.lua'
}


server_scripts {
    '@async/async.lua',
	'@mysql-async/lib/MySQL.lua',
	'@es_extended/locale.lua',
    'config.lua',
    'locales/en.lua',
    'locales/fr.lua',
    'srv/server.lua'
}

dependencies {
    'es_extended',
    'async',
	'mysql-async'
}