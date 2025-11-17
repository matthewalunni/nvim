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
map("n", "<leader>h", ":lua Snacks.dashboard()<CR>", { desc = "Open dashboard" })

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
map("n", "<leader>tr", function()
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
map("n", "<space>q", vim.diagnostic.setloclist, { desc = "Set diagnostic loclist" })

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		-- Enable completion triggered by <c-x><c-o>
		vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

		-- Buffer local mappings
		local opts = { buffer = ev.buf }
		map("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("force", opts, { desc = "Go to declaration" }))
		map("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Go to definition" }))
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
map("n", "<leader>,", ":lua Snacks.picker.buffers()<CR>", { desc = "Buffers" })
map("n", "<leader>/", ":lua Snacks.picker.grep()<CR>", { desc = "Grep" })
map("n", "<leader>:", ":lua Snacks.picker.command_history()<CR>", { desc = "Command History" })
map("n", "<leader>n", ":lua Snacks.picker.notifications()<CR>", { desc = "Notification History" })
map("n", "<leader>e", ":Oil<CR>", { desc = "File Explorer" })
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
map("n", "<leader>gd", ":lua Snacks.picker.git_diff()<CR>", { desc = "Git Diff (Hunks)" })
map("n", "<leader>gf", ":lua Snacks.picker.git_log_file()<CR>", { desc = "Git Log File" })
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
map("n", "<leader>sb", ":lua Snacks.picker.lines()<CR>", { desc = "Buffer Lines" })
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
map("n", "<leader>lg", ":lua Snacks.lazygit()<CR>", { desc = "LSP Code Actions" })
-- command to search through git worktrees in a picker
map("n", "<leader>gw", function()
	-- Get raw worktree data
	local output = vim.fn.systemlist("git worktree list --porcelain")
	if vim.v.shell_error ~= 0 then
		vim.notify("Not a git repo or git worktree not available", vim.log.levels.ERROR)
		return
	end

	-- Parse worktrees from porcelain output
	local worktrees = {}
	local current = {}

	for _, line in ipairs(output) do
		if line:match("^worktree ") then
			current = { path = line:sub(10) }
		elseif line:match("^branch ") then
			current.branch = line:sub(8)
			table.insert(worktrees, current)
		end
	end

	-- Format items for snacks.nvim
	local items = vim.tbl_map(function(wt)
		return {
			text = wt.path,
			subtext = "Branch: " .. wt.branch,
			value = wt,
		}
	end, worktrees)

	require("snacks").picker({
		title = "Git Worktrees",
		items = items,
		on_submit = function(item)
			local target = item.value.path

			-- Relaunch nvim in that worktree
			vim.cmd("cd " .. target)
			vim.cmd("edit .") -- open root
			vim.cmd("silent! bufdo e!") -- reload buffers (optional)
			vim.notify("Switched to worktree: " .. target)
		end,
	})
end, { desc = "Switch Git Worktree (pure git)" })

-- Git keymaps

-- Diffview keymaps
map("n", "<leader>gd", ":DiffviewOpen<CR>", { desc = "Open Diffview" })
map("n", "<leader>gq", ":DiffviewClose<CR>", { desc = "Close Diffview" })
map("n", "<leader>gf", ":DiffviewToggleFiles<CR>", { desc = "Toggle Diffview files panel" })
map("n", "<leader>gH", ":DiffviewFileHistory<CR>", { desc = "Show file history (Diffview)" })

-- ========================
-- Copilot & Copilot Chat (requires Copilot + Chat plugin)
-- ========================
map("n", "<leader>cc", ":Copilot Chat<CR>", { desc = "Copilot Chat" })
map("n", "<leader>cq", ":Copilot Chat<CR>", { desc = "Copilot Chat quick" })
map("v", "<leader>ce", ":Copilot Chat<CR>", { desc = "Explain code" })
map("v", "<leader>ct", ":Copilot Chat<CR>", { desc = "Generate tests" })
map("v", "<leader>cd", ":Copilot Chat<CR>", { desc = "Generate docstrings" })
map("n", "<C-e>", ":Copilot#Accept()<CR>", { desc = "Accept Copilot suggestion" })
map("n", "<C-space>", ":Copilot#Complete()<CR>", { desc = "Copilot complete" })

-- Undotree mapping
map("n", "<leader>u", "<cmd>UndotreeToggle<CR>", { desc = "Toggle Undotree" })

-- Added terminal split mappings
map("n", "<leader>tv", ":leftabove vsplit | terminal<CR>", { desc = "Open terminal in left vertical split" })
map("n", "<leader>th", ":aboveleft split | terminal<CR>", { desc = "Open terminal in top horizontal split" })
-- add some terminal keymaps for opening the terminal in the bottom half and right half
map("n", "<leader>tb", ":belowright split | terminal<CR>", { desc = "Open terminal in bottom horizontal split" })
map("n", "<leader>tr", ":rightbelow vsplit | terminal<CR>", { desc = "Open terminal in right vertical split" })

-- Terminal keymaps
map("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
