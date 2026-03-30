-- Theme
vim.cmd([[colorscheme catppuccin-mocha]])

-- Onedark
require("onedark").setup({
	style = "darker",
})

-- Catppuccin
require("catppuccin").setup({
	flavour = "mocha",
	transparent_background = true,
})

-- Themery
require("themery").setup({
	themes = { "tokyonight", "onedark", "catppuccin-mocha", "earthcode" },
	livePreview = true,
})

-- Lualine
local function lualine_theme()
	local cs = vim.g.colors_name
	if cs == "earthcode" then
		return require("earthcode.integrations.lualine").theme()
	end
	return cs or "auto"
end

require("lualine").setup({ options = { theme = lualine_theme() } })

vim.api.nvim_create_autocmd("ColorScheme", {
	callback = function()
		require("lualine").setup({ options = { theme = lualine_theme() } })
	end,
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

-- Notify
require("notify").setup({
	background_colour = "#000000",
})
vim.notify = require("notify")
