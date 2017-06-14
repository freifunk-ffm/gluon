local uci = require("simple-uci").cursor()

-- where to read the configuration from
local name   = "ffshare1"

local f = Form(translate("Prefix Sharing"))

local s = f:section(Section, nil, translate(
	'Your node can serve the mesh network as an exit for IPv6 traffic. '
	.. 'In order to do that, you can distribute a /64 prefix throughout the net.'
))

local enabled = s:option(Flag, "enabled", translate("Enabled"))
enabled.default = uci:get_bool('prefixd', name, "enabled")

local prefix = s:option(Value, "prefix", translate("Prefix (must be /64)"))
prefix:depends(enabled, true)
prefix.datatype = "maxlength(32)"
prefix.default = uci:get('prefixd',  name, "prefix") or  "fd00:a:b:c::/64"

-- TODO: validate input and warn if prefix is not /64

function f:write()
	if enabled.data then
		uci:section('prefixd', "share", name, {
			prefix    = prefix.data,
			enabled   = '1',
		})
	else
		uci:set('prefixd', name, "enabled", false)
	end

	uci:commit('prefixd')
end

return f
