local lspconfig = require("lspconfig")

-- Normalize: bool capabilities -> false, table capabilities -> nil (entfernen)
local function disable_capability(client, key)
  local v = client.server_capabilities[key]
  if type(v) == "table" then
    client.server_capabilities[key] = nil
  else
    client.server_capabilities[key] = false
  end
end

-- Whitelist-Filter: lässt nur die Keys in `whitelist` bestehen
local function apply_capability_whitelist(client, whitelist)
  -- build fast lookup
  local allow = {}
  for _, k in ipairs(whitelist or {}) do
    allow[k] = true
  end

  -- Debug: vor dem Patch anzeigen
  vim.notify(
    vim.inspect(client.server_capabilities),
    vim.log.levels.INFO,
    { title = ("%s capabilities (before whitelist)"):format(client.name) }
  )

  -- Alles killen, was nicht explizit erlaubt ist
  for key, _ in pairs(client.server_capabilities) do
    if not allow[key] then
      disable_capability(client, key)
    end
  end

  -- Debug: nach dem Patch anzeigen
  vim.notify(
    vim.inspect(client.server_capabilities),
    vim.log.levels.INFO,
    { title = ("%s capabilities (after whitelist)"):format(client.name) }
  )
end

local servers = {
  clangd = {},
  cssls = {},
  html = {},
  jsonls = {},
  pyright = {
    settings = {
      pyright = {
        -- Using Ruff's import organizer
        disableOrganizeImports = true,
      },
      python = {
        typeCheckingMode = "basic",
        autoImportCompletions = true,
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
      },
    },
  },
  ruff = {
    init_options = {
      settings = {
        args = {},
      },
    },
  },

  texlab = {
    settings = {
      texlab = {
        auxDirectory = "build",
        build = {
          args = { "-pdf", "-shell-escape", "-interaction=nonstopmode", "-synctex=1", "%f" },
          onSave = true,
          forwardSearchAfter = true,
        },
        chktex = {
          onOpenAndSave = true,
        },
        forwardSearch = {
          executable = "zathura",
          args = { "--synctex-forward", "%l:1:%f", "%p" },
        },
      },
    },
  },
  tombi = {

    filetypes = { "toml" },
    root_markers = { "tombi.toml", "pyproject.toml", ".git", "Cargo.toml" },
  },
}

for name, opts in pairs(servers) do
  vim.lsp.enable(name)
  lspconfig[name].setup(opts)
end
