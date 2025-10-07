-- Theme
vim.cmd([[colorscheme catppuccin-mocha]])

-- Onedark
require("onedark").setup({
	style = "darker",
})

-- Catppuccin
require("catppuccin").setup({
	flavour = "mocha",
})

-- Themery
require("themery").setup({
	themes = { "tokyonight", "onedark", "catppuccin-mocha" },
	livePreview = true,
})

-- Lualine
require("lualine").setup({
	options = {
		theme = "tokyonight",
	},
})

-- Gitsigns
require("gitsigns").setup()

-- Which-key
local wk = require("which-key")
wk.setup({
	plugins = {
		marks = true,
		registers = true,
		spelling = {
			enabled = true,
			suggestions = 20,
		},
		presets = {
			operators = false,
			motions = false,
			text_objects = false,
			windows = false,
			nav = false,
			z = false,
			g = false,
		},
	},
	icons = {
		breadcrumb = "»",
		separator = "➜",
		group = "+",
	},
	keys = {
		scroll_down = "<c-d>",
		scroll_up = "<c-u>",
	},
	win = {
		border = "rounded",
		padding = { 1, 2 },
		title = true,
		title_pos = "center",
		zindex = 1000,
	},
	layout = {
		height = { min = 4, max = 25 },
		width = { min = 20, max = 50 },
		spacing = 3,
		align = "left",
	},
	show_help = true,
	show_keys = true,
	preset = "helix",
})

-- Mini pairs
require("mini.pairs").setup()

-- Mini comment
require("mini.comment").setup()

-- Mini ai
require("mini.ai").setup()

-- OSC Yank
vim.g.oscyank_term = "default"
vim.api.nvim_create_autocmd("TextYankPost", {
	pattern = "*",
	callback = function()
		if vim.v.event.operator == "y" and vim.v.event.regname == "" then
			vim.cmd('OSCYankReg "')
		end
	end,
})

-- Lazygit
vim.g.lazygit_use_custom_config_file_path = 1
vim.g.lazygit_config_file_path = vim.fn.expand("~/.config/lazygit/config.yml")

-- Notify
require("notify").setup({
	background_colour = "#000000",
})
vim.notify = require("notify")
