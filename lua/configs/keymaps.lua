-- General keymaps
local map = vim.keymap.set
local Snacks = require("snacks")

-- Yank messages to clipboard
map("n", "<leader>ym", function()
	vim.cmd("redir @+ | silent messages | redir END")
	vim.cmd("OSCYankReg +")
	vim.notify("Messages copied to clipboard")
end, { desc = "Yank messages" })

-- Yanky keymaps
map({ "n", "x" }, "p", "<Plug>(YankyPutAfter)")
map({ "n", "x" }, "P", "<Plug>(YankyPutBefore)")
map({ "n", "x" }, "gp", "<Plug>(YankyGPutAfter)")
map({ "n", "x" }, "gP", "<Plug>(YankyGPutBefore)")
map("n", "<c-p>", "<Plug>(YankyPreviousEntry)")
map("n", "<c-n>", "<Plug>(YankyNextEntry)")

-- Open dashboard
map("n", "<leader>h", function() require("mini.starter").open() end, { desc = "Open dashboard" })

-- Format with conform
map("n", "<leader>fm", function()
	require("conform").format()
end, { desc = "Format" })

-- Search and replace
map("n", "<leader>sr", function()
	require("grug-far").open()
end, { desc = "Search and replace" })

-- Snacks toggles
map("n", "<leader>tz", function()
	Snacks.toggle.zen()
end, { desc = "Toggle zen mode" })
map("n", "<leader>tl", function()
	Snacks.toggle.option("number")
end, { desc = "Toggle line numbers" })
map("n", "<leader>tR", function()
	Snacks.toggle.option("relativenumber")
end, { desc = "Toggle relative numbers" })
map("n", "<leader>tw", function()
	Snacks.toggle.option("wrap")
end, { desc = "Toggle wrap" })

-- Theme switcher
map("n", "<leader>tm", ":Themery<CR>", { desc = "Switch theme" })
-- Bufferline keymaps
map("n", "<leader><Tab>", "<Cmd>BufferLineCycleNext<CR>", { desc = "Next buffer" })
map("n", "<leader><S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", { desc = "Previous buffer" })
map("n", "<leader>w", "<Cmd>bdelete<CR>", { desc = "Close buffer" })
map("n", "<leader>bp", "<Cmd>BufferLinePick<CR>", { desc = "Pick buffer" })
map("n", "<leader>bc", "<Cmd>BufferLinePickClose<CR>", { desc = "Pick close buffer" })

-- Window splits
map("n", "<leader>vs", ":vsplit<CR>", { desc = "Vertical split" })
map("n", "<leader>hs", ":split<CR>", { desc = "Horizontal split" })

-- LSP keymaps
map("n", "<space>d", vim.diagnostic.open_float, { desc = "Open diagnostic float" })
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		-- Enable completion triggered by <c-x><c-o>
		vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

		-- Buffer local mappings
		local opts = { buffer = ev.buf }
		map("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover" }))
		map("n", "gi", vim.lsp.buf.implementation, vim.tbl_extend("force", opts, { desc = "Go to implementation" }))
		map("n", "<C-k>", vim.lsp.buf.signature_help, vim.tbl_extend("force", opts, { desc = "Signature help" }))
		map(
			"n",
			"<space>wa",
			vim.lsp.buf.add_workspace_folder,
			vim.tbl_extend("force", opts, { desc = "Add workspace folder" })
		)
		map(
			"n",
			"<space>wr",
			vim.lsp.buf.remove_workspace_folder,
			vim.tbl_extend("force", opts, { desc = "Remove workspace folder" })
		)
		map("n", "<space>wl", function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end, vim.tbl_extend("force", opts, { desc = "List workspace folders" }))
		map("n", "<space>D", vim.lsp.buf.type_definition, vim.tbl_extend("force", opts, { desc = "Type definition" }))
		map("n", "<space>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename" }))
		map("n", "<space>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code action" }))
	end,
})

-- ========================
-- Snacks Picker Keymaps
-- ========================

map("n", "<leader><space>", ":lua Snacks.picker.smart()<CR>", { desc = "Smart Find Files" })
map("n", "<leader>n", ":lua Snacks.picker.notifications()<CR>", { desc = "Notification History" })
map("n", "<leader>e", ":Oil<CR>", { desc = "File Explorer" })

-- Quicker quickfix toggles
map("n", "<leader>q", function()
	require("quicker").toggle()
end, { desc = "Toggle quickfix" })
map("n", "<leader>l", function()
	require("quicker").toggle({ loclist = true })
end, { desc = "Toggle loclist" })

-- find
map("n", "<leader>fb", ":lua Snacks.picker.buffers()<CR>", { desc = "Buffers" })
map("n", "<leader>fc", function()
	Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
end, { desc = "Find Config File" })
map("n", "<leader>ff", ":lua Snacks.picker.files()<CR>", { desc = "Find Files" })
map("n", "<leader>fg", ":lua Snacks.picker.git_files()<CR>", { desc = "Find Git Files" })
map("n", "<leader>fp", ":lua Snacks.picker.projects()<CR>", { desc = "Projects" })
map("n", "<leader>fr", ":lua Snacks.picker.recent()<CR>", { desc = "Recent" })
-- git
map("n", "<leader>gb", ":lua Snacks.picker.git_branches()<CR>", { desc = "Git Branches" })
map("n", "<leader>gl", ":lua Snacks.picker.git_log()<CR>", { desc = "Git Log" })
map("n", "<leader>gL", ":lua Snacks.picker.git_log_line()<CR>", { desc = "Git Log Line" })
map("n", "<leader>gs", ":lua Snacks.picker.git_status()<CR>", { desc = "Git Status" })
map("n", "<leader>gS", ":lua Snacks.picker.git_stash()<CR>", { desc = "Git Stash" })
map("n", "<leader>gvd", ":lua Snacks.picker.git_diff()<CR>", { desc = "Git Diff (Hunks)" })
-- gh
map("n", "<leader>gi", ":lua Snacks.picker.gh_issue()<CR>", { desc = "GitHub Issues (open)" })
map("n", "<leader>gI", function()
	Snacks.picker.gh_issue({ state = "all" })
end, { desc = "GitHub Issues (all)" })
map("n", "<leader>gp", ":lua Snacks.picker.gh_pr()<CR>", { desc = "GitHub Pull Requests (open)" })
map("n", "<leader>gP", function()
	Snacks.picker.gh_pr({ state = "all" })
end, { desc = "GitHub Pull Requests (all)" })
-- Grep
map("n", "<leader>sb", ":lua Snacks.picker.lines()<CR>", { desc = "Buffer Lines" })
map("n", "<leader>sB", ":lua Snacks.picker.grep_buffers()<CR>", { desc = "Grep Open Buffers" })
map("n", "<leader>sg", ":lua Snacks.picker.grep()<CR>", { desc = "Grep" })
map({ "n", "x" }, "<leader>sw", ":lua Snacks.picker.grep_word()<CR>", { desc = "Visual selection or word" })
-- search
map("n", '<leader>s"', ":lua Snacks.picker.registers()<CR>", { desc = "Registers" })
map("n", "<leader>s/", ":lua Snacks.picker.search_history()<CR>", { desc = "Search History" })
map("n", "<leader>sa", ":lua Snacks.picker.autocmds()<CR>", { desc = "Autocmds" })
map("n", "<leader>sc", ":lua Snacks.picker.command_history()<CR>", { desc = "Command History" })
map("n", "<leader>sC", ":lua Snacks.picker.commands()<CR>", { desc = "Commands" })
map("n", "<leader>sd", ":lua Snacks.picker.diagnostics()<CR>", { desc = "Diagnostics" })
map("n", "<leader>sD", ":lua Snacks.picker.diagnostics_buffer()<CR>", { desc = "Buffer Diagnostics" })
map("n", "<leader>sh", ":lua Snacks.picker.help()<CR>", { desc = "Help Pages" })
map("n", "<leader>sH", ":lua Snacks.picker.highlights()<CR>", { desc = "Highlights" })
map("n", "<leader>si", ":lua Snacks.picker.icons()<CR>", { desc = "Icons" })
map("n", "<leader>sj", ":lua Snacks.picker.jumps()<CR>", { desc = "Jumps" })
map("n", "<leader>sk", ":lua Snacks.picker.keymaps()<CR>", { desc = "Keymaps" })
map("n", "<leader>sl", ":lua Snacks.picker.loclist()<CR>", { desc = "Location List" })
map("n", "<leader>sm", ":lua Snacks.picker.marks()<CR>", { desc = "Marks" })
map("n", "<leader>sM", ":lua Snacks.picker.man()<CR>", { desc = "Man Pages" })
map("n", "<leader>sp", ":lua Snacks.picker.lazy()<CR>", { desc = "Search for Plugin Spec" })
map("n", "<leader>sq", ":lua Snacks.picker.qflist()<CR>", { desc = "Quickfix List" })
map("n", "<leader>sR", ":lua Snacks.picker.resume()<CR>", { desc = "Resume" })
map("n", "<leader>su", ":lua Snacks.picker.undo()<CR>", { desc = "Undo History" })
map("n", "<leader>uC", ":lua Snacks.picker.colorschemes()<CR>", { desc = "Colorschemes" })
-- LSP
map("n", "gd", ":lua Snacks.picker.lsp_definitions()<CR>", { desc = "Goto Definition" })
map("n", "gD", ":lua Snacks.picker.lsp_declarations()<CR>", { desc = "Goto Declaration" })
-- we may need to add nowait to 'gr'
map("n", "gr", ":lua Snacks.picker.lsp_references()<CR>", { desc = "References" })
map("n", "gI", ":lua Snacks.picker.lsp_implementations()<CR>", { desc = "Goto Implementation" })
map("n", "gy", ":lua Snacks.picker.lsp_type_definitions()<CR>", { desc = "Goto T[y]pe Definition" })
map("n", "gai", ":lua Snacks.picker.lsp_incoming_calls()<CR>", { desc = "C[a]lls Incoming" })
map("n", "gao", ":lua Snacks.picker.lsp_outgoing_calls()<CR>", { desc = "C[a]lls Outgoing" })
map("n", "<leader>ss", ":lua Snacks.picker.lsp_symbols()<CR>", { desc = "LSP Symbols" })
map("n", "<leader>sS", ":lua Snacks.picker.lsp_workspace_symbols()<CR>", { desc = "LSP Workspace Symbols" })
map("n", "<leader>lg", ":lua Snacks.lazygit()<CR>", { desc = "LazyGit" })
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
					picker:close()
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

-- Git keymaps

-- Diffview keymaps
map("n", "<leader>gd", ":DiffviewOpen<CR>", { desc = "Open Diffview" })
map("n", "<leader>gq", ":DiffviewClose<CR>", { desc = "Close Diffview" })
map("n", "<leader>gH", ":DiffviewFileHistory<CR>", { desc = "Show file history (Diffview)" })


-- Fugitive
map("n", "<leader>G", ":Git<CR>", { desc = "Fugitive status" })
-- Open 3-way merge split for conflict resolution (ours | working | theirs)
map("n", "<leader>gM", ":Gvdiffsplit!<CR>", { desc = "3-way merge split" })
-- Pick from ours (//2, left pane) or theirs (//3, right pane) in merge view
map("n", "<leader>g2", ":diffget //2<CR>", { desc = "Get from ours (left)" })
map("n", "<leader>g3", ":diffget //3<CR>", { desc = "Get from theirs (right)" })
-- Rebase workflow
map("n", "<leader>grc", ":Git rebase --continue<CR>", { desc = "Rebase continue" })
map("n", "<leader>gra", ":Git rebase --abort<CR>", { desc = "Rebase abort" })
map("n", "<leader>grs", ":Git rebase --skip<CR>", { desc = "Rebase skip" })

-- Undotree mapping
map("n", "<leader>u", "<cmd>UndotreeToggle<CR>", { desc = "Toggle Undotree" })

-- Terminal split mappings
local function open_terminal(split_cmd)
	vim.cmd(split_cmd .. " | terminal")
	vim.cmd("startinsert")
end
map("n", "<leader>tv", function() open_terminal("leftabove vsplit") end, { desc = "Open terminal in left vertical split" })
map("n", "<leader>th", function() open_terminal("aboveleft split") end, { desc = "Open terminal in top horizontal split" })
map("n", "<leader>tb", function() open_terminal("belowright split") end, { desc = "Open terminal in bottom horizontal split" })
map("n", "<leader>tr", function() open_terminal("rightbelow vsplit") end, { desc = "Open terminal in right vertical split" })

-- Terminal keymaps
map("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
