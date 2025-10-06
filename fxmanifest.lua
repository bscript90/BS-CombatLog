fx_version "cerulean"
version "1.1"
author "BScript Development"
description "CombatLog Script"
game "rdr3"
lua54 "yes"
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

shared_scripts {
    'config.lua',
    'shared.lua'
}
server_scripts {
    'versionchecker.lua',
    'server/*.lua'
}
client_scripts {
    'client/*.lua'
}

ui_page 'ui/index.html'
files {
  'ui/**'
}

escrow_ignore {
    '**',
}