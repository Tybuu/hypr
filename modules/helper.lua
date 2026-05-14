local function parseRes(res)
	local x_pos = string.find(res, "x")
	local at_pos = string.find(res, "@")
	if at_pos == nil then
		at_pos = string.len(res) + 1
	end
	local x = string.sub(res, 0, x_pos - 1)
	local y = string.sub(res, x_pos + 1, at_pos - 1)
	return { x = x, y = y }
end

function Change(pos)
	return function()
		local active = hl.get_active_monitor().name
		local active_pos = nil
		for i, monitor in ipairs(Values.monitors) do
			if monitor.output == active then
				active_pos = i
			end
		end
		if not active_pos then
			error("Monitor description is invalid")
		end
		hl.dispatch(hl.dsp.focus({ monitor = Values.monitors[pos].output }))
		if active_pos ~= pos then
			local res = parseRes(Values.monitors[pos].mode)
			local loc = parseRes(Values.monitors[pos].position)
			local x = loc.x + res.x / 2
			local y = loc.y + res.y / 2
			hl.dispatch(hl.dsp.cursor.move({ x = x, y = y }))
		end
	end
end
