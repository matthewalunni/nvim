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

local function worktrees_section()
  local output = vim.fn.systemlist("git worktree list --porcelain")
  if vim.v.shell_error ~= 0 then return {} end

  -- Parse porcelain output into blocks separated by blank lines
  local worktrees = {}
  local block = {}
  for _, line in ipairs(output) do
    if line == "" then
      if block.path then
        table.insert(worktrees, block)
      end
      block = {}
    elseif line:match("^worktree ") then
      block.path = line:sub(10)
    elseif line:match("^branch ") then
      block.branch = line:sub(8):match("refs/heads/(.+)") or line:sub(8)
    elseif line:match("^detached") then
      block.branch = "HEAD (detached)"
    end
  end
  -- Handle last block (no trailing blank line)
  if block.path then
    table.insert(worktrees, block)
  end

  local cwd = vim.fn.getcwd()
  local items = {}

  for _, wt in ipairs(worktrees) do
    local is_current = wt.path == cwd
    local branch = wt.branch or "unknown"
    local name = branch .. (is_current and "  [current]" or "")
    local path = wt.path
    table.insert(items, {
      name = name,
      action = function()
        vim.cmd("cd " .. vim.fn.fnameescape(path))
        vim.cmd("edit .")
        vim.notify("Switched to: " .. branch)
      end,
      section = "Worktrees",
    })
  end

  return items
end

starter.setup({
  header = function()
    return vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
  end,
  sections = {
    worktrees_section,
  },
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
