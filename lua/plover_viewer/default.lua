M = {}

M.builtin = {
	terminal = {
		type = "term", -- or "tmux"
		number = 6,
		command = "tail",
		command_args = {"-f"},
	},
	split = {
		choose = "horizontal", -- or vertical
		horizontal = {
			size = 10,
		},
		vertical = {
			size = nil,
		}
	},
	file_name = "clippy.txt",
}

M.mappings = function ()
	vim.keymap.set('n', '<leader>pv', function () require("plover_viewer.builtin").view() end)
	vim.keymap.set('n', '<leader>pt', function () require("plover_viewer.builtin").view({file_name = "tapey_tape.txt"}) end)
end

M.opts = {
	builtin = M.builtin,
	disable_default_mappings = true,
}

return M