local terminal = require("plover_viewer.terminal")
local buf = require("plover_viewer.buf")

M = {}

M.view = function (opts)
	if opts.viewer.choose == "buf" then
		buf.view(opts)
	elseif opts.viewer.choose == "terminal" then
		terminal.view(opts)
	end
end

M.postHooks = function (opts)
	if opts.hooks.initEOF then
		vim.cmd [[norm! G]]
	end
	if opts.hooks.bufWinEnter then
		opts.hooks.bufWinEnter(opts)
	end
end

return M
