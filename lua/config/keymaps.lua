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
