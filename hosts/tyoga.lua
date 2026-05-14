local M = {}

M = {
	monitors = {
		{
			output = "eDP-1",
			mode = "1920x1200",
			position = "0x1440",
			scale = 1.25,
		},
		{
			output = "DP-1",
			mode = "3840x2160",
			position = "0x0",
			scale = 1.5,
		},
	},
}

local mainMod = Values.mainMod
hl.bind(mainMod .. " + comma", Change(1))
hl.bind(mainMod .. " + period", Change(2))

hl.bind(mainMod .. " + SHIFT + comma", hl.dsp.window.move({ monitor = M.monitors[1].output, follow = true }))
hl.bind(mainMod .. " + SHIFT + period", hl.dsp.window.move({ monitor = M.monitors[2].output, follow = true }))

return M
