local display = require("plover_viewer.display")
local terminal = require("plover_viewer.terminal")
local buf = require("plover_viewer.buf")

M = {}

local setBufnr = function(opts, bufnr)
	if opts.viewer.choose == "buf" then
		return buf.setBufnr(opts, bufnr)
	elseif opts.viewer.choose == "terminal" then
		return terminal.setBufnr(opts, bufnr)
	end
end

M.isVisible = function (opts)
	if opts.viewer.choose == "buf" then
		return buf.isVisible(opts)
	elseif opts.viewer.choose == "terminal" then
		return terminal.isVisible(opts)
	end
end

M.close = function (opts)
	if opts.viewer.choose == "buf" then
		buf.close(opts)
	elseif opts.viewer.choose == "terminal" then
		terminal.close(opts)
	end
	opts.hooks.bufWinLeave(opts)
end

local adjustSize = function (func, viewer_win, size)
	if size then
		func(viewer_win, size)
	end
end

local initEOF = function(viewer_win, initEOF)
	if initEOF then
		vim.api.nvim_set_current_win(viewer_win)
		vim.cmd [[norm! G]]
	end
end


local customise = function (current_buf, viewer_buf, func, size, opts)
	vim.api.nvim_set_current_buf(current_buf)
	local current_win = vim.api.nvim_get_current_win()
	local viewer_wins = vim.fn.win_findbuf(viewer_buf)
	for _, viewer_win in ipairs(viewer_wins) do
		adjustSize(func, viewer_win, size)
		initEOF(viewer_win, opts.hooks.initEOF)
	end
	opts.hooks.bufWinEnter(opts)
	vim.api.nvim_set_current_win(current_win)
end

local horizontal = function (opts, viewer_buf, current_buf)
	vim.cmd [[split]]
	customise(current_buf, viewer_buf, vim.api.nvim_win_set_height, opts.split.horizontal.size, opts)
end

local vertical = function (opts, viewer_buf, current_buf)
	vim.cmd [[vsplit]]
	customise(current_buf, viewer_buf, vim.api.nvim_win_set_width, opts.split.vertical.size, opts)
end

local exeSplit = function (opts, viewer_buf, current_buf)
	if opts.split.choose == "horizontal" then
		horizontal(opts, viewer_buf, current_buf)
	elseif opts.split.choose == "vertical" then
		vertical(opts, viewer_buf, current_buf)
	end
end

M.open = function (opts)
	local current_buf = vim.api.nvim_get_current_buf()
	display.view(opts)
	local viewer_buf = vim.api.nvim_get_current_buf()
	exeSplit(opts, viewer_buf, current_buf)
	setBufnr(opts, viewer_buf)
end

return M
