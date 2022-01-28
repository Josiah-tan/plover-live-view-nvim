M = {}

local path = require("plover_viewer.path")
local state = require("plover_viewer.state")
local window = require("plover_viewer.window")

M.isVisible = function (opts)
	local bufId = "bufVisible"..opts.file_name
	return window.isBufVisible(bufId)
end

M.close = function (opts)
	local bufId = "bufVisible"..opts.file_name
	window.closeBufIfVisible(state.get(bufId))
end

M.view = function (opts)
	local file_name = path.getFilePath(opts.file_name, opts.cwd)
	vim.cmd("view " .. file_name)
end

M.setBufnr = function (opts, bufnr)
	local bufId = "bufVisible"..opts.file_name
	state.set(bufId, bufnr)
end

return M
