local state = require("plover_viewer.state")
M = {}
local function for_each_buf_window(bufnr, fn)
  if not vim.api.nvim_buf_is_loaded(bufnr) then
    return
  end

  for _, window in ipairs(vim.fn.win_findbuf(bufnr)) do
    fn(window)
  end
end

local function close_buf_windows(bufnr)
  if not bufnr then
    return
  end

  for_each_buf_window(bufnr, function(window)
    vim.api.nvim_win_close(window, true)
  end)
end

local function _isBufVisible(bufnr)
  local windows = vim.fn.win_findbuf(bufnr)

  return #windows > 0
end

M.isBufVisible = function (bufId)
	bufId = state.get(bufId)
	if bufId and _isBufVisible(bufId) then
		return true
	end
	return false
end

M.closeBufIfVisible = function (bufnr)
	if _isBufVisible(bufnr) then
		close_buf_windows(bufnr)
	end
end

return M

