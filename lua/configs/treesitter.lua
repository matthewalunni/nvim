-- nvim-treesitter `main` branch (Neovim 0.12+). The old
-- `require("nvim-treesitter.configs").setup{}` API is gone: parsers are
-- installed explicitly, and highlight/indent are switched on per buffer.
-- Building parsers needs the tree-sitter CLI (0.26.1+) and a C compiler.
local ok, ts = pcall(require, "nvim-treesitter")
if not ok then return end

local ensure_installed = {
	"lua", "python", "javascript", "typescript", "tsx", "jsdoc", "html", "css", "json", "yaml",
	"bash", "dockerfile", "gitignore", "markdown", "markdown_inline", "regex", "vim",
}

local can_build = vim.fn.executable("tree-sitter") == 1
if can_build then
	ts.install(ensure_installed) -- async; no-op for parsers already installed
end

vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("user_treesitter", { clear = true }),
	callback = function(args)
		local lang = vim.treesitter.language.get_lang(args.match)
		if not lang then return end
		if not vim.treesitter.language.add(lang) then
			-- auto_install: fetch a missing parser; it takes effect on the next open
			if can_build and vim.tbl_contains(ts.get_available(), lang) then ts.install(lang) end
			return
		end
		vim.treesitter.start(args.buf, lang)
		vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
	end,
})

-- Incremental selection: Neovim 0.12 builds this in (visual `an` / `in`);
-- keep the old keys as aliases.
vim.keymap.set("n", "gnn", "van", { remap = true, desc = "Start node selection" })
vim.keymap.set("x", "grn", "an", { remap = true, desc = "Expand to parent node" })
vim.keymap.set("x", "grm", "in", { remap = true, desc = "Shrink to child node" })

-- Textobjects
local tok, tobj = pcall(require, "nvim-treesitter-textobjects")
if not tok then return end
tobj.setup({ select = { lookahead = true }, move = { set_jumps = true } })

local select = require("nvim-treesitter-textobjects.select")
for key, query in pairs({
	af = "@function.outer", ["if"] = "@function.inner",
	ac = "@class.outer", ic = "@class.inner",
	aB = "@block.outer", iB = "@block.inner",
}) do
	vim.keymap.set({ "x", "o" }, key, function() select.select_textobject(query, "textobjects") end,
		{ desc = "Select " .. query })
end

local move = require("nvim-treesitter-textobjects.move")
for key, spec in pairs({
	["]m"] = { "goto_next_start", "@function.outer" }, ["]]"] = { "goto_next_start", "@class.outer" },
	["]M"] = { "goto_next_end", "@function.outer" }, ["]["] = { "goto_next_end", "@class.outer" },
	["[m"] = { "goto_previous_start", "@function.outer" }, ["[["] = { "goto_previous_start", "@class.outer" },
	["[M"] = { "goto_previous_end", "@function.outer" }, ["[]"] = { "goto_previous_end", "@class.outer" },
}) do
	vim.keymap.set({ "n", "x", "o" }, key, function() move[spec[1]](spec[2], "textobjects") end,
		{ desc = (spec[1]:gsub("_", " ")) .. " " .. spec[2] })
end
