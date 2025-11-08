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

-- Telescope keymaps
local builtin = require("telescope.builtin")
map("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
map("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
map("n", "<leader>fb", builtin.buffers, { desc = "Buffers" })
map("n", "<leader>fh", builtin.help_tags, { desc = "Help tags" })
map("n", "<leader>fr", builtin.oldfiles, { desc = "Recent files" })
map("n", "<leader>fs", ":Telescope current_buffer_fuzzy_find<CR>", { desc = "Search current buffer" })
map("n", "<leader>c", ":Telescope commands<CR>", { desc = "Commands" })
map("n", "<leader>sh", ":Telescope help_tags<CR>", { desc = "Help tags" })
map("n", "<leader>sk", ":Telescope keymaps<CR>", { desc = "Keymaps" })
map("n", "<leader>sr", ":Telescope resume<CR>", { desc = "Resume telescope" })
map("n", "<leader>ss", ":Telescope current_buffer_fuzzy_find<CR>", { desc = "Search current buffer" })
map("n", "<leader>sg", ":GrugFar<CR>", { desc = "Search and replace" })

-- Open files in splits
map("n", "<leader>vf", ":vsplit | Telescope find_files<CR>", { desc = "Find files in vertical split" })
map("n", "<leader>hf", ":split | Telescope find_files<CR>", { desc = "Find files in horizontal split" })

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
		map("n", "gr", builtin.lsp_references, vim.tbl_extend("force", opts, { desc = "References" }))
	end,
})

-- Snacks explorer keymap
map("n", "<leader>e", ":lua Snacks.explorer()<CR>", { noremap = true, silent = true, desc = "Toggle file explorer" })

-- Oil keymap
map("n", "<leader>ol", ":Oil<CR>", { desc = "Oil file explorer" })

-- Git keymaps

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

-- ========================
-- Octo commands in Telescope
-- ========================
map("n", "<leader>oi", ":Telescope octo issues<CR>", { desc = "Octo issues" })
map("n", "<leader>op", ":Telescope octo prs<CR>", { desc = "Octo PRs" })
map("n", "<leader>or", ":Telescope octo review<CR>", { desc = "Octo review" })

-- Pull request actions
map("n", "<leader>oc", ":Octo checkout<CR>", { desc = "Octo checkout" })
map("n", "<leader>om", ":Octo merge<CR>", { desc = "Octo merge" })
map("n", "<leader>orb", ":Octo rebase<CR>", { desc = "Octo rebase" })
map("n", "<leader>ocm", ":Octo comment<CR>", { desc = "Octo comment" })
map("n", "<leader>og", ":Octo browse<CR>", { desc = "Octo browse" })

-- Issue actions
map("n", "<leader>oiv", ":Octo issue view<CR>", { desc = "View issue" })
map("n", "<leader>ni", ":Octo issue new<CR>", { desc = "New issue" })
map("n", "<leader>iocm", ":Octo issue comment<CR>", { desc = "Issue comment" })
map("n", "<leader>ioc", ":Octo issue close<CR>", { desc = "Close issue" })

-- Repo actions
map("n", "<leader>ogr", ":Octo repo browse<CR>", { desc = "Browse repo" })

-- Undotree mapping
map("n", "<leader>u", "<cmd>UndotreeToggle<CR>", { desc = "Toggle Undotree" })

-- Added terminal split mappings
map("n", "<leader>tv", ":leftabove vsplit | terminal<CR>", { desc = "Open terminal in left vertical split" })
map("n", "<leader>th", ":aboveleft split | terminal<CR>", { desc = "Open terminal in top horizontal split" })

-- Terminal keymaps
map("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
