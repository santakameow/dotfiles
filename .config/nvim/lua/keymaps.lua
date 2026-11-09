local map = vim.keymap.set

map("n", "<Esc>", "<cmd>nohlsearch<cr>")

-- exit terminal with easier shortcut
map('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

map("n", "-", "<cmd>Oil<cr>", { desc = "Open file explorer" })
map("n", "<leader>gg", "<cmd>Neogit<cr>", { desc = "Open Neogit UI" })

local fff = require("fff")
map("n", "<leader>ff", function() fff.find_files() end, { desc = "find files" })
map("n", "<leader>fg", function() fff.live_grep() end, { desc = "live grep" })
