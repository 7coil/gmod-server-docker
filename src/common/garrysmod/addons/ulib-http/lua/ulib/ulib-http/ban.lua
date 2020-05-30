local BAN_MESSAGE = 'You have been banned from this server.'
local next = next

local API_URL = 'http://gmod_database_webserver/api/v1'

--[[
    HTTP REST endpoint
]]--

local function fetch(endpoint, payload, callback)
  http.Post(API_URL .. endpoint, {
    payload = util.TableToJSON(payload)
  }, function(body)
    if callback then
      return callback(util.JSONToTable(body))
    end
  end , nil, nil)
end

--[[
  Override the ULib bans system
]]--

function ULib.addBan(steamid, time, reason, name, admin)
  local unban = 0;
  local adminName = 'CONSOLE'
  local adminSteam = 'CONSOLE'
  local timestamp = os.time()

  if steamid == nil or time == nil then return end

  if name == nil then
    name = 'No name provided'
  end

  if reason == nil then
    reason = 'No reason provided'
  end

  if time != 0 then
    unban = timestamp + (time * 60)
  end

  if admin != nil && admin:IsPlayer() then
    adminName = admin:Nick()
    adminSteam = admin:SteamID()
  end

  fetch(
    '/ulib/ban',
    {
      id = steamid,
      name = name,
      reason = reason,
      timestamp = timestamp,
      unban = unban,
      admin = {
        name = adminName,
        id = adminSteam,
      }
    },
    function()
      ULib.refreshBans()
    end
  )

  local ply = player.GetBySteamID(steamid)
  if ply then
    ULib.kick(ply, reason, nil, true)
  end
  RunConsoleCommand('kickid', steamid, BAN_MESSAGE)
end

function ULib.unban(steamid)
  fetch(
    '/ulib/unban',
    {
      id = steamid
    },
    function()
      ULib.refreshBans()
    end
  )
end

function ULib.refreshBans()
  fetch(
    '/ulib/bans',
    {},
    function(body)
      ULib.bans = {}
      -- Iterate all the bans
      if next(body) != nil then
        for i = 1, #body do
          local res = body[i]
          ban = {}
          ban.steamID = res.id
          ban.time = res.timestamp
          ban.unban = res.unban
          ban.reason = res.reason
          ban.name = res.name
          ban.admin = res.admin and res.admin.name
          ban.modified_admin = res.modified and res.modified.name
          ban.modified_time = res.modified and res.modified.timestamp
          ULib.bans[res.id] = ban
        end
      end
    end
  )
end

local function reloadAll()  
  for number, ply in pairs(player.GetAll()) do
    local message = ULib.getBanMessage(ply.SteamID())
    if message then
      game.KickID(ply.SteamID(), message)
    end
  end
  
  ULib.refreshBans()
end

timer.Create('ulib-http-reloadbans', 5, 0, reloadAll)
hook.Add('Initialize', 'ulib-http-loadbans', reloadAll)
reloadAll()
