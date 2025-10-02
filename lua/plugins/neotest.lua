return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-neotest/neotest-python",
    },
    opts = function(_, opts)
      opts.adapters = opts.adapters or {}
      table.insert(
        opts.adapters,
        require("neotest-python")({
          dap = { justMyCode = true },
          runner = "pytest",
          args = { "-q" },
        })
      )
      table.insert(opts.adapters, require("rustaceanvim.neotest"))
    end,
  },
}
