local constants = require("overseer.constants")
local json = require("overseer.json")
local log = require("overseer.log")
local overseer = require("overseer")
local TAG = constants.TAG

---@param exe string
---@param venv string|nil
---@return string
local function venv_bin(exe, venv)
  if not venv or venv == "" then
    return exe
  end
  -- Cross-platform: unix "bin", windows "Scripts"
  local sep = package.config:sub(1, 1)
  local candidate1 = table.concat({ venv, "bin", exe }, sep)
  local candidate2 = table.concat({ venv, "Scripts", exe .. ".exe" }, sep)
  if vim.fn.executable(candidate1) == 1 then
    return candidate1
  elseif vim.fn.executable(candidate2) == 1 then
    return candidate2
  else
    return exe -- fallback
  end
end

---@type overseer.TemplateFileDefinition
local tmpl = {
  priority = 60,
  params = {
    args = { type = "list", delimiter = " " },
    cwd = { optional = true },
    relative_file_root = {
      desc = "Relative filepaths will be joined to this root (instead of task cwd)",
      optional = true,
    },
  },
  builder = function(params)
    -- Resolve tools. mypy prefers the currently activated venv.
    local venv = os.getenv("VIRTUAL_ENV")
    local args = params.args or {}
    local cmd = args[1]

    local resolved_cmd
    if cmd == "mypy" then
      resolved_cmd = { venv_bin("mypy", venv) }
      table.remove(args, 1)
    elseif cmd == "pytest" then
      resolved_cmd = { "pytest" }
      table.remove(args, 1)
    elseif cmd == "ruff" then
      resolved_cmd = { "ruff" }
      table.remove(args, 1)
    else
      -- Generic fallback allows things like: {"python", "-m", "mypy", "."} if desired
      resolved_cmd = { cmd or "python" }
      table.remove(args, 1)
    end

    -- Expand % and %:p at build time for file-scoped tasks
    local expanded_args = {}
    for _, a in ipairs(args) do
      table.insert(expanded_args, vim.fn.expand(a))
    end

    return {
      cmd = resolved_cmd,
      args = expanded_args,
      cwd = params.cwd,
      default_component_params = {
        -- basic mypy/ruff/pytest parsing without being too clever
        -- you can tighten this later per-tool with custom components if you like
        relative_file_root = params.relative_file_root,
      },
      components = { "default" },
    }
  end,
}

---@param opts overseer.SearchParams
---@return nil|string
local function get_project_root(opts)
  local markers = { "pyproject.toml", "setup.cfg", "setup.py", "requirements.txt", ".venv", "venv" }
  local found
  for _, m in ipairs(markers) do
    found = vim.fs.find(m, { upward = true, type = "file", path = opts.dir })[1]
    if found then
      return vim.fs.dirname(found)
    end
    -- also consider directories named venv/.venv
    if m == ".venv" or m == "venv" then
      local d = vim.fs.find(m, { upward = true, type = "directory", path = opts.dir })[1]
      if d then
        return vim.fs.dirname(d)
      end
    end
  end
  return nil
end

return {
  cache_key = function(opts)
    local root = get_project_root(opts)
    return root
  end,

  condition = {
    callback = function(opts)
      -- Heuristic: consider it a Python project if we can find common markers
      if not get_project_root(opts) then
        return false, "No Python project markers found (pyproject/setup/requirements/venv)"
      end
      return true
    end,
    filetype = { "python" },
  },

  generator = function(opts, cb)
    local project_root = assert(get_project_root(opts), "No Python project root found")
    local ret = {}

    -- Commands matrix. Keep mypy venv-bound, others standalone.
    local commands = {
      -- Project-wide
      { name = "mypy .", args = { "mypy", "." }, tags = { TAG.TEST } },
      { name = "pytest", args = { "pytest" }, tags = { TAG.TEST } },
      { name = "ruff check .", args = { "ruff", "check", "." }, tags = { TAG.TEST } },
      { name = "ruff fix .", args = { "ruff", "fix", "." }, tags = { TAG.TEST } },

      -- File-scoped (uses % expansion to current file)
      { name = "mypy %", args = { "mypy", "%:p" }, tags = { TAG.TEST } },
      { name = "pytest %", args = { "pytest", "%:p" }, tags = { TAG.TEST } },
      { name = "ruff check %", args = { "ruff", "check", "%:p" }, tags = { TAG.TEST } },
      { name = "ruff fix %", args = { "ruff", "fix", "%:p" }, tags = { TAG.TEST } },

      -- Extras
      { name = "python -m mypy .", args = { "python", "-m", "mypy", "." }, tags = { TAG.TEST } },
    }

    local roots = {
      {
        postfix = "",
        cwd = project_root,
        priority = 59,
      },
    }

    for _, root in ipairs(roots) do
      for _, c in ipairs(commands) do
        table.insert(
          ret,
          overseer.wrap_template(tmpl, {
            name = c.name .. root.postfix,
            tags = c.tags,
            priority = root.priority,
          }, {
            args = c.args,
            cwd = root.cwd,
            relative_file_root = root.relative_file_root,
          })
        )
      end

      -- Raw “python-project” entry allowing ad-hoc args
      table.insert(
        ret,
        overseer.wrap_template(
          tmpl,
          { name = "python-project" .. root.postfix },
          { cwd = root.cwd, relative_file_root = root.relative_file_root }
        )
      )
    end

    cb(ret)
  end,
}
