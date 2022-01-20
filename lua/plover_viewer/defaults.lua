M = {}

M.builtins = {
	terminal = {
		type = "term", -- or "tmux"
		number = 6,
		command = "tail",
		command_args = {"-f"},
	},
	file_name = "clippy.txt"
}

M.mappings = function ()
	vim.keymap.set('n', '<leader>pv', function () require("plover_viewer.builtins").view() end)
	vim.keymap.set('n', '<leader>pt', function () require("plover_viewer.builtins").view({file_name = "tapey_tape.txt"}) end)
	-- cde
end


return M
