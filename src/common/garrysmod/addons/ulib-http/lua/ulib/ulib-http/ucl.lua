local API_URL = 'http://gmod_database_webserver/api/v1'

--[[
    HTTP REST endpoint
]]--

local function fetch(endpoint, payload, callback)
  http.Post(
    API_URL .. endpoint,
    {
      payload = util.TableToJSON(payload)
    },
    function(body)
      if callback then
        return callback(util.JSONToTable(body))
      end
    end,
    nil,
    nil
  )
end

function ULib.ucl.saveGroups()
  for _, groupInfo in pairs( ULib.ucl.groups ) do
    table.sort(groupInfo.allow)
  end

  -- Write to local file as well as the API
  ULib.fileWrite( ULib.UCL_GROUPS, ULib.makeKeyValues( ULib.ucl.groups ) )

  fetch(
    '/ulib/ucl-save-groups',
    {
      groups = ULib.ucl.groups
    },
    nil
  )
end

local function reloadGroups()
  fetch(
    '/ulib/ucl-reload-groups',
    {},
    function(groups)
      ULib.ucl.groups = groups;
    end
  )
end

function ULib.ucl.saveUsers()
  for _, userInfo in pairs( ULib.ucl.users ) do
    table.sort(userInfo.allow)
    table.sort(userInfo.deny)
  end

  -- Write to local file as well as the API
  ULib.fileWrite( ULib.UCL_USERS, ULib.makeKeyValues( ULib.ucl.users ) )

  fetch(
    '/ulib/ucl-save-users',
    {
      users = ULib.ucl.users
    },
    nil
  )
end

local function reloadUsers()
  fetch(
    '/ulib/ucl-reload-users',
    {},
    function(users)
      ULib.ucl.users = users;
    end
  )
end

local function reloadAll()
  reloadGroups()
  reloadUsers()
end

timer.Create('ulib-http-reloaducl', 5, 0, reloadAll)
hook.Add('Initialize', 'ulib-http-loaducl', reloadAll)
reloadAll()
