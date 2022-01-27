M = {}
local _opts = require("plover_viewer.state").opts.builtin
local state = require("plover_viewer.state")
local window = require("plover_viewer.window")
local path = require("plover_viewer.path")


local function getCommandArgs(command_args)
	local res = ""
	for _, name in ipairs(command_args) do
		res = res .. name .. " "
	end
	return res
end

local function getCommand(command, args, file_name)
	return command .. " " .. args .. file_name .. "\n"
end

local function sendCommand(number, type, command)
	return require("harpoon."..type).sendCommand(number, command)
end

local function gotoTerminal (opts)
	require("harpoon."..opts.viewer.terminal.type).gotoTerminal(opts.viewer.terminal.number)
end

local function initTerminal(opts)
	local args = getCommandArgs(opts.viewer.terminal.command_args)
	local file_name = path.checkFilePath(opts.file_name, opts.cwd)
	local command = getCommand(opts.viewer.terminal.command, args, file_name)
	if not state.setTermIsInit(opts.viewer.terminal.number) then
		sendCommand(opts.viewer.terminal.number, opts.viewer.terminal.type, command)
	end
end

local function gotoBuff(opts)
	local file_name = path.checkFilePath(opts.file_name, opts.cwd)
	vim.cmd("view " .. file_name)
end

local function initGotoBuffer(opts)
	if opts.viewer.choose == "buf" then
		gotoBuff(opts)
	elseif opts.viewer.choose == "terminal" then
		initTerminal(opts)
		gotoTerminal(opts)
	end
end

M.view = function (opts)
	opts = vim.tbl_deep_extend("force", _opts, opts or {})
	initGotoBuffer(opts)
	vim.cmd [[norm! G]]
end

local function postSplit(current_buf, viewer_buf, func, size)
			vim.api.nvim_set_current_buf(current_buf)
			local current_window = vim.api.nvim_get_current_win()
			local terminal_windows = vim.fn.win_findbuf(viewer_buf)
			for _, terminal_window in ipairs(terminal_windows) do
				if size then
					func(terminal_window, size)
				end
				vim.api.nvim_set_current_win(terminal_window)
				vim.cmd [[norm! G]]
			end
			vim.api.nvim_set_current_win(current_window)
end

local function getBufState (fn, number)
	return string.format("%s%d", fn, number)
end

M.splitToggle = function (opts)
	opts = vim.tbl_deep_extend("force", _opts, opts or {})
	local bufId = getBufState("splitToggle", opts.viewer.terminal.number)
	local state_split_toggle = state.get(bufId)
	if not state_split_toggle or not window.is_buf_visible(state_split_toggle) then
		local current_buf = vim.api.nvim_get_current_buf()
		initGotoBuffer(opts)
		local viewer_buf = vim.api.nvim_get_current_buf()
		if opts.split.choose == "horizontal" then
			vim.cmd [[split]]
			postSplit(current_buf, viewer_buf, vim.api.nvim_win_set_height, opts.split.horizontal.size)
		else
			vim.cmd [[vsplit]]
			postSplit(current_buf, viewer_buf, vim.api.nvim_win_set_width, opts.split.vertical.size)
		end
		state.set(bufId, viewer_buf)
	else
		window.close_buf_if_visible(state.get(bufId))
		state.set(state.get(bufId), false)
	end
end

return M
