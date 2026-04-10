# Neovim Dashboard Redesign

**Date:** 2026-04-09  
**Status:** Approved

## Summary

Replace the Snacks dashboard (slow, unused) with a fast `mini.starter` dashboard centered on git worktree management. The dashboard is the primary entry point for switching between parallel worktrees. Worktree creation, deletion, and renaming are accessible both from the dashboard and from a `<leader>gw` picker that works from anywhere in the editor.

## Goals

- Eliminate Snacks dashboard load time
- Make active worktrees immediately visible and switchable on nvim open
- Support create / delete / rename worktrees without leaving the editor
- Show git status and recent files as secondary at-a-glance info
- Show a quick keybinding reference for commonly-forgotten shortcuts

## Architecture

### Files Changed

| File | Change |
|---|---|
| `lua/configs/snacks.lua` | Set `dashboard = { enabled = false }` |
| `lua/configs/mini.lua` | Add `mini.starter` setup with all sections |
| `lua/configs/keymaps.lua` | Rewrite `<leader>gw` picker; remap `<leader>h` to open mini.starter |

### mini.starter Sections

Sections render top-to-bottom. All git commands run synchronously on open (both are fast local operations).

#### 1. Worktrees

- Source: `git worktree list --porcelain`
- Each worktree becomes a lettered item (`a`–`z` cycling)
- Displayed per row: `<key>  <branch>  <path>  [current]` (current worktree marked)
- Action on keypress: `vim.cmd("cd " .. path)` + `vim.cmd("edit .")` + close starter
- A `+` item at the bottom triggers inline worktree creation (see Create flow below)
- Section is hidden silently if not in a git repo

#### 2. Git Status

- Source: `git status --short`
- Display-only (no key, not selectable)
- Shows M / A / ? prefix per file, filename only
- Scoped to current worktree
- Section is hidden silently if not in a git repo or working tree is clean

#### 3. Recent Files

- Uses `MiniStarter.sections.recent_files()` built-in
- Continues lettering after worktree items

#### 4. Quick Keys

- Static display-only section (no keys, not selectable)
- Curated list of easy-to-forget shortcuts from the existing keymap config

### Header and Footer

- **Header:** current working directory (basename)
- **Footer:** startup time via `require("lazy").stats().startuptime`

## Worktree Management

### Dashboard (create only)

The `+` item in the Worktrees section opens `vim.ui.input` prompting for a branch name. On confirm:

```
git worktree add <worktree-dir> <branch>
```

Where `<worktree-dir>` is derived as a sibling directory of the current repo root (e.g. `../myapp-<branch>`). On success, refresh the starter buffer.

### `<leader>gw` Picker (create / delete / rename / switch)

Replaces the existing pure-git worktree picker with a Snacks picker that supports action keys:

| Key | Action |
|---|---|
| `<CR>` | Switch into worktree (`cd` + `edit .`) |
| `n` | Create — prompts for branch name, runs `git worktree add` |
| `d` | Delete — confirms then runs `git worktree remove <path>` |
| `r` | Rename/move — prompts for new path, runs `git worktree move <old> <new>` |

The picker is available from any buffer, not just the dashboard.

## Error Handling

- **Not in a git repo:** Worktrees and Git Status sections render nothing (no error shown)
- **Git command failure:** Section silently skipped; dashboard still renders remaining sections
- **No worktrees (only main):** Worktrees section shows the single main entry + `+` item
- **Worktree delete on current:** Show error notification, abort

## Keymaps

| Keymap | Before | After |
|---|---|---|
| `<leader>h` | `Snacks.dashboard()` | `MiniStarter.open()` |
| `<leader>gw` | Basic switch-only picker | Full create/delete/rename/switch picker |
