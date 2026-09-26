function ParseRes(res)
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
		print("hi")
		local active = hl.get_active_monitor().name
		local active_pos = nil
		for i, monitor in ipairs(Values.monitors) do
			if monitor.output == active then
				active_pos = i
			end
		end
		-- if not active_pos then
		-- 	error("Monitor description is invalid")
		-- end
		if Values.monitors[pos] == nil then
			error("Invalid index")
		end
		hl.dispatch(hl.dsp.focus({ monitor = Values.monitors[pos].output }))
		if active_pos ~= pos then
			local res = ParseRes(Values.monitors[pos].mode)
			local loc = ParseRes(Values.monitors[pos].position)
			local x = loc.x + (res.x / Values.monitors[pos].scale) / 2
			local y = loc.y + (res.y / Values.monitors[pos].scale) / 2
			hl.dispatch(hl.dsp.cursor.move({ x = x, y = y }))
		end
	end
end

function DisableMonitors(resolution)
	-- Disabling all monitors without an active output causes hyprland to crash?
	hl.notification.create({ text = resolution, duration = 10000 })
	resolution = resolution or "1920x1080@60"
	local res = hl.get_monitor("HEADLESS-2") ~= nil
	for i, monitor in ipairs(Values.monitors) do
		if i == 2 and res == false then
			hl.exec_cmd("hyprctl output create headless HEADLESS-2")
			hl.monitor({ output = "HEADLESS-2", mode = resolution })
		end
		hl.monitor({
			output = monitor.output,
			disabled = true,
		})
	end
end

function EnableMonitors()
	hl.exec_cmd("hyprctl output remove HEADLESS-2")
	for i, monitor in ipairs(Values.monitors) do
		local newMon = {}
		for k, v in pairs(monitor) do
			newMon[k] = v
		end
		newMon["disabled"] = false
		hl.monitor(newMon)
		::continue::
	end
end

function TwitchStream(name)
	if not name or not name:match("^[%w_]+$") then
		return
	end

	local chat_class = "twitch-chat-" .. name
	local stream_title = "twitch-stream-" .. name
	local profile_dir = "/tmp/" .. chat_class

	hl.exec_cmd(
		string.format(
			"streamlink --title '%s' --twitch-low-latency --hls-live-edge=1 --player mpv twitch.tv/%s best",
			stream_title,
			name
		)
	)

	hl.exec_cmd(
		string.format(
			"mkdir -p %s && firefox --new-instance -profile %s --name %s --new-window 'https://www.twitch.tv/popout/%s/chat'",
			profile_dir,
			profile_dir,
			chat_class,
			name
		)
	)
end
