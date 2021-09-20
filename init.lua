local Proxy = module("vrp","lib/Proxy")
local vRP = Proxy.getInterface("vRP")

-- STATIC

local function blob2string(blob)
  for i,c in pairs(blob) do
    blob[i] = string.char(c)
  end

  return table.concat(blob)
end

-- METHODS
local queries = {}
local API = exports["oxmysql"]

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
    API:execute(query, _params, function(data)
      r(data or 0)
    end)
  elseif mode == "scalar" then
    API:scalar(query, _params, function(scalar)
      r(scalar)
    end)
  else
    API:execute(query,_params, function(rows)
      for _,row in pairs(rows) do
        for k,v in pairs(row) do
          if type(v) == "table" then
            row[k] = blob2string(v)
          end
        end
      end
      r(rows, #rows)
    end)
  end
  return r:wait()
end

async(function()
  vRP.registerDBDriver("oxmysql", on_init, on_prepare, on_query)
end)
