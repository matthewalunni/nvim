require('lazy').setup({

  -- Dashboard
  {
    'folke/snacks.nvim',
    lazy = false,
    priority = 1000,
  },

  -- Fuzzy finder
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.5',
    dependencies = { 'nvim-lua/plenary.nvim' },
  },

  -- GitHub integration
  'pwntester/octo.nvim',

  -- Git wrapper
  'tpope/vim-fugitive',

  -- LSP
  {
    'williamboman/mason.nvim',
    lazy = false,
  },

  -- Completion
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
      'onsails/lspkind-nvim',
    },
  },

  -- Formatting
  {
    'stevearc/conform.nvim',
    opts = {},
  },

  -- Linting
  'mfussenegger/nvim-lint',

  -- Syntax highlighting
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
  },



  -- Icons
  'nvim-tree/nvim-web-devicons',

  -- Theme
  {
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 1000,
  },

  -- Status line
  'nvim-lualine/lualine.nvim',

  -- Git signs
  'lewis6991/gitsigns.nvim',

  -- Snippets
  'L3MON4D3/LuaSnip',

  -- Keybindings helper
  'folke/which-key.nvim',

  -- Commenting
  'numToStr/Comment.nvim',

  -- Autopairs
  'windwp/nvim-autopairs',

  -- Clipboard
  'ojroques/vim-oscyank',


    -- smear cursor 
{
  "sphamba/smear-cursor.nvim",
  opts = {},
}
})
