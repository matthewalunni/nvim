require('lint').linters_by_ft = {
  lua = { 'luacheck' },
  python = { 'flake8' },
  javascript = { 'eslint' },
  typescript = { 'eslint' },
}

vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
  callback = function()
    require('lint').try_lint()
  end,
})