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
		file_ignore_patterns = {
			"node_modules",
			".next",
			".git",
			"dist",
			"build",
			"target",
			"*.min.js",
			"*.min.css",
			"*.log",
			"*.lock",
			"package-lock.json",
			"yarn.lock",
			".DS_Store",
			"*.swp",
			"*.swo",
			"*.tmp",
		},
		hidden = true,
	},
	pickers = {
		find_files = {
			hidden = true,
			no_ignore = true,
			search_dirs = { "." },
		},
		live_grep = {
			hidden = true,
			no_ignore = true,
			search_dirs = { "." },
		},
	},
	extensions = {
		notify = {},
	},
})

telescope.load_extension("notify")
