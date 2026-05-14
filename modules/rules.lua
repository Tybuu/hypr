-- Monitor Bindings
for i = 0, 2 do
	hl.workspace_rule({ workspace = tostring(3 * i + 1), monitor = "DP-2" })
	hl.workspace_rule({ workspace = tostring(3 * i + 2), monitor = "DP-1" })
	hl.workspace_rule({ workspace = tostring(3 * i + 3), monitor = "HDMI-A-2" })
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
	immediate = true,
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
