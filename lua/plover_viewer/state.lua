M = {}
local _sets = {}

M.update = function (opts)
	M.opts = vim.tbl_deep_extend("force", M.opts or {}, opts or {})
end

M.set = function (key, value)
	_sets[key] = value
end

M.get = function (key)
	if _sets == nil then
		return nil
	end
	return _sets[key]
end

return M

