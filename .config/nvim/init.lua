vim.loader.enable()

vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.have_nerd_font = true

require("options")
vim.schedule(function() vim.opt.clipboard = "unnamedplus" end)

require("plugins")
require("plugin-config")
require("lsp")
require("keymaps")

