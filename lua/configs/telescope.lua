local telescope = require("telescope")
local actions = require("telescope.actions")

telescope.setup({
	defaults = {
		mappings = {
			i = {
				["<C-k>"] = actions.move_selection_previous,
				["<C-j>"] = actions.move_selection_next,
				["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
			},
		},
		file_ignore_patterns = { "node_modules", ".next", ".git" },
		hidden = true,
	},
	pickers = {
		find_files = {
			hidden = true,
			no_ignore = true,
			ignored = true,
		},
	},
	extensions = {
		notify = {},
	},
})

telescope.load_extension("notify")
