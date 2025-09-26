require("snacks").setup({
	lsp = {
		signature = true,
		progress = true,
	},
	cmdline = {
		enabled = true,
	},
	messages = {
		enabled = true,
		view = "mini", -- or "notify" if you use `nvim-notify`
	},
	dashboard = {
		enabled = true,
		sections = {
			{ section = "header" },
			{
				pane = 2,
				section = "terminal",
				cmd = "echo 'Welcome to Neovim!'",
				height = 5,
				padding = 1,
			},
			{ section = "keys", gap = 1, padding = 1 },
			{ section = "startup" },
		},
	},
	explorer = {
		enabled = true,
	},
	indent = {
		enabled = true,
	},
	picker = {
		sources = {
			explorer = {
				hidden = true,
			},
		},
	},
	view = {
		backend = "popup", -- could also be "mini", "notify", etc.
		timeout = 2000, -- duration in milliseconds
		format = "rounded", -- border style
	},
	toggle = {},
	input = {},
	notifier = {},
	terminal = {},
})

vim.notify = require("snacks").notify
