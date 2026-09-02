require("modules.helper")
local M = {}

M = {
	monitors = {
		{
			output = "DP-2",
			mode = "1920x1080@144",
			position = "0x0",
			scale = 1,
		},
		{
			output = "DP-1",
			mode = "2560x1440@180",
			position = "1920x0",
			scale = 1,
		},
		{
			output = "HDMI-A-2",
			mode = "1920x1080",
			position = "4480x0",
			scale = 1,
		},
	},
}

local scratchMonitor = 3
function DisableSpecial()
	local mon = hl.get_monitor(M.monitors[scratchMonitor].output)
	local curMon = hl.get_active_monitor()
	if mon ~= nil and mon.active_special_workspace ~= nil then
		local i = string.find(mon.active_special_workspace.name, ":")
		local workspace = string.sub(mon.active_special_workspace.name, i + 1)
		hl.dispatch(hl.dsp.focus({ monitor = M.monitors[scratchMonitor].output }))
		-- hl.notification.create({ text = workspace, duration = 2000 })
		hl.dispatch(hl.dsp.workspace.toggle_special(workspace))
	end
	hl.dispatch(hl.dsp.focus({ monitor = curMon.name }))
end

local function toggle_command(workspace, command)
	return function()
		local toggled = #hl.get_windows({ workspace = "special:" .. workspace }) ~= 0
		local monitor = hl.get_active_monitor()
		-- hl.notification.create({ text = Values.mainMod, duration = 2000 })
		if toggled then
			hl.dispatch(Change(scratchMonitor))
			hl.dispatch(hl.dsp.workspace.toggle_special(workspace))
			hl.dispatch(hl.dsp.focus({ monitor = monitor.name }))
		else
			hl.dispatch(Change(scratchMonitor))
			hl.dispatch(hl.dsp.workspace.toggle_special(workspace))
			command()
		end
	end
end

local mainMod = Values.mainMod
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind(mainMod .. " + comma", Change(1))
hl.bind(mainMod .. " + period", Change(2))
hl.bind(mainMod .. " + slash", Change(3))

hl.bind(mainMod .. " + SHIFT + comma", hl.dsp.window.move({ monitor = "DP-2", follow = true }))
hl.bind(mainMod .. " + SHIFT + period", hl.dsp.window.move({ monitor = "DP-1", follow = true }))
hl.bind(mainMod .. " + SHIFT + slash", hl.dsp.window.move({ monitor = "HDMI-A-2", follow = true }))
hl.bind(
	mainMod .. " + R",
	toggle_command("music", function()
		hl.dispatch(hl.dsp.exec_cmd("pear-desktop --enable-features=UseOzonePlatform --ozone-platform=wayland"))
	end)
)
hl.bind(
	mainMod .. " + Z",
	toggle_command("scratch", function()
		hl.dispatch(hl.dsp.exec_cmd("kitty"))
	end)
)

return M
