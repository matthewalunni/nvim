local ok, flash = pcall(require, "flash")
if not ok then
    return
end

flash.setup({
    -- use default options
})

-- Recommended keymaps
local map = vim.keymap.set
map({"n", "x", "o"}, "s", function()
    require("flash").jump()
end, { desc = "Flash jump" })
map({"n", "x", "o"}, "S", function()
    require("flash").treesitter()
end, { desc = "Flash treesitter" })
map("n", "<leader>f", function()
    require("flash").jump({ search = { mode = "f" } })
end, { desc = "Flash f-motion" })
