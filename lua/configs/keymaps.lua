-- General keymaps
local map = vim.keymap.set
local Snacks = require("snacks")

-- Yank messages to clipboard
vim.keymap.set("n", "<leader>ym", function()
	vim.cmd("redir @+ | silent messages | redir END")
	vim.cmd("OSCYankReg +")
	vim.notify("Messages copied to clipboard")
end, { desc = "Yank messages" })

-- Open dashboard
vim.keymap.set("n", "<leader>h", ":lua Snacks.dashboard()<CR>", { desc = "Open dashboard" })

-- Format with conform
vim.keymap.set("n", "<leader>fm", function()
	require("conform").format()
end, { desc = "Format" })

-- Telescope keymaps
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Help tags" })
vim.keymap.set("n", "<leader>fr", builtin.oldfiles, { desc = "Recent files" })
map("n", "<leader>fs", ":Telescope current_buffer_fuzzy_find<CR>", { desc = "Search current buffer" })
map("n", "<leader>c", ":Telescope commands<CR>", { desc = "Commands" })
map("n", "<leader>sh", ":Telescope help_tags<CR>", { desc = "Help tags" })
map("n", "<leader>sk", ":Telescope keymaps<CR>", { desc = "Keymaps" })
map("n", "<leader>sr", ":Telescope resume<CR>", { desc = "Resume telescope" })
map("n", "<leader>ss", ":Telescope current_buffer_fuzzy_find<CR>", { desc = "Search current buffer" })

-- LSP keymaps
vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, { desc = "Open diagnostic float" })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist, { desc = "Set diagnostic loclist" })

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		-- Enable completion triggered by <c-x><c-o>
		vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

		-- Buffer local mappings
		local opts = { buffer = ev.buf }
		vim.keymap.set(
			"n",
			"gD",
			vim.lsp.buf.declaration,
			vim.tbl_extend("force", opts, { desc = "Go to declaration" })
		)
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Go to definition" }))
		vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover" }))
		vim.keymap.set(
			"n",
			"gi",
			vim.lsp.buf.implementation,
			vim.tbl_extend("force", opts, { desc = "Go to implementation" })
		)
		vim.keymap.set(
			"n",
			"<C-k>",
			vim.lsp.buf.signature_help,
			vim.tbl_extend("force", opts, { desc = "Signature help" })
		)
		vim.keymap.set(
			"n",
			"<space>wa",
			vim.lsp.buf.add_workspace_folder,
			vim.tbl_extend("force", opts, { desc = "Add workspace folder" })
		)
		vim.keymap.set(
			"n",
			"<space>wr",
			vim.lsp.buf.remove_workspace_folder,
			vim.tbl_extend("force", opts, { desc = "Remove workspace folder" })
		)
		vim.keymap.set("n", "<space>wl", function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end, vim.tbl_extend("force", opts, { desc = "List workspace folders" }))
		vim.keymap.set(
			"n",
			"<space>D",
			vim.lsp.buf.type_definition,
			vim.tbl_extend("force", opts, { desc = "Type definition" })
		)
		vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename" }))
		vim.keymap.set(
			"n",
			"<space>ca",
			vim.lsp.buf.code_action,
			vim.tbl_extend("force", opts, { desc = "Code action" })
		)
		vim.keymap.set("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "References" }))
	end,
})

-- Snacks explorer keymap
vim.keymap.set(
	"n",
	"<leader>e",
	":lua Snacks.explorer()<CR>",
	{ noremap = true, silent = true, desc = "Toggle file explorer" }
)

-- Git keymaps
vim.keymap.set("n", "<leader>gs", ":Git<CR>", { noremap = true, silent = true, desc = "Git status" })
vim.keymap.set("n", "<leader>gc", ":Git commit<CR>", { noremap = true, silent = true, desc = "Git commit" })
vim.keymap.set("n", "<leader>gp", ":Git push<CR>", { noremap = true, silent = true, desc = "Git push" })

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
map("n", "<leader>o", ":Octo<CR>", { desc = "Octo" })
