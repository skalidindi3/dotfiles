-- set leader-based macros for plugins --

require("common")

-- primary toggles
keyset("n", "<C-t>", "<cmd>Neotree toggle<CR><cmd>VimadeDisable<CR>", { silent = false, desc = "toggle Neotree (also disabled pane fading)" })
keyset("n", "<C-f>", "<cmd>VimadeToggle<CR>", { silent = false, desc = "toggle inactive pane fading" })
keyset("n", "<C-g>", "<cmd>GitsignsToggleAll<CR>", { silent = false, desc = "toggle all extra gitsigns visuals" })
