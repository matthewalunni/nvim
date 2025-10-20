require('lint').linters_by_ft = {
  lua = { 'luacheck' },
  python = { 'flake8', 'mypy' },
  javascript = { 'eslint' },
  typescript = { 'eslint' },
  javascriptreact = { 'eslint' },
  typescriptreact = { 'eslint' },
  json = { 'jsonlint' },
  yaml = { 'yamllint' },
  markdown = { 'markdownlint' },
  bash = { 'shellcheck' },
  sh = { 'shellcheck' },
  zsh = { 'shellcheck' },
  go = { 'golangci-lint' },
}

vim.api.nvim_create_autocmd({ 'BufWritePost', 'BufEnter', 'InsertLeave' }, {
  callback = function()
    require('lint').try_lint()
  end,
})