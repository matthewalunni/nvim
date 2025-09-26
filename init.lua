-- Basic Neovim options
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.termguicolors = true
vim.opt.cursorline = true
vim.opt.wrap = false
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath('data') .. '/undodir'
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.scrolloff = 8
vim.opt.signcolumn = 'yes'
vim.opt.updatetime = 50
vim.opt.colorcolumn = '80'
vim.opt.clipboard = 'unnamedplus'

-- Leader key
vim.g.mapleader = ' '

-- Bootstrap Lazy
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Load plugins
require('plugins')

-- Load configurations
require('configs.snacks')
require('configs.telescope')
require('configs.lsp')
require('configs.conform')
require('configs.lint')
require('configs.treesitter')
require('configs.bufferline')
require('configs.ui')
require('configs.git')
require('configs.keymaps')