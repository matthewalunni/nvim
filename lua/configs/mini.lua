-- basic mini configurations
-- Mini icons
require("mini.icons").setup()

-- Mini basics
require("mini.basics").setup()

-- Mini ai
require("mini.ai").setup()

-- Mini pairs
require("mini.pairs").setup()

-- Mini comment
require("mini.comment").setup()

-- Mini surround
require("mini.surround").setup()

-- Mini starter (dashboard)
local starter = require("mini.starter")

starter.setup({
  header = function()
    return vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
  end,
  sections = {},
  footer = function()
    local ok, lazy = pcall(require, "lazy")
    if ok then
      return string.format("⚡ %.0fms", lazy.stats().startuptime)
    end
    return ""
  end,
  content_hooks = {
    starter.gen_hook.adding_bullet("  "),
    starter.gen_hook.aligning("center", "center"),
  },
})
