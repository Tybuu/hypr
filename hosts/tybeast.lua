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

local function toggle_command(workspace, command)
	return function()
		local toggled = #hl.get_windows({ workspace = "special:" .. workspace }) ~= 0
		local monitor = hl.get_active_monitor()
		-- hl.notification.create({ text = Values.mainMod, duration = 2000 })
		if toggled then
			hl.dispatch(Change(3))
			hl.dispatch(hl.dsp.workspace.toggle_special(workspace))
			hl.dispatch(hl.dsp.focus({ monitor = monitor.name }))
		else
			hl.dispatch(Change(3))
			hl.dispatch(hl.dsp.workspace.toggle_special(workspace))
			command()
		end
	end
end

local mainMod = Values.mainMod
hl.bind(mainMod .. " + comma", Change(1))
hl.bind(mainMod .. " + period", Change(2))
hl.bind(mainMod .. " + slash", Change(3))

hl.bind(mainMod .. " + SHIFT + comma", hl.dsp.window.move({ monitor = "DP-2", follow = true }))
hl.bind(mainMod .. " + SHIFT + period", hl.dsp.window.move({ monitor = "DP-1", follow = true }))
hl.bind(mainMod .. " + SHIFT + slash", hl.dsp.window.move({ monitor = "HDMI-A-2", follow = true }))
hl.bind(
	mainMod .. " + R",
	toggle_command("music", function()
		hl.dispatch(hl.dsp.exec_cmd("firefox -P gedisu --new-window https://music.youtube.com/"))
	end)
)
hl.bind(
	mainMod .. " + Z",
	toggle_command("scratch", function()
		hl.dispatch(hl.dsp.exec_cmd("google-chrome-stable"))
		hl.dispatch(hl.dsp.exec_cmd("foot"))
	end)
)

return M
