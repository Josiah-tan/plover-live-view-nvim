M = {}
M.opts = require("plover_viewer.config").opts
M.view = function (opts)
	opts = vim.tbl_deep_extend("force", M.opts, opts or {})
end
return M
