require("lazy").setup({

	-- Dashboard
	{
		"folke/snacks.nvim",
		lazy = false,
		priority = 1000,
	},

	-- Fuzzy finder
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.5",
		dependencies = { "nvim-lua/plenary.nvim" },
	},

	-- GitHub integration
	"pwntester/octo.nvim",

	-- Git wrapper
	"tpope/vim-fugitive",

	-- LSP
	{
		"williamboman/mason.nvim",
		lazy = false,
	},

	-- Completion
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
			"onsails/lspkind-nvim",
		},
	},

	-- Formatting
	{
		"stevearc/conform.nvim",
		opts = {},
	},

	-- Linting
	"mfussenegger/nvim-lint",

	-- Syntax highlighting
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
	},

	-- Icons
	"nvim-tree/nvim-web-devicons",

	-- Theme
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
	},

	-- Status line
	"nvim-lualine/lualine.nvim",

	-- Bufferline
	{
		"akinsho/bufferline.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},

	-- Git signs
	"lewis6991/gitsigns.nvim",

	-- Snippets
	"L3MON4D3/LuaSnip",

	-- Keybindings helper
	"folke/which-key.nvim",

	-- Commenting
	"numToStr/Comment.nvim",

	-- Autopairs
	"windwp/nvim-autopairs",

	-- Clipboard
	"ojroques/vim-oscyank",

	-- Search and replace
	{
		"MagicDuck/grug-far.nvim",
		config = function()
			require("grug-far").setup({})
		end,
	},

	-- Noice
	{
		"folke/noice.nvim",
		dependencies = { "MunifTanjim/nui.nvim" },
		config = function()
			require("noice").setup({
				lsp = {
					override = {
						["vim.lsp.util.convert_input_to_markdown_lines"] = true,
						["vim.lsp.util.stylize_markdown"] = true,
						["cmp.entry.get_documentation"] = true,
					},
				},
				presets = {
					bottom_search = true,
					command_palette = true,
					long_message_to_split = true,
					inc_rename = false,
					lsp_doc_border = false,
				},
			})
		end,
	},

	-- smear cursor
	{
		"sphamba/smear-cursor.nvim",
		opts = {},
	},
})
