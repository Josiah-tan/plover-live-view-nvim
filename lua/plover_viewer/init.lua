M = {}

local default = require("plover_viewer.default")
local state = require("plover_viewer.state")


M.setup = function (opts)
	opts = vim.tbl_deep_extend("force", default.opts, opts or {})
	state.update(opts)
	if not opts.disable_default_mappings then
		defaults.mappings()
	end
end


return M
