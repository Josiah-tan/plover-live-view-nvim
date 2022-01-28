M = {}

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

M.getFilePath = function (file_name, cwds)
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

return M
