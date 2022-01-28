M = {}

M.builtin = {
	viewer = {
		choose = "terminal", -- or buf
		buf = {
		},
		terminal = {
			type = "term", -- or "tmux"
			number = 6,
			command = "tail",
			args = {"-f", "---disable-inotify"}, -- disable-inotify, makes plugin work for wsl
		},
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
	hooks = {
		initEOF = true,
		-- not actually implemented with autocommands...
		bufWinEnter = function(opts) print("entering!", vim.api.nvim_get_current_buf()) end, -- require("autoread.builtin").autoReadStart,
		bufWinLeave = function(opts) print("leaving!", vim.api.nvim_get_current_buf()) end, -- require("autoread.builtin").autoReadStop
	},
	file_name = "clippy.txt",
}

M.mappings = function ()
	vim.keymap.set('n', '<leader>pv', function () require("plover_viewer.builtin").view() end)
	-- split the current buffer and view clippy.txt in the terminal (togglable)
	vim.keymap.set('n', '<leader>ps', function () require("plover_viewer.builtin").splitToggle() end)
	-- view tapey_tape.txt in terminal
	vim.keymap.set('n', '<leader>pt', function () RELOAD("plover_viewer.builtin").splitToggle({
		file_name = "tapey_tape.txt",
		viewer = {
			terminal = {
				number = 7 -- use a different terminal
			}
		},
		split = {
			choose = "vertical"
		}
	}) end)
end

M.opts = {
	builtin = M.builtin,
	disable_default_mappings = true,
}

return M
