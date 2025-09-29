 require("lazy").setup({
  checker = { enabled = false },
	-- LSP
	{
		"williamboman/mason.nvim",
		lazy = false,
		config = function()
			require('mason').setup()
		end,
	},

	-- LSP config + setup
	{
		"neovim/nvim-lspconfig",
		dependencies = { "williamboman/mason.nvim", "hrsh7th/cmp-nvim-lsp" },
		config = function()
			local lspconfig = require("lspconfig")
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			-- Lua language server
			lspconfig.lua_ls.setup({
				capabilities = capabilities,
				settings = {
					Lua = {
						format = { enable = true },
					},
				},
			})

			-- Python language server
			lspconfig.pyright.setup({
				capabilities = capabilities,
			})

			-- TypeScript/JavaScript language server
			lspconfig.tsserver.setup({
				capabilities = capabilities,
			})
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

			-- Filetype-specific completion for gitcommit
			cmp.setup.filetype("gitcommit", {
				sources = cmp.config.sources({
					{ name = "git" },
				}, {
					{ name = "buffer" },
				}),
			})

			-- Use buffer source for `/` and `?`
			cmp.setup.cmdline({ "/", "?" }, {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = "buffer" },
				},
			})

			-- Use cmdline & path source for ':'
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

	-- GitHub copilot
	{
		"github/copilot.vim",
		config = function()
			-- Enable Copilot
			vim.g.copilot_enabled = true
		end,
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
	{
		"navarasu/onedark.nvim",
		lazy = false,
		priority = 1000,
	},
	{
		"zaldih/themery.nvim",
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
		version = "1.6.3",
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

	-- Lazygit
	{
		"kdheepak/lazygit.nvim",
		cmd = "LazyGit",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
	},

	-- Yanky
	{
		"gbprod/yanky.nvim",
		opts = {},
	},
})
