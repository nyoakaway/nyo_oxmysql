fx_version 'adamant'
game 'gta5'

client_script 'hansolo/*.lua'

dependencies {
	"vrp"
	"oxmysql"
}

server_scripts {
	"@vrp/lib/utils.lua",
	"init.lua"
}
