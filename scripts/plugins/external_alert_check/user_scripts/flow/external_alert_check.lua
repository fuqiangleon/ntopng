--
-- (C) 2019-20 - ntop.org
--

local flow_consts = require("flow_consts")
local json = require ("dkjson")
local user_scripts = require ("user_scripts")
local alert_consts = require("alert_consts")

-- #################################################################

local script = {
  -- NOTE: hooks defined below
  hooks = {},
  external_alerts_only = true, -- Only execute for interfaces which have seen external alerts (either companion or syslog)
  periodic_update_seconds = 30,

  gui = {
    i18n_title = "flow_callbacks_config.ext_alert",
    i18n_description = "flow_callbacks_config.ext_alert_description",
  }
}

-- #################################################################

function script.hooks.periodicUpdate(now)
  local info_json = flow.retrieveExternalAlertInfo()

  if(info_json ~= nil) then

    -- NOTE: the same info will *not* be returned in the next periodicUpdate
    local info = json.decode(info_json)
    if info ~= nil then
       flow.triggerStatus(
	  flow_consts.status_types.status_external_alert.create(
             alert_consts.alertSeverityById(info.severity_id),
             info
	  ),
	  nil, nil, nil)
    end
  end
end

-- #################################################################

return script
