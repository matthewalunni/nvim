-- Theme
vim.cmd([[colorscheme tokyonight]])

-- Lualine
require('lualine').setup({
  options = {
    theme = 'tokyonight',
  },
})

-- Gitsigns
require('gitsigns').setup()

-- Which-key
require('which-key').setup()

-- Autopairs
require('nvim-autopairs').setup()

-- Comment
require('Comment').setup()

-- OSC Yank
vim.g.oscyank_term = 'default'
vim.api.nvim_create_autocmd('TextYankPost', {
  pattern = '*',
  callback = function()
    if vim.v.event.operator == 'y' and vim.v.event.regname == '' then
      vim.cmd('OSCYankReg "')
    end
  end,
})