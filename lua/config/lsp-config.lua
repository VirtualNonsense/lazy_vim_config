local lspconfig = require("lspconfig")
local servers = {
  clangd = {},
  pyright = {
    settings = {
      python = {
        analysis = {
          typeCheckingMode = "basic",
          autoImportCompletions = true,
          autoSearchPaths = true,
          useLibraryCodeForTypes = true,
        },
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
  -- vim.lsp.config(name, opts)
  lspconfig[name].setup(opts)
end
