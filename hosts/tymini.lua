require("modules.helper")
local M = {}

M = {
	monitors = {
		{
			output = "DP-1",
			mode = "1920x1200",
			position = "0x1440",
			scale = 1,
		},
	},
}

local mainMod = Values.mainMod
hl.bind(mainMod .. " + comma", Change(1))
hl.bind(mainMod .. " + period", Change(2))

hl.bind(mainMod .. " + SHIFT + comma", hl.dsp.window.move({ monitor = M.monitors[1].output, follow = true }))
hl.bind(mainMod .. " + SHIFT + period", hl.dsp.window.move({ monitor = M.monitors[2].output, follow = true }))

return M
