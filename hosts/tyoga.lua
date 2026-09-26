require("modules.helper")

local M = {}

M = {
	monitors = {
		{
			output = "HDMI-A-1",
			mode = "1920x1080",
			position = "0x0",
			scale = 1,
			disabled = false,
		},
		{
			output = "DP-1",
			mode = "2560x1440@180",
			position = "1920x0",
			-- cm = "hdredid",
			-- bitdepth = 10,
			-- sdr_max_luminance = 400,
			-- sdrbrightness = 0.5,
			scale = 1,
		},
		{
			output = "DP-2",
			mode = "1920x1080@144",
			position = "4480x0",
			scale = 1,
		},
		-- {
		-- 	output = "eDP-1",
		-- 	mode = "1920x1200",
		-- 	position = "-1920x0",
		-- 	disabled = false,
		-- 	scale = 1.5,
		-- },
	},
}
hl.monitor({
	output = "eDP-1",
	mode = "1920x1200",
	position = "-1920x0",
	disabled = true,
	scale = 1.5,
})
hl.on("hyprland.start", function()
	-- hl.dispatch(hl.dsp.dpms({ monitor = "eDP-1", action = "disable" }))
	hl.dispatch(hl.dsp.exec_cmd("~/default.sh"))
end)

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

local function toggleMonitors()
	local monitors = hl.get_monitors()
	local laptopMode = false

	-- Determine if we are in laptop mode or desktop mode
	for _, monitor in ipairs(monitors) do
		if monitor.name == "eDP-1" then
			laptopMode = true
			break
		end
	end

	hl.dispatch(hl.dsp.exec_cmd("~/switch.sh"))
	-- Switch betweens the modes
	if laptopMode then
		local count = #M.monitors
		for mon = 1, count do
			hl.timer(function()
				local copy = {}
				for key, val in pairs(M.monitors[mon]) do
					copy[key] = val
				end
				copy["disabled"] = false
				hl.monitor(copy)
				hl.timer(function()
					for i = 0, math.floor(10 / count) do
						hl.dispatch(hl.dsp.workspace.move({
							workspace = tostring(math.floor(math.floor(10 / count)) * i + mon),
							monitor = Values.monitors[mon].output,
						}))
					end
					hl.dispatch(hl.dsp.focus({ workspace = mon }))
				end, { timeout = 100, type = "oneshot" })
			end, { timeout = mon * 500, type = "oneshot" })
			hl.timer(function()
				hl.monitor({
					output = "eDP-1",
					mode = "1920x1200",
					position = "-1920x0",
					disabled = true,
					scale = 1.5,
				})
			end, { timeout = 500 + count * 500, type = "oneshot" })
		end
	else
		hl.timer(function()
			hl.monitor({
				output = "eDP-1",
				mode = "1920x1200",
				position = "-1920x0",
				disabled = false,
				scale = 1.5,
			})
		end, { timeout = 500, type = "oneshot" })

		local count = #M.monitors
		for mon = 1, count do
			hl.timer(function()
				hl.monitor({
					output = M.monitors[mon].output,
					disabled = true,
				})
			end, { timeout = 500 + mon * 500, type = "oneshot" })
		end
		hl.timer(function()
			hl.dispatch(hl.dsp.focus({ workspace = 1 }))
		end, { timeout = 500 + count * 500 + 100, type = "oneshot" })
	end
end

-- local function toggleMonitors()
-- 	local monitors = hl.get_monitors()
-- 	local laptopMode = false
-- 	hl.get_monitors()
--
-- 	-- Determine if we are in laptop mode or desktop mode
-- 	for _, monitor in ipairs(monitors) do
-- 		if monitor.name == "eDP-1" and monitor.dpms_status then
-- 			laptopMode = true
-- 			break
-- 		end
-- 	end
--
-- 	hl.dispatch(hl.dsp.exec_cmd("~/switch.sh"))
-- 	-- Switch betweens the modes
-- 	if laptopMode then
-- 		local mon = #M.monitors
-- 		hl.dispatch(hl.dsp.focus({ workspace = 21 }))
-- 		for i = 1, mon do
-- 			for j = 0, math.floor(10 / mon) - 1 do
-- 				hl.workspace_rule({ workspace = tostring(mon * j + i), monitor = Values.monitors[i].output })
-- 				hl.dispatch(
-- 					hl.dsp.workspace.move({ workspace = tostring(mon * j + i), monitor = Values.monitors[i].output })
-- 				)
-- 			end
-- 		end
-- 		for i, monitor in ipairs(M.monitors) do
-- 			hl.timer(function()
-- 				hl.dispatch(hl.dsp.dpms({ monitor = monitor.output, action = "enable" }))
-- 				hl.timer(function()
-- 					hl.dispatch(hl.dsp.focus({ workspace = i }))
-- 				end, { timeout = 100, type = "oneshot" })
-- 			end, { timeout = i * 500, type = "oneshot" })
-- 		end
-- 		hl.timer(function()
-- 			hl.dispatch(hl.dsp.dpms({ monitor = "eDP-1", action = "disable" }))
-- 		end, { timeout = (mon + 1) * 500, type = "oneshot" })
-- 	else
-- 		for i = 1, 10 do
-- 			hl.workspace_rule({ workspace = tostring(i), monitor = "eDP-1" })
-- 			hl.dispatch(hl.dsp.workspace.move({ workspace = tostring(i), monitor = "eDP-1" }))
-- 		end
-- 		hl.timer(function()
-- 			hl.dispatch(hl.dsp.dpms({ monitor = "eDP-1", action = "enable" }))
-- 			for _, monitor in ipairs(M.monitors) do
-- 				hl.dispatch(hl.dsp.dpms({ monitor = monitor.output, action = "disable" }))
-- 				hl.dispatch(hl.dsp.focus({ workspace = 1 }))
-- 			end
-- 		end, { timeout = 500, type = "oneshot" })
-- 		for i, monitor in ipairs(M.monitors) do
-- 			hl.timer(function()
-- 				hl.dispatch(hl.dsp.dpms({ monitor = monitor.output, action = "disable" }))
-- 			end, { timeout = (i + 1) * 500, type = "oneshot" })
-- 		end
-- 	end
-- end

local mainMod = Values.mainMod
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind(mainMod .. "+ SHIFT + E", toggleMonitors)
hl.bind(mainMod .. " + comma", Change(1))
hl.bind(mainMod .. " + period", Change(2))
hl.bind(mainMod .. " + slash", Change(3))

hl.bind(mainMod .. " + SHIFT + comma", hl.dsp.window.move({ monitor = M.monitors[1].output, follow = true }))
hl.bind(mainMod .. " + SHIFT + period", hl.dsp.window.move({ monitor = M.monitors[2].output, follow = true }))
hl.bind(mainMod .. " + SHIFT + slash", hl.dsp.window.move({ monitor = M.monitors[3].output, follow = true }))

hl.bind(
	mainMod .. "+SHIFT+T",
	hl.dsp.exec_cmd([[
        bash -c 'INPUT=$(echo "" | wofi -dmenu -p "Twitch Name:"); [ -n "$INPUT" ] && hyprctl dispatch "TwitchStream(\"$INPUT\")"'
    ]])
)

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
