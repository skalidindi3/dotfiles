-- set leader-based macros for plugins --

require("common")

keyset("n", "<C-t><C-t>", "<cmd>Neotree toggle<CR><cmd>VimadeDisable<CR>", { silent = false, desc = "toggle Neotree" })
keyset("n", "<C-t><C-f>", "<cmd>Telescope find_files<CR>", { silent = false, desc = "fuzzy finder for files" })
keyset("n", "<C-t><C-r>", "<cmd>Telescope live_grep<CR>", { silent = false, desc = "fuzzy finder for files" })
keyset("n", "<C-p>", "<cmd>VimadeToggle<CR>", { silent = false, desc = "toggle inactive pane fading" })
keyset("n", "<C-g>", "<cmd>GitsignsToggleAll<CR>", { silent = false, desc = "toggle all extra gitsigns visuals" })
keyset("n", "<C-f>", "<cmd>lua require('conform').format()<CR>", { silent = false, desc = "run conform format" })

keyset({ "n", "v", "o" }, "<leader>j", require("flash").jump, { desc = "quick jump" })
keyset({ "n", "o" }, "<leader>v", require("flash").treesitter, { desc = "treesitter visual selection" })
keyset("n", "<leader>d", "<cmd>DiagnosticsVisualsNext<CR>", { desc = "rotate diagnostic visuals" })
