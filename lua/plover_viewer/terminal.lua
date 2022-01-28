M = {}

local path = require("plover_viewer.path")
local window = require("plover_viewer.window")
local state = require("plover_viewer.state")

local function getArgs(args)
	local res = ""
	for _, name in ipairs(args) do
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

local function _view(opts)
	require("harpoon."..opts.viewer.terminal.type).gotoTerminal(opts.viewer.terminal.number)
end

local function init(opts)
	local args = getArgs(opts.viewer.terminal.args)
	local file_name = path.getFilePath(opts.file_name, opts.cwd)
	local command = getCommand(opts.viewer.terminal.command, args, file_name)

	local started = "started"..opts.viewer.terminal.number
	if not state.get(started) then
		sendCommand(opts.viewer.terminal.number, opts.viewer.terminal.type, command)
		state.set(started, true)
	end
end

M.isVisible = function (opts)
	local bufId = "terminalVisible"..opts.viewer.terminal.number
	return window.isBufVisible(bufId)
end

M.close = function (opts)
	local bufId = "terminalVisible"..opts.viewer.terminal.number
	window.closeBufIfVisible(state.get(bufId))
end

M.view = function (opts)
	init(opts)
	_view(opts)
end

M.setBufnr = function (opts, bufnr)
	local bufId = "terminalVisible"..opts.viewer.terminal.number
	state.set(bufId, bufnr)
end

return M
