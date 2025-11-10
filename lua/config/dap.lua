local dap = require("dap")
local nv_text = require("nvim-dap-virtual-text")
local mason_dap = require("mason-nvim-dap")
require("user").load_launch_files(false)
nv_text.setup({})
-- mason-nvim-dap

mason_dap.setup({
  ensure_installed = { "codelldb" },
  handlers = {}, -- leave default handler, or configure per-adapter
})

-- nvim-dap-python
require("dap-python").setup("~/.local/share/uv/tools/debugpy/bin/python")

-- C / C++

local last_path = nil
dap.configurations.cpp = {
  {
    name = "Launch file",
    type = "codelldb",
    request = "launch",
    program = function()
      local path = vim.fn.getcwd() .. "/"
      if last_path ~= nil then
        path = last_path
      end
      last_path = vim.fn.input("Path to executable: ", path, "file")
      return last_path
    end,
    cwd = "${workspaceFolder}",
    stopOnEntry = false,
  },
  {
    -- If you get an "Operation not permitted" error using this, try disabling YAMA:
    --  echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
    name = "Attach to process",
    type = "cpp", -- Adjust this to match your adapter name (`dap.adapters.<name>`)
    request = "attach",
    pid = require("dap.utils").pick_process,
    args = {},
  },
}
dap.configurations.c = dap.configurations.cpp
