local lspconfig = require("lspconfig")
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
  -- ✅ MyPy via pylsp + pylsp-mypy (all other pylsp plugins disabled)
  pylsp = {
    settings = {
      pylsp = {
        plugins = {
          -- enable mypy
          pylsp_mypy = {
            enabled = true,
            live_mode = true, -- on-the-fly checks
            dmypy = true, -- use the mypy daemon if available
            strict = false, -- toggle if you run --strict in CI
            -- report_progress = true, -- optional progress notifications
          },
          -- disable everything else to avoid overlap with Ruff/Pyright
          pycodestyle = { enabled = false },
          pyflakes = { enabled = false },
          mccabe = { enabled = false },
          yapf = { enabled = false },
          autopep8 = { enabled = false },
          rope = { enabled = false },
          flake8 = { enabled = false },
          bandit = { enabled = false },
          pydocstyle = { enabled = false },
          isort = { enabled = false },
          black = { enabled = false },
        },
      },
    },
    -- optional, keep pylsp from providing hovers/formatting
    on_attach = function(client, _)
      client.server_capabilities.hoverProvider = false
      client.server_capabilities.documentFormattingProvider = false
    end,
    filetypes = { "python" },
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
  -- vim.lsp.config(name, opts)
  lspconfig[name].setup(opts)
end
