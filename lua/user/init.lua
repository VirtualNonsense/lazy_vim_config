local M = {}
M.load_launch_files = function()
  local file_path = { "/.vscode/launch.json", "/.nvim/launch.json" }

  for idx = 1, #file_path do
    local file = vim.fn.getcwd() .. file_path[idx]
    if vim.uv.fs_stat(file) ~= nil then
      vim.notify(string.format("Loading launch configs from %s", file), vim.log.levels.INFO, { titel = "DAP" })
      require("dap.ext.vscode").getconfigs(vim.fn.getcwd() .. "launch.json")
      return
    end
  end
  vim.notify(
    string.format("Unable to load launch files.\nSearched Paths:  %s", file_path),
    vim.log.levels.WARN,
    { titel = "DAP" }
  )
end
return M
