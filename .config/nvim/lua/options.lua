local o = vim.o

-- o.winborder = "rounded"

-- tabulations
o.tabstop = 4
o.shiftwidth = 4

o.ignorecase = true
o.smartcase = true

o.undofile = true

o.number = true
-- o.relativenumber = true

o.wrap = false

-- useless tbh
o.showtabline = 0

o.mouse = "a"

o.showmode = false

-- indent это отступ
-- типа 
-- ```python
-- def meow():
--     print("meow")
-- ```
o.smartindent = true
o.breakindent = true

o.signcolumn = "yes"

o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

o.confirm = true

o.completeopt = "fuzzy,menu,menuone,noselect"
o.swapfile = false
o.splitright = true
o.expandtab = true
