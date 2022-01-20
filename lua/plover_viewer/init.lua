M = {}

M.opts = {
	builtins = require("plover_viewer.defaults").builtins,
	disable_default_mappings = true
}

M.setup = function (opts)
	M.opts = vim.tbl_deep_extend("force", M.opts, opts or {})
	if not M.opts.disable_default_mappings then
		require("plover_viewer.defaults").mappings()
	end
end

return M
