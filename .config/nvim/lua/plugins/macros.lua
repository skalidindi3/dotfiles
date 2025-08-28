-- set leader-based macros for plugins --

require("common")

keyset("n", "<C-t>", "<cmd>Neotree toggle<CR><cmd>VimadeDisable<CR>", { silent = false, desc = "toggle Neotree" })
keyset("n", "<C-p>", "<cmd>VimadeToggle<CR>", { silent = false, desc = "toggle inactive pane fading" })
keyset("n", "<C-g>", "<cmd>GitsignsToggleAll<CR>", { silent = false, desc = "toggle all extra gitsigns visuals" })
keyset("n", "<C-f>", "<cmd>lua require('conform').format()<CR>", { silent = false, desc = "run conform format" })
