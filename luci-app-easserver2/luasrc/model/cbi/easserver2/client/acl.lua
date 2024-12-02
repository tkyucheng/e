local api = require "luci.easserver2.api"
local appname = api.appname
local sys = api.sys
local has_chnlist = api.fs.access("/usr/share/easserver2/rules/chnlist")

m = Map(appname)
api.set_apply_on_parse(m)

s = m:section(TypedSection, "global", translate("EAS-WIFI配置"), "<font color='red'>" .. translate("EAS-WIFI分配，序号对应的WIFI编号") .. "</font>")
s.anonymous = true

o = s:option(Flag, "acl_enable", translate("总WIFI开关"))
o.rmempty = false
o.default = false

-- [[ ACLs Settings ]]--
s = m:section(TypedSection, "acl_rule")
s.template = "cbi/tblsection"
s.sortable = true
s.anonymous = true
s.addremove = true
s.extedit = api.url("acl_config", "%s")
function s.create(e, t)
	t = TypedSection.create(e, t)
	luci.http.redirect(e.extedit:format(t))
end

---- Enable
o = s:option(Flag, "enabled", translate("Enable"))
o.default = 1
o.rmempty = false

---- Remarks
o = s:option(Value, "remarks", translate("WIFI序号"))
o.rmempty = true
--[[
local mac_t = {}
sys.net.mac_hints(function(e, t)
	mac_t[e] = {
		ip = t,
		mac = e
	}
end)

o = s:option(DummyValue, "sources", translate("Source"))
o.rawhtml = true
o.cfgvalue = function(t, n)
	local e = ''
	local v = Value.cfgvalue(t, n) or '-'
	string.gsub(v, '[^' .. " " .. ']+', function(w)
		local a = w
		if mac_t[w] then
			a = a .. ' (' .. mac_t[w].ip .. ')'
		end
		if #e > 0 then
			e = e .. "<br />"
		end
		e = e .. a
	end)
	return e
end

i = s:option(DummyValue, "interface", translate("Source Interface"))
i.cfgvalue = function(t, n)
	local v = Value.cfgvalue(t, n) or '-'
	return v
end
--]]
return m
