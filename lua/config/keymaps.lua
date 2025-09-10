-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

map("n", "<A-CR>", vim.lsp.buf.code_action, { desc = "LSP: Code Action" })

-- Search & replace
map(
  "n",
  "<leader>rR",
  [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
  { desc = "Replace word under cursor in file" }
)

-- Clipboard + delete behavior
map("x", "<leader>p", [["_dP]], { desc = "Paste over selection" })
map("n", "<leader>Y", [["+Y]], { desc = "Yank line to clipboard" })
map({ "n", "v" }, "<leader>D", '"_d', { desc = "Delete without yank" })

--- DAP
local dap = require("dap")
map("n", "<F5>", function()
  dap.continue()
end, { desc = "DAP Continue" })

map("n", "<F9>", function()
  dap.step_over()
end, { desc = "DAP Step Over" })

map("n", "<F10>", function()
  dap.step_into()
end, { desc = "DAP Step Into" })

map("n", "<F11>", function()
  dap.step_out()
end, { desc = "DAP Step Out" })
map("n", "<F3>", function()
  dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
end, { desc = "Debug: Conditional Breakpoint" })
map("n", "<F4>", dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })

---hapoon

local harpoon = require("harpoon")
harpoon.setup()

map("n", "<F1>", function()
  harpoon:list():add()
end)
map("n", "<F2>", function()
  harpoon.ui:toggle_quick_menu(harpoon:list())
end)
