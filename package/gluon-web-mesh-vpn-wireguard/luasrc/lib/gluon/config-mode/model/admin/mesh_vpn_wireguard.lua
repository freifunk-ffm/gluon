local uci = require("simple-uci").cursor()
local util = gluon.util
local site = require 'gluon.site'

local f = Form(translate('Mesh VPN'))

local s = f:section(Section)

local mode = s:option(Value, 'mode')


local enabled = site.mesh_vpn.wireguard.enabled()

mode.package = "gluon-web-mesh-vpn-wireguard"
mode.template = "mesh-vpn-wireguard"

function mode:write(data)

--	local methods = {}
--	if data == 'performance' then
--		table.insert(methods, 'null')
--	end

--	for _, method in ipairs(site.mesh_vpn.fastd.methods()) do
--		if method ~= 'null' then
--			table.insert(methods, method)
--		end
--	end

	uci:set("wireguard", "wireguard", "enabled", data.wireguard )

	uci:save('wireguard')
	uci:commit('wireguard')
end

return f
