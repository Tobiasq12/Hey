name "Tycoon Piloting Job"
author "Collins"
contact ""
version "1.0"

description "Tycoon Airplane job"
usage [[

]]

resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

-- Server
server_scripts {
    '@vrp/lib/utils.lua',
    'server.lua'
}

-- Client
client_scripts {
	'client.lua'
}
