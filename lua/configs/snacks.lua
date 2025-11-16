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
		preset = {
			-- Used by the `keys` section to show keymaps.
			-- Set your custom keymaps here.
			-- When using a function, the `items` argument are the default keymaps.
			---@type snacks.dashboard.Item[]
			keys = {
				{ icon = " ", key = "f", desc = "Find File", action = "<leader>ff" },
				{ icon = " ", key = "s", desc = "Find Text", action = "<leader>sg" },
				{ icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },

				{ icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
				{
					icon = " ",
					key = "c",
					desc = "Config",
					action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
				},
				{ icon = "", key = "g", desc = "Git Actions", action = "<leader>lg" },

				{ icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
				{ icon = " ", key = "q", desc = "Quit", action = ":qa" },
			},
		},
		sections = {
			{ section = "header" },
			{ pane = 1, section = "keys", gap = 1, padding = 1 },
			{ pane = 2, icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
			{ pane = 2, icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
			{
				pane = 2,
				icon = " ",
				desc = "Browse Repo",
				padding = 1,
				key = "b",
				action = function()
					Snacks.gitbrowse()
				end,
			},
			function()
				local in_git = Snacks.git.get_root() ~= nil
				local cmds = {
					{
						icon = " ",
						title = "Git Status",
						cmd = "git --no-pager diff --stat -B -M -C",
						height = 10,
					},
					{
						icon = " ",
						title = "Open PRs",
						cmd = "gh pr list -L 3",
						key = "P",
						action = function()
							vim.fn.jobstart("gh pr list --web", { detach = true })
						end,
						height = 7,
					},
				}
				return vim.tbl_map(function(cmd)
					return vim.tbl_extend("force", {
						pane = 2,
						section = "terminal",
						enabled = in_git,
						padding = 1,
						ttl = 5 * 60,
						indent = 3,
					}, cmd)
				end, cmds)
			end,

			{ section = "startup" },
		},
	},
	indent = {
		enabled = true,
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
	picker = {
		layout = "default", -- options are "select", "dropdown", "telescope", "ivy", "ivy_split"
		sources = {
			explorer = {
				hidden = true,
				ignored = true,
			},
		},
	},
	lazygit = {},
    gh={},
})

vim.notify = require("snacks").notify
