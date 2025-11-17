-- Basic setup for quicker.nvim
local ok, quicker = pcall(require, "quicker")
if not ok then
    return
end

quicker.setup({
    -- default setup is fine; keymaps will be added in keymaps.lua
})
