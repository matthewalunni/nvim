require("lazy").setup({
	checker = { enabled = false },
	-- LSP
	{
		"williamboman/mason.nvim",
		lazy = false,
		config = function()
			require("mason").setup()
		end,
	},

	-- LSP config + setup
	{
		"neovim/nvim-lspconfig",
		dependencies = { "williamboman/mason.nvim", "hrsh7th/cmp-nvim-lsp" },
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			vim.lsp.config("lua_ls", {
				capabilities = capabilities,
				settings = {
					Lua = {
						format = { enable = true },
						completion = { callSnippet = "Replace" },
						diagnostics = {
							globals = { "vim" },
							disable = { "missing-fields" },
						},
						workspace = {
							library = vim.api.nvim_get_runtime_file("", true),
							checkThirdParty = false,
						},
					},
				},
			})
			vim.lsp.enable("lua_ls")

			vim.lsp.config("pyright", { capabilities = capabilities })
			vim.lsp.enable("pyright")

			vim.lsp.config("ts_ls", {
				cmd = { "typescript-language-server", "--stdio" },
				init_options = {
					hostInfo = "neovim",
					preferences = {
						includeCompletionsForModuleExports = true,
						includeCompletionsForImportStatements = true,
						importModuleSpecifierPreference = "relative",
					},
				},
				capabilities = capabilities,
			})
			vim.lsp.enable("ts_ls")

			vim.lsp.config("gopls", { capabilities = capabilities })
			vim.lsp.enable("gopls")
		end,
	},

	-- Completion framework
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
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			local lspkind = require("lspkind")

			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
				}, {
					{ name = "buffer" },
				}),
				formatting = {
					format = lspkind.cmp_format({
						mode = "symbol_text",
						maxwidth = 50,
						ellipsis_char = "...",
					}),
				},
			})

			cmp.setup.filetype("gitcommit", {
				sources = cmp.config.sources({
					{ name = "git" },
				}, {
					{ name = "buffer" },
				}),
			})

			cmp.setup.cmdline({ "/", "?" }, {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = "buffer" },
				},
			})

			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = "path" },
				}, {
					{ name = "cmdline" },
				}),
			})
		end,
	},

	-- Dashboard / utilities (must be eager)
	{
		"folke/snacks.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("configs.snacks")
		end,
	},

	-- File explorer
	{
		"stevearc/oil.nvim",
		cmd = "Oil",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("oil").setup({
				view_options = { show_hidden = true },
			})
		end,
	},

	-- Quickfix improvements
	{
		"stevearc/quicker.nvim",
		ft = "qf",
		keys = { "<leader>q", "<leader>l" },
		config = function()
			require("quicker").setup({
				preview = true,
			})
		end,
	},

	-- Formatting
	{
		"stevearc/conform.nvim",
		opts = {},
	},

	-- Linting
	{
		"mfussenegger/nvim-lint",
		event = "BufReadPre",
		config = function()
			require("configs.lint")
		end,
	},

	-- Syntax highlighting
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
	},

	-- Icons (pulled in as a dependency, not directly)
	{ "nvim-tree/nvim-web-devicons", lazy = true },

	-- Themes
	{ "folke/tokyonight.nvim", lazy = true },
	{ "navarasu/onedark.nvim", lazy = true },
	{
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = true,
		config = function()
			require("catppuccin").setup({
				flavour = "mocha",
				transparent_background = true,
			})
		end,
	},

	-- Theme switcher
	{
		"zaldih/themery.nvim",
		cmd = "Themery",
		config = function()
			require("themery").setup({
				themes = { "tokyonight", "onedark", "catppuccin-mocha", "earthcode" },
				livePreview = true,
			})
		end,
	},

	-- Status line
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
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
		end,
	},

	-- Undotree
	{
		"mbbill/undotree",
		cmd = { "UndotreeToggle", "UndotreeShow" },
	},

	-- Bufferline
	{
		"akinsho/bufferline.nvim",
		event = "VeryLazy",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("configs.bufferline")
		end,
	},

	-- Git signs
	{
		"lewis6991/gitsigns.nvim",
		event = "BufReadPre",
		config = true,
	},

	-- Keybindings helper
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		config = function()
			require("which-key").setup({
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
		end,
	},

	-- Mini
	{
		"nvim-mini/mini.nvim",
		version = false,
	},

	-- Clipboard / OSC yank
	{
		"ojroques/vim-oscyank",
		event = "VeryLazy",
		config = function()
			vim.g.oscyank_term = "default"
			vim.api.nvim_create_autocmd("TextYankPost", {
				pattern = "*",
				callback = function()
					if vim.v.event.operator == "y" and vim.v.event.regname == "" then
						vim.cmd('OSCYankReg "')
					end
				end,
			})
		end,
	},

	-- Search and replace
	{
		"MagicDuck/grug-far.nvim",
		version = "1.6.3",
		config = function()
			require("grug-far").setup({})
		end,
	},

	-- Motion / flash
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		opts = {},
	},

	-- Fugitive
	{ "tpope/vim-fugitive", cmd = { "Git", "Gvdiffsplit" } },

	-- Diffview (git diffs)
	{
		"sindrets/diffview.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFileHistory" },
		config = function()
			require("diffview").setup({})
		end,
	},

	-- Yanky
	{ "gbprod/yanky.nvim", event = "VeryLazy", opts = {} },

	{
		"norcalli/nvim-colorizer.lua",
		event = "BufReadPre",
		config = function()
			require("colorizer").setup()
		end,
	},

	-- Earthcode (must be eager to set colorscheme at startup)
	{
		"matthewalunni/earthcode.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			vim.cmd.colorscheme("earthcode")
		end,
	},

	-- nit.nvim
	{
		"matthewalunni/nit.nvim",
		config = function()
			require("nit").setup()
		end,
	},

	-- Remote (restore when publishing)
	{
		"matthewalunni/gitflix.nvim",
		config = function() end,
		keys = {
			{ "<leader>gf", "<cmd>Gitflix<cr>", desc = "Gitflix" },
		},
	},
})
