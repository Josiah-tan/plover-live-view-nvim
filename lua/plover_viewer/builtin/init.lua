M = {}
local _opts = require("plover_viewer.state").opts.builtin
local state = require("plover_viewer.state")
local window = require("plover_viewer.window")


local function getCommandArgs(command_args)
	local res = ""
	for _, name in ipairs(command_args) do
		res = res .. name .. " "
	end
	return res
end

function table.shallow_copy(t)
	local t2 = {}
	for k,v in pairs(t) do
		t2[k] = v
	end
	return t2
end

local function getConfigDir()
	-- not sure if this is right
	return vim.fn.trim(vim.fn.system('python3 -c "from plover.oslayer.config import CONFIG_DIR;print(CONFIG_DIR)"'))
end

local function checkReadable(file_name, cwds)
	local _file_name = file_name
	if type(cwds) ~= "table" then
		cwds = {cwds}
	end
	local copy = table.shallow_copy(cwds)
	for _, cwd in ipairs(copy) do
		file_name = cwd .. _file_name
		if vim.fn.filereadable(vim.fn.expand(file_name)) == 1 then
			return file_name
		end
	end
end

local function checkFilePath(file_name, cwds)
	local res = checkReadable(file_name, cwds)
	if res then
		return res
	end
	res = checkReadable(file_name, getConfigDir())
	if res then
		return res
	end
	res = checkReadable(file_name, "")
	if res then
		return res
	end
	error("file does not exist, please include a cwd")
end

local function getCommand(command, args, file_name)
	return command .. " " .. args .. file_name .. "\n"
end

local function sendCommand(number, type, command)
	-- return require("harpoon."..type).sendCommand(number, 'python3 -c "[print(i) for i in range(10000)]"\n')
	return require("harpoon."..type).sendCommand(number, command)
end

local function gotoTerminal (opts)
	opts = vim.tbl_deep_extend("force", _opts, opts or {})
	require("harpoon."..opts.terminal.type).gotoTerminal(opts.terminal.number)
end

local function initTerminal(opts)
	opts = vim.tbl_deep_extend("force", _opts, opts or {})
	local args = getCommandArgs(opts.terminal.command_args)
	local file_name = checkFilePath(opts.file_name, opts.cwd)
	local command = getCommand(opts.terminal.command, args, file_name)
	if not state.setTermIsInit(opts.file_name) then
		sendCommand(opts.terminal.number, opts.terminal.type, command)
	end
end

M.view = function (opts)
	opts = vim.tbl_deep_extend("force", _opts, opts or {})
	initTerminal(opts)
	gotoTerminal(opts)
end

-- local function for_each_buf_window(bufnr, fn)
--   if not vim.api.nvim_buf_is_loaded(bufnr) then
--     return
--   end
--
--   for _, window in ipairs(vim.fn.win_findbuf(bufnr)) do
--     fn(window)
--   end
-- end

local function postSplit(current_buf, terminal_buf, func, size)
			vim.api.nvim_set_current_buf(current_buf)
			local current_window = vim.api.nvim_get_current_win()
			local terminal_windows = vim.fn.win_findbuf(terminal_buf)
			for _, terminal_window in ipairs(terminal_windows) do
				if size then
					func(terminal_window, size)
				end
				vim.api.nvim_set_current_win(terminal_window)
				vim.cmd [[norm! G]]
			end
			vim.api.nvim_set_current_win(current_window)
end

M.splitToggle = function (opts)
	opts = vim.tbl_deep_extend("force", _opts, opts or {})
	local state_split_toggle = state.get("splitToggle")
	if not state_split_toggle or not window.is_buf_visible(state_split_toggle) then
		local current_buf = vim.api.nvim_get_current_buf()
		initTerminal(opts)
		gotoTerminal(opts)
		local terminal_buf = vim.api.nvim_get_current_buf()
		if opts.split.choose == "horizontal" then
			vim.cmd [[split]]
			postSplit(current_buf, terminal_buf, vim.api.nvim_win_set_height, opts.split.horizontal.size)
		else
			vim.cmd [[vsplit]]
			postSplit(current_buf, terminal_buf, vim.api.nvim_win_set_width, opts.split.vertical.size)
		end
		state.set("splitToggle", terminal_buf)
	else
		window.close_buf_if_visible(state.get("splitToggle"))
		state.set("splitToggle", false)
	end
end
return M
