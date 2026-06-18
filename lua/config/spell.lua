-- Enable spell checking
vim.opt.spell = true

-- Set languages (order matters: first is default for suggestions)
vim.opt.spelllang = { "en_us", "de" }
vim.opt.spelloptions = "camel"

vim.cmd("highlight SpellBad gui=underline guifg=red")
