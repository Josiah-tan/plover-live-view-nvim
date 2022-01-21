M = {}
local _sets = {}
local _termIsInit = {}

M.update = function (opts)
	M.opts = vim.tbl_deep_extend("force", M.opts or {}, opts or {})
end

M.setTermIsInit = function (value)
	if _termIsInit[value] ~= nil then
		return true
	end
	_termIsInit[value] = true
	return false
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

