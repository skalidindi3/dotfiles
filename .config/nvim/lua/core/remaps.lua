-- set common key remaps --

require("common")

-- set leaders
vim.g.mapleader = ","
vim.g.maplocalleader = "\\"

-- disable arrow keys
keyset({ "n", "v" }, "<Up>", "<Nop>", { desc = "remap: disable arrow key" })
keyset({ "n", "v" }, "<Down>", "<Nop>", { desc = "remap: disable arrow key" })
keyset({ "n", "v" }, "<Left>", "<Nop>", { desc = "remap: disable arrow key" })
keyset({ "n", "v" }, "<Right>", "<Nop>", { desc = "remap: disable arrow key" })

-- autocorrect common typos
keyset("c", "Wq", "wq", { silent = false , desc = "remap: autocorrect" })
keyset("c", "Qa", "qa", { silent = false , desc = "remap: autocorrect" })
keyset("c", "Cq", "cq", { silent = false , desc = "remap: autocorrect" })

-- ex mode is annoying
keyset("n", "Q", "<Nop>")

-- consistency for yank & paste
keyset("n", "Y", "y$", { desc = "remap: yank till end of line" })
keyset("v", "p", "pgvy", { desc = "remap: paste but don't overwrite register" })

-- consistency for shifting in visual mode
keyset("v", "<", "<gv", { desc = "remap: stay in visual mode when shifting" })
keyset("v", ">", ">gv", { desc = "remap: stay in visual mode when shifting" })

-- navigate lines visually (useful for wrapped lines)
keyset("n", "j", "gj", { desc = "remap: navigate wrapped lines visually" })
keyset("n", "k", "gk", { desc = "remap: navigate wrapped lines visually" })
keyset("v", "j", "gj", { desc = "remap: navigate wrapped lines visually" })
keyset("v", "k", "gk", { desc = "remap: navigate wrapped lines visually" })

-- faster navigation to extremes
keyset({ "n", "v" }, "H", "^", { desc = "remap: navigate to extremes" })
keyset({ "n", "v" }, "L", "$", { desc = "remap: navigate to extremes" })
keyset({ "n", "v" }, "J", "G", { desc = "remap: navigate to extremes" })
keyset({ "n", "v" }, "K", "gg", { desc = "remap: navigate to extremes" })
keyset("n", "<C-j>", "<PageDown>", { desc = "remap: navigate to extremes" })
keyset("n", "<C-k>", "<PageUp>", { desc = "remap: navigate to extremes" })

-- code folding
keyset("n", "-", "zc", { desc = "remap: close current fold" })
keyset("n", "=", "zo", { desc = "remap: open current fold" })
keyset("n", "_", "zM", { desc = "remap: close all folds" })
keyset("n", "+", "zR", { desc = "remap: open all folds" })
