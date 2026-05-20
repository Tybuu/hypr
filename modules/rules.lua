-- Monitor Bindings
local mon = #Values.monitors
for i = 0, 10 / mon do
	for j = 1, mon do
		hl.workspace_rule({ workspace = tostring(mon * i + j), monitor = Values.monitors[j].output })
	end
end

-- Workspace Rules
hl.window_rule({
	match = {
		class = ".*",
	},
	suppress_event = "maxmize",
})
hl.window_rule({
	match = {
		class = "^(com.moonlight_stream.Moonlight)$",
	},
	workspace = (2 + mon) .. " silent",
	immediate = true,
})
hl.window_rule({
	match = {
		class = "^(osu!)$",
	},
	immediate = true,
})
hl.window_rule({
	match = {
		class = "^(steam_app.*)$",
	},
	fullscreen_state = "2 2",
	workspace = (2 + mon) .. " silent",
	immediate = true,
})
hl.window_rule({
	match = {
		title = "^(GuiPicker)$",
	},
	float = true,
})
hl.window_rule({
	-- Fix some dragging issues with XWayland
	name = "fix-xwayland-drags",
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
		pin = false,
	},
	no_focus = true,
})
