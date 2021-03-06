--
-- (C) 2013-20 - ntop.org
--

local dirs = ntop.getDirs()
package.path = dirs.installdir .. "/scripts/lua/modules/?.lua;" .. package.path

require "lua_utils"
local json = require ("dkjson")
local tracker = require("tracker")
local rest_utils = require("rest_utils")

--
-- Set host alias
-- Example: curl -u admin:admin -d '{"host" : "192.168.1.1", "custom_name" : "Mario"}' http://localhost:3000/lua/rest/v1/set/host/alias.lua
--
-- NOTE: in case of invalid login, no error is returned but redirected to login
--

sendHTTPHeader('application/json')

local rc = rest_utils.consts_ok
local res = {}

local host_info = url2hostinfo(_POST)
local custom_name = _POST["custom_name"]

if not haveAdminPrivileges() then
   print(rest_utils.rc(rest_utils.consts_not_granted))
   return
end

if host_info == nil or isEmptyString(host_info["host"]) or custom_name == nil then
   print(rest_utils.rc(rest_utils.consts_invalid_args))
   return
end

setHostAltName(host_info["host"], custom_name)

-- TRACKER HOOK
tracker.log('set_host_alias', { host = hostinfo2hostkey(host_info), custom_name = custom_name })

print(rest_utils.rc(rc, res))

