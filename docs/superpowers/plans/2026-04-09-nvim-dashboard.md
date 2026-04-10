# Neovim Dashboard Redesign Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace the slow Snacks dashboard with a fast `mini.starter` dashboard centered on git worktree management.

**Architecture:** Disable Snacks dashboard; configure `mini.starter` (already installed via `mini.nvim`) with four sections — Worktrees, Git Status, Recent Files, Quick Keys — all rendered synchronously on open. Worktree CRUD lives in an extended `<leader>gw` Snacks picker that works from anywhere.

**Tech Stack:** Lua, mini.nvim (mini.starter), Snacks.nvim (picker), git CLI

---

## File Map

| File | Change |
|---|---|
| `lua/configs/snacks.lua` | Disable dashboard section |
| `lua/configs/mini.lua` | Add full `mini.starter` setup with section helpers |
| `lua/configs/keymaps.lua` | Rewrite `<leader>gw`; update `<leader>h` |

---

## Task 1: Disable Snacks Dashboard

**Files:**
- Modify: `lua/configs/snacks.lua`

- [ ] **Step 1: Add `enabled = false` to the dashboard table**

In `lua/configs/snacks.lua`, replace:
```lua
dashboard = {

  sections = {
```
with:
```lua
dashboard = {
  enabled = false,
  sections = {
```

- [ ] **Step 2: Verify**

Open nvim with no file arguments (`nvim`). You should see an empty buffer, not the Snacks dashboard. No errors in `:messages`.

- [ ] **Step 3: Commit**

```bash
git add lua/configs/snacks.lua
git commit -m "feat: disable snacks dashboard"
```

---

## Task 2: Scaffold mini.starter with Header and Footer

**Files:**
- Modify: `lua/configs/mini.lua`

- [ ] **Step 1: Add basic mini.starter setup at the bottom of `lua/configs/mini.lua`**

```lua
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
```

- [ ] **Step 2: Verify**

Open nvim with no file arguments. You should see a centered mini.starter buffer showing the current directory name as the header and startup time as the footer. No sections yet.

- [ ] **Step 3: Commit**

```bash
git add lua/configs/mini.lua
git commit -m "feat: scaffold mini.starter with header/footer"
```

---

## Task 3: Add Worktrees Section (Display + Switch)

**Files:**
- Modify: `lua/configs/mini.lua`

- [ ] **Step 1: Add the `worktrees_section` helper above the `starter.setup()` call**

```lua
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
```

- [ ] **Step 2: Add `worktrees_section` to the `sections` table in `starter.setup()`**

Replace `sections = {},` with:
```lua
sections = {
  worktrees_section,
},
```

- [ ] **Step 3: Verify**

Open nvim with no arguments inside a git repo that has at least one worktree. You should see the Worktrees section listing each worktree by branch name, with `[current]` on the active one. Press the letter key next to a worktree — it should `cd` into that path and open the directory. Open nvim outside a git repo — worktrees section should be absent with no errors.

- [ ] **Step 4: Commit**

```bash
git add lua/configs/mini.lua
git commit -m "feat: add worktrees section to mini.starter"
```

---

## Task 4: Add Worktree Creation from Dashboard

**Files:**
- Modify: `lua/configs/mini.lua`

- [ ] **Step 1: Add a `+` item at the end of `worktrees_section`, inside the existing function, just before `return items`**

```lua
  -- "+" item to create a new worktree
  table.insert(items, {
    name = "+ new worktree",
    action = function()
      vim.ui.input({ prompt = "Branch name: " }, function(branch)
        if not branch or branch == "" then return end
        local root = vim.fn.fnamemodify(vim.fn.getcwd(), ":h")
        local repo = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
        local path = root .. "/" .. repo .. "-" .. branch
        local result = vim.fn.system(
          "git worktree add " .. vim.fn.shellescape(path) .. " " .. vim.fn.shellescape(branch) .. " 2>&1"
        )
        if vim.v.shell_error ~= 0 then
          vim.notify("Failed to create worktree:\n" .. result, vim.log.levels.ERROR)
          return
        end
        vim.cmd("cd " .. vim.fn.fnameescape(path))
        vim.cmd("edit .")
        vim.notify("Created and switched to: " .. branch)
      end)
    end,
    section = "Worktrees",
  })
```

- [ ] **Step 2: Verify**

Open mini.starter inside a git repo. Press the key next to `+ new worktree`. Enter a branch name that exists (`main`, or a real branch). Nvim should cd into the new worktree path. Enter a non-existent branch — you should see an error notification.

- [ ] **Step 3: Commit**

```bash
git add lua/configs/mini.lua
git commit -m "feat: add worktree creation from dashboard"
```

---

## Task 5: Add Git Status Section

**Files:**
- Modify: `lua/configs/mini.lua`

- [ ] **Step 1: Add the `git_status_section` helper above `starter.setup()`**

```lua
local function git_status_section()
  local output = vim.fn.systemlist("git status --short")
  if vim.v.shell_error ~= 0 or #output == 0 then return {} end

  local items = {}
  for _, line in ipairs(output) do
    table.insert(items, {
      name = line,
      action = "",
      section = "Git Status",
    })
  end
  return items
end
```

- [ ] **Step 2: Add `git_status_section` to the `sections` table**

```lua
sections = {
  worktrees_section,
  git_status_section,
},
```

- [ ] **Step 3: Verify**

Open nvim inside a git repo with uncommitted changes. The Git Status section should list changed files with M/A/? prefixes. Open inside a clean repo — no Git Status section. Open outside a git repo — no Git Status section, no errors.

- [ ] **Step 4: Commit**

```bash
git add lua/configs/mini.lua
git commit -m "feat: add git status section to mini.starter"
```

---

## Task 6: Add Recent Files and Quick Keys Sections

**Files:**
- Modify: `lua/configs/mini.lua`

- [ ] **Step 1: Add the `quick_keys_section` helper above `starter.setup()`**

```lua
local function quick_keys_section()
  local keys = {
    "<leader>gw    worktree picker — create / delete / rename",
    "<leader>lg    lazygit",
    "<leader>sg    grep",
    "<leader>ff    find files",
    "<leader>fb    buffers",
    "<leader>gd    diffview",
    "<leader>gs    git status picker",
  }
  local items = {}
  for _, line in ipairs(keys) do
    table.insert(items, {
      name = line,
      action = "",
      section = "Quick Keys",
    })
  end
  return items
end
```

- [ ] **Step 2: Update the `sections` table to include all four sections**

```lua
sections = {
  worktrees_section,
  git_status_section,
  starter.sections.recent_files({ n = 5, current_dir = false }),
  quick_keys_section,
},
```

- [ ] **Step 3: Verify**

Open nvim. All four sections should appear: Worktrees, Git Status (if dirty), Recent Files, Quick Keys. Recent files should be lettered, continuing after worktree letters. Quick keys and git status lines should appear without letter bullets (they have `action = ""`).

- [ ] **Step 4: Commit**

```bash
git add lua/configs/mini.lua
git commit -m "feat: add recent files and quick keys sections to mini.starter"
```

---

## Task 7: Rewrite `<leader>gw` Picker with Full CRUD

**Files:**
- Modify: `lua/configs/keymaps.lua`

- [ ] **Step 1: Replace the entire `<leader>gw` keymap block (lines 179–222) with the following**

```lua
-- Git worktree picker with create / delete / rename / switch
map("n", "<leader>gw", function()
  local function get_worktrees()
    local output = vim.fn.systemlist("git worktree list --porcelain")
    if vim.v.shell_error ~= 0 then
      vim.notify("Not a git repo or git worktree unavailable", vim.log.levels.ERROR)
      return nil
    end
    local worktrees = {}
    local block = {}
    for _, line in ipairs(output) do
      if line == "" then
        if block.path then table.insert(worktrees, block) end
        block = {}
      elseif line:match("^worktree ") then
        block.path = line:sub(10)
      elseif line:match("^branch ") then
        block.branch = line:sub(8):match("refs/heads/(.+)") or line:sub(8)
      elseif line:match("^detached") then
        block.branch = "HEAD (detached)"
      end
    end
    if block.path then table.insert(worktrees, block) end
    return worktrees
  end

  local worktrees = get_worktrees()
  if not worktrees then return end

  local cwd = vim.fn.getcwd()
  local items = vim.tbl_map(function(wt)
    local branch = wt.branch or "unknown"
    local is_current = wt.path == cwd
    return {
      text = branch .. (is_current and "  [current]" or ""),
      subtext = wt.path,
      value = wt,
    }
  end, worktrees)

  Snacks.picker({
    title = "Git Worktrees  [<CR>switch  n=new  d=delete  r=rename]",
    items = items,
    format = "text",
    actions = {
      wt_switch = function(picker)
        local item = picker:current()
        if not item then return end
        picker:close()
        vim.cmd("cd " .. vim.fn.fnameescape(item.value.path))
        vim.cmd("edit .")
        vim.notify("Switched to: " .. (item.value.branch or "unknown"))
      end,
      wt_create = function(picker)
        picker:close()
        vim.ui.input({ prompt = "Branch name: " }, function(branch)
          if not branch or branch == "" then return end
          local root = vim.fn.fnamemodify(cwd, ":h")
          local repo = vim.fn.fnamemodify(cwd, ":t")
          local path = root .. "/" .. repo .. "-" .. branch
          local result = vim.fn.system(
            "git worktree add " .. vim.fn.shellescape(path) .. " " .. vim.fn.shellescape(branch) .. " 2>&1"
          )
          if vim.v.shell_error ~= 0 then
            vim.notify("Failed to create worktree:\n" .. result, vim.log.levels.ERROR)
            return
          end
          vim.cmd("cd " .. vim.fn.fnameescape(path))
          vim.cmd("edit .")
          vim.notify("Created and switched to: " .. branch)
        end)
      end,
      wt_delete = function(picker)
        local item = picker:current()
        if not item then return end
        local path = item.value.path
        local branch = item.value.branch or "unknown"
        if path == cwd then
          vim.notify("Cannot delete the current worktree", vim.log.levels.ERROR)
          return
        end
        vim.ui.input({ prompt = "Delete worktree '" .. branch .. "'? (y/N): " }, function(confirm)
          if confirm ~= "y" and confirm ~= "Y" then return end
          picker:close()
          local result = vim.fn.system("git worktree remove " .. vim.fn.shellescape(path) .. " 2>&1")
          if vim.v.shell_error ~= 0 then
            vim.notify("Failed to delete worktree:\n" .. result, vim.log.levels.ERROR)
            return
          end
          vim.notify("Deleted worktree: " .. branch)
        end)
      end,
      wt_rename = function(picker)
        local item = picker:current()
        if not item then return end
        local old_path = item.value.path
        local branch = item.value.branch or "unknown"
        vim.ui.input({ prompt = "New path for '" .. branch .. "': ", default = old_path }, function(new_path)
          if not new_path or new_path == "" or new_path == old_path then return end
          picker:close()
          local result = vim.fn.system(
            "git worktree move " .. vim.fn.shellescape(old_path) .. " " .. vim.fn.shellescape(new_path) .. " 2>&1"
          )
          if vim.v.shell_error ~= 0 then
            vim.notify("Failed to rename worktree:\n" .. result, vim.log.levels.ERROR)
            return
          end
          vim.notify("Moved worktree to: " .. new_path)
        end)
      end,
    },
    win = {
      input = {
        keys = {
          ["<CR>"] = { "wt_switch", mode = { "n", "i" } },
          ["n"]    = { "wt_create", mode = { "n", "i" } },
          ["d"]    = { "wt_delete", mode = { "n", "i" } },
          ["r"]    = { "wt_rename", mode = { "n", "i" } },
        },
      },
      list = {
        keys = {
          ["<CR>"] = "wt_switch",
          ["n"]    = "wt_create",
          ["d"]    = "wt_delete",
          ["r"]    = "wt_rename",
        },
      },
    },
  })
end, { desc = "Git Worktrees" })
```

- [ ] **Step 2: Verify**

Press `<leader>gw` inside a git repo with multiple worktrees. The picker should open listing all worktrees. Test each action:
- `<CR>` on a non-current worktree → switches (cd + edit .)
- `n` → prompts for branch, creates new worktree
- `d` on a non-current worktree → confirms and deletes
- `d` on current worktree → shows error, no delete
- `r` on any worktree → prompts for new path, moves it

- [ ] **Step 3: Commit**

```bash
git add lua/configs/keymaps.lua
git commit -m "feat: rewrite <leader>gw picker with create/delete/rename"
```

---

## Task 8: Update `<leader>h` Keymap

**Files:**
- Modify: `lua/configs/keymaps.lua`

- [ ] **Step 1: Replace the `<leader>h` keymap**

Find and replace:
```lua
map("n", "<leader>h", ":lua Snacks.dashboard()<CR>", { desc = "Open dashboard" })
```
with:
```lua
map("n", "<leader>h", function() require("mini.starter").open() end, { desc = "Open dashboard" })
```

- [ ] **Step 2: Verify**

From any buffer, press `<leader>h`. The mini.starter dashboard should open. Press `q` or `<Esc>` to close.

- [ ] **Step 3: Commit**

```bash
git add lua/configs/keymaps.lua
git commit -m "feat: remap <leader>h to open mini.starter"
```
