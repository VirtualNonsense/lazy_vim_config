-- rustaceanvim uses rust-analyzer to find the list of possible targets to debug, but rust-analyzer
-- only returns targets for the current file. Since I mostly work on binaries with library modules
-- in the same project, go to main.rs, start the debugger, and then come back to the current module.
local function debug_rust_main(bang)
  local main_rs_path = vim.fn.findfile("main.rs", ".;")
  print(main_rs_path)
  local current_path = vim.fn.expand("%")
  if main_rs_path == "" then
    error("Could not find main.rs in debug_rust_main()")
    return
  end

  vim.cmd("edit " .. main_rs_path)
  if bang then
    vim.cmd("RustLsp! debuggables")
  else
    vim.cmd("RustLsp debuggables")
  end
  vim.cmd("edit " .. current_path)
end

return {
  {

    "mrcjkb/rustaceanvim",
    version = "^6", -- Recommended
    lazy = false, -- This plugin is already lazy
    config = function()
      vim.g.rustaceanvim = {
        -- LSP configuration
        server = {
          on_attach = function(client, bufnr)
            local opts = { buffer = bufnr, silent = true }

            -- Hover actions
            -- vim.keymap.set("n", "K", function()
            --   vim.cmd.RustLsp({ "hover", "actions" })
            -- end, vim.tbl_extend("force", opts, { desc = "Show documentation" }))

            vim.keymap.set("n", "gm", function()
              vim.cmd.RustLsp({ "expandMacro" })
            end, { desc = "Expand macros" })
            -- Code actions
            vim.keymap.set("n", "<A-CR>", function()
              vim.cmd.RustLsp("codeAction")
            end, vim.tbl_extend("force", opts, { desc = "Code actions" }))

            vim.keymap.set("n", "<F6>", debug_rust_main)
          end,
          default_settings = {
            ["rust_analyser"] = {
              cargo = {
                allFeatures = true,
              },
              checkOnSave = {
                command = "clippy",
              },
              procMacro = {
                enable = true,
              },
              ignored = {
                leptos_macro = {
                  -- optional: --
                  -- -- "component",
                  "server",
                },
              },
            },
          },
        },
      }
    end,
  },
}
