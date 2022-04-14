local Proxy = module("vrp","lib/Proxy")
local vRP = Proxy.getInterface("vRP")

-- METHODS
local queries = {}

local function on_init(cfg)
	return API ~= nil
end

local function on_prepare(name, query)
	queries[name] = query
end

local function on_query(name, params, mode)
	local query = queries[name]
	query = query:gsub("%,",", ")
	local _params = {_ = true}
	for k,v in pairs(params) do _params[k] = v end
	local r = async()
	if mode == "execute" then
		MySQL.query(query, _params, function(data)
			r(data or 0)
		end)
	elseif mode == "executeAsync" then
		MySQL.Async.fetchAll(query, _params, function(data)
			r(data or 0)
		end)
	elseif mode == "scalar" then
		MySQL.scalar(query, _params, function(scalar)
			r(scalar)
		end)
	else
		MySQL.query(query,_params, function(rows)    
			r(rows, #rows)
		end)
	end
	return r:wait()
end

async(function()
	vRP.registerDBDriver("oxmysql", on_init, on_prepare, on_query)
end)