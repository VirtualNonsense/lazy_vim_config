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

  pylsp = {
    settings = {
      pylsp = {
        plugins = {
          -- MyPy on
          pylsp_mypy = {
            enabled = true,
            live_mode = true,
            dmypy = true,
            strict = false,
          },
          -- Everything else off (including Jedi)
          jedi_completion = { enabled = false },
          jedi_hover = { enabled = false },
          jedi_references = { enabled = false },
          jedi_signature_help = { enabled = false },
          jedi_symbols = { enabled = false },
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
    on_attach = function(client, _)
      -- keep only diagnostics; disable everything that could collide with pyright
      client.server_capabilities.hoverProvider = false
      client.server_capabilities.documentFormattingProvider = false
      -- disable "find references" (e.g. :lua vim.lsp.buf.references())
      client.server_capabilities.referencesProvider = false

      -- disable symbol renaming (e.g. :lua vim.lsp.buf.rename())
      client.server_capabilities.renameProvider = false
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
  lspconfig[name].setup(opts)
end
