local lspconfig = require("lspconfig")

local function get_hostname()
  local f = io.open("/etc/hostname", "r")
  if f then
    local name = f:read("*l")
    f:close()
    return name
  end
  return "pavilion"
end

local host = get_hostname()
local flake_path = vim.fn.expand("~/.config/nixos")

return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      clangd = {
        mason = false,
        root_markers = { "compile_commands.json", ".clangd", "platformio.ini", ".git" },
      },
      cssls = { mason = false },
      html = { mason = false },
      jsonls = { mason = false },
      nixd = {
        mason = false,
        settings = {
          nixd = {
            formatting = {
              command = { "alejandra" },
            },
            options = {
              nixos = {
                expr = '(builtins.getFlake "' .. flake_path .. '").nixosConfigurations."' .. host .. '".options',
              },
              home_manager = {
                expr = '(builtins.getFlake "'
                  .. flake_path
                  .. '").nixosConfigurations."'
                  .. host
                  .. '".options.home-manager.users.type.getSubOptions []',
              },
            },
          },
        },
      },
      nil_ls = { mason = false, enabled = false },
      lua_ls = { mason = false },
      ty = { mason = false },
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
        enabled = false,
        mason = false,
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
        mason = false,
        cmd = { "ruff", "server" },
        init_options = {
          settings = {
            lint = {
              enable = true,
            },
          },
        },
      },
      texlab = {
        mason = false,
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
        mason = false,
        cmd = { vim.fn.has("win32") == 1 and "tinymist.cmd" or "tinymist" },
      },
      tombi = {
        mason = false,
        filetypes = { "toml" },
        root_markers = { "tombi.toml", "pyproject.toml", ".git", "Cargo.toml" },
      },
    },
  },
}
