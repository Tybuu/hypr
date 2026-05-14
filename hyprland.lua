-- ~/.config/hypr/hyprland.lua
-- Detect Host
local handle = io.popen("hostname")
local hostname = handle:read("*a"):gsub("%s+", "")
handle:close()

_G.Values = {
	mainMod = "SUPER",
	terminal = "foot",
	browser = "firefox",
	menu = "wofi --show drun",
}

local hostValues = require("hosts." .. hostname)
for k, v in pairs(hostValues) do
	_G.Values[k] = v
end

for _, monitor in ipairs(Values.monitors) do
	hl.monitor(monitor)
end

require("modules.keybinds")
require("modules.general")
require("modules.animation")
require("modules.rules")
