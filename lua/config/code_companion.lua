require("codecompanion").setup({
  extensions = {
    mcphub = {
      callback = "mcphub.extensions.codecompanion",
      opts = {
        make_vars = true,
        make_slash_commands = true,
        show_result_in_chat = true,
      },
    },
  },
  strategies = {
    chat = {
      adapter = "ollama",
      model = "qwen3:latest",
    },
    inline = {
      adapter = "ollama",
      model = "qwen3:latest",
    },
    cmd = {
      adapter = "ollama",
      model = "qwen3:latest",
    },
  },
})
