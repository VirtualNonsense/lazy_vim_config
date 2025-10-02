-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

map("n", "<A-CR>", vim.lsp.buf.code_action, { desc = "LSP: Code Action" })
map({ "n", "i", "v" }, "<C-z>", "<Nop>", { silent = true })
--#region Search & replace
map(
  "n",
  "<leader>rR",
  [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
  { desc = "Replace word under cursor in file" }
)
--#endregion

--#region Clipboard + delete behavior
map("x", "<leader>p", [["_dP]], { desc = "Paste over selection" })
map("n", "<leader>Y", [["+Y]], { desc = "Yank line to clipboard" })
map({ "n", "v" }, "<leader>D", '"_d', { desc = "Delete without yank" })
--#endregion

--#region DAP
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
--#endregion

--#region hapoon
local harpoon = require("harpoon")
harpoon.setup()

map("n", "<F1>", function()
  harpoon:list():add()
end)
map("n", "<F2>", function()
  harpoon.ui:toggle_quick_menu(harpoon:list())
end)
--#endregion

--#region neotest
local neotest = require("neotest")
map("n", "<leader>tr", function()
  neotest.run.run()
end, { desc = "Test: Run nearest" })

map("n", "<leader>td", function()
  neotest.run.run({ strategy = "dap", suite = false })
end, { desc = "Test: Debug nearest" })

map("n", "<leader>tf", function()
  neotest.run.run(vim.fn.expand("%"))
end, { desc = "Test: Run current file" })

map("n", "<leader>tD", function()
  neotest.run.run({ suite = true, strategy = "dap" })
end, { desc = "Test: Run current file" })

map("n", "<leader>ts", function()
  neotest.run.stop()
end, { desc = "Test: stopt test" })
map("n", "<leader>tS", function()
  neotest.summary.toggle()
end, { desc = "Test: toggle summary" })
map("n", "<leader>to", function()
  neotest.output.toggle()
end, { desc = "Test: toggle output" })
map("n", "<leader>tw", function()
  neotest.watch.toggle(vim.fn.expand("%"))
end, { desc = "Test: toggle watch" })
--#endregion
--#region code companion
map({ "n", "v" }, "gC", "<cmd>CodeCompanionActions<cr>", { desc = "Codecompanion: actions" })
map({ "n", "v" }, "<leader>a", "<cmd>CodeCompanionChat Toggle<cr>", { desc = "Codecompanion toggle chat" })
map("v", "A", "<cmd>CodeCompanionChat Add<cr>", { noremap = true, silent = true, desc = "Codecompanion: add to chat" })
--#endregion
--#region jupynium
map({ "n", "i" }, "<A-c>", "<cmd>JupyniumExecuteSelectedCells<cr>", { desc = "Jupynium: Execute selected cell" })
--#endregion
