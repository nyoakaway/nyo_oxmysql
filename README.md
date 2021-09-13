# DBCORE PARA OXMYSQL
Modificação da DBCORE para VRPEX para suportar OXMYSQL

Download do Script para utilizar junto (OFICIAL): [oxmysql](https://forum.cfx.re/t/standalone-oxmysql-lightweight-mysql-wrapper/4755120)

**FrameWork:** VRPEX


**Instalação:** 
É necessario fazer uma modificação no arquivo **vrp/base.lua**
Procurar pela função **vRP.isBanned**

Substituir ela por:
```lua
function vRP.isBanned(user_id, cbr)
	local rows = vRP.query("vRP/get_banned",{ user_id = user_id })
	if #rows > 0 then
		local d = rows[1].banned 
		if d == 1 then 
			return true 
		else 
			return false
		end
	else
		return false
	end
end
```

Procurar pela função **vRP.isWhitelisted**
Substituir ela por:
```lua
function vRP.isWhitelisted(user_id, cbr)
	local rows = vRP.query("vRP/get_whitelisted",{ user_id = user_id })
	if #rows > 0 then
		local d = rows[1].whitelisted
		if d == 1 then 
			return true 
		else 
			return false
		end
		return db
	else
		return false
	end
end
```

Abrir ***vrp/cfg/base.lua*** 
Alterar **ghmattimysql** para **oxmysql**


**Duvidas/Suporte:**

https://discord.gg/nyo

