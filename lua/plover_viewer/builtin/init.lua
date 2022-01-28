M = {}
local _opts = require("plover_viewer.state").opts.builtin
local state = require("plover_viewer.state")
-- local window = require("plover_viewer.window")
-- local path = require("plover_viewer.path")
local split = require("plover_viewer.split")
local display = require("plover_viewer.display")





M.view = function (opts)
	opts = vim.tbl_deep_extend("force", _opts, opts or {})
	display.view(opts)
	display.postHooks(opts)
end


-- local function getBufState (fn, number)
-- 	return string.format("%s%d", fn, number)
-- end




M.splitToggle = function (opts)
	opts = vim.tbl_deep_extend("force", _opts, opts or {})
	if split.isVisible(opts) then
		split.close(opts)
	else
		split.open(opts)
	end

	-- local bufId = getBufState("splitToggle", opts.viewer.terminal.number)
	-- local state_split_toggle = state.get(bufId)
	-- if not state_split_toggle or not window.is_buf_visible(state_split_toggle) then
	-- 	local current_buf = vim.api.nvim_get_current_buf()
	-- 	open(opts)
	-- 	local viewer_buf = vim.api.nvim_get_current_buf()
	-- 	if opts.split.choose == "horizontal" then
	-- 		vim.cmd [[split]]
	-- 		split.post(current_buf, viewer_buf, vim.api.nvim_win_set_height, opts.split.horizontal.size)
	-- 	else
	-- 		vim.cmd [[vsplit]]
	-- 		split.post(current_buf, viewer_buf, vim.api.nvim_win_set_width, opts.split.vertical.size)
	-- 	end
	-- 	state.set(bufId, viewer_buf)
	-- else
	-- 	window.closeBufIfVisible(state.get(bufId))
	-- 	state.set(state.get(bufId), false)
	-- end
end

return M
