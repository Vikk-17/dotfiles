require "nvchad.options"

-- add yours here!

local o = vim.o
o.cursorlineopt ='both' -- to enable cursorline!
o.shiftwidth = 4
o.relativenumber = true
o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
