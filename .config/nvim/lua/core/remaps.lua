-- set common key remaps --

require("common")

-- set leaders
vim.g.mapleader = ","
vim.g.maplocalleader = "\\"

-- disable arrow keys
keyset({ "n", "v" }, "<Up>", "<Nop>")
keyset({ "n", "v" }, "<Down>", "<Nop>")
keyset({ "n", "v" }, "<Left>", "<Nop>")
keyset({ "n", "v" }, "<Right>", "<Nop>")

-- autocorrect common typos
keyset("c", "Wq", "wq", { silent = false })
keyset("c", "Qa", "qa", { silent = false })
keyset("c", "Cq", "cq", { silent = false })

-- ex mode is annoying
keyset("n", "Q", "<Nop>")

-- consistency for yank & paste
keyset("n", "Y", "y$")
keyset("v", "p", "pgvy")

-- consistency for shifting in visual mode
keyset("v", "<", "<gv")
keyset("v", ">", ">gv")

-- navigate lines visually (useful for wrapped lines)
keyset("n", "j", "gj")
keyset("n", "k", "gk")
keyset("v", "j", "gj")
keyset("v", "k", "gk")

-- faster navigation to extremes
keyset({ "n", "v" }, "H", "^")
keyset({ "n", "v" }, "L", "$")
keyset({ "n", "v" }, "J", "G")
keyset({ "n", "v" }, "K", "gg")
keyset("n", "<C-j>", "<PageDown>")
keyset("n", "<C-k>", "<PageUp>")

-- code folding
keyset("n", "-", "zc")
keyset("n", "=", "zo")
keyset("n", "_", "zM")
keyset("n", "+", "zR")
