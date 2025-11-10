local M = {}

---@param show_warning boolean
M.load_launch_files = function(show_warning)
  local file_path = { "/.vscode/launch.json", "/.nvim/launch.json" }
  local unfound_msg = "Unable to load launch files.\nSearched Paths:\n"
  for idx = 1, #file_path do
    local file = vim.fn.getcwd() .. file_path[idx]
    if vim.uv.fs_stat(file) ~= nil then
      vim.notify(string.format("Loading launch configs from %s", file), vim.log.levels.INFO, { titel = "DAP" })
      require("dap.ext.vscode").getconfigs(vim.fn.getcwd() .. "launch.json")
      return
    end
    unfound_msg = unfound_msg .. "\t" .. file .. "\n"
  end
  if show_warning then
    vim.notify(unfound_msg, vim.log.levels.WARN, { titel = "DAP" })
  end
end
return M
