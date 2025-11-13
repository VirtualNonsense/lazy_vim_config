-- Only treat a directory as "python project" if it has .venv/ or pyproject.toml
local function has_python_project_files()
  local cwd = vim.fn.getcwd()
  local uv = vim.uv or vim.loop

  -- .venv directory?
  if uv.fs_stat(cwd .. "/.venv") ~= nil then
    return true
  end

  -- pyproject.toml file?
  if vim.fn.filereadable(cwd .. "/pyproject.toml") == 1 then
    return true
  end

  return false
end

local function activate_selected_venv_for_terminal()
  -- 1) Only in python-ish projects
  if not has_python_project_files() then
    return
  end

  -- 2) Get currently selected venv from venv-selector
  local ok, venv_selector = pcall(require, "venv-selector")
  if not ok then
    return
  end

  local venv = venv_selector.venv()
  if not venv or venv == "" then
    return
  end

  -- 3) Build activation command depending on shell
  local shell = vim.o.shell
  local cmd

  if shell:match("fish") then
    cmd = "source " .. venv .. "/bin/activate.fish\n"
  else
    -- default: POSIX shells (bash, zsh, etc.)
    local activate_sh = venv .. "/bin/activate"
    if vim.fn.filereadable(activate_sh) ~= 1 then
      return
    end
    cmd = "source " .. activate_sh .. "\n"
  end

  -- 4) Send activation command into the terminal buffer
  if vim.b.terminal_job_id then
    vim.api.nvim_chan_send(vim.b.terminal_job_id, cmd)
  end
end

vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "term://*",
  callback = activate_selected_venv_for_terminal,
})
