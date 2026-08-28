local lspconfig = require("lspconfig")
return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      clangd = {
        root_markers = { "compile_commands.json", ".clangd", "platformio.ini", ".git" },
      },
      cssls = {},
      html = {},
      jsonls = {},
      nil_ls = {},
      yamlls = {
        cmd = { "yaml-language-server.cmd", "--stdio" },
        settings = {
          yaml = {
            schemas = {
              ["https://raw.githubusercontent.com/kaitai-io/ksy_schema/master/ksy_schema.json"] = "/*.ksy",
            },
            format = {
              enable = true,
            },
          },
          redhat = {
            telemetry = {
              enabled = false,
            },
          },
        },
      },
      pyright = {
        settings = {
          pyright = {
            disableOrganizeImports = true,
          },
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
        cmd = { "ruff", "server" },
        filetypes = { "python" },
        root_dir = lspconfig.util.root_pattern("pyproject.toml", "ruff.toml", ".ruff.toml", ".git"),
        init_options = {
          settings = {
            args = {},
          },
        },
        on_attach = function(client)
          client.server_capabilities.hoverProvider = false
        end,
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
      tinymist = {
        cmd = { vim.fn.has("win32") == 1 and "tinymist.cmd" or "tinymist" },
      },
      tombi = {
        filetypes = { "toml" },
        root_markers = { "tombi.toml", "pyproject.toml", ".git", "Cargo.toml" },
      },
    },
  },
}
