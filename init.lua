-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
require("config.lsp-config")
require("config.jupynuim")
require("overseer").setup({
  templates = { "builtin", "user" },
})
require("config.autocommands")
