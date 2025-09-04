-- set key mappings & macros for plugins --

require("common")

keyset("n", "<C-t><C-t>", "<cmd>Neotree toggle<CR><cmd>VimadeDisable<CR>", { silent = false, desc = "toggle Neotree" })
keyset("n", "<C-t><C-f>", "<cmd>Telescope find_files<CR>", { silent = false, desc = "fuzzy finder for files" })
keyset("n", "<C-t><C-r>", "<cmd>Telescope live_grep<CR>", { silent = false, desc = "fuzzy finder for files" })
keyset("n", "<C-t><C-b>", "<cmd>Telescope buffers<CR>", { silent = false, desc = "fuzzy finder for buffers" })
keyset("n", "<C-p>", "<cmd>VimadeToggle<CR>", { silent = false, desc = "toggle inactive pane fading" })
keyset("n", "<C-g><C-g>", "<cmd>GitsignsToggleAll<CR>", { silent = false, desc = "toggle all extra gitsigns visuals" })
keyset("n", "<C-g><C-b>", "<cmd>Gitsigns blame<CR>", { silent = false, desc = "open git blame pane" })
keyset("n", "<C-f>", "<cmd>FormatBuffer<CR>", { silent = false, desc = "run conform format" })
keyset("n", "<C-c><C-c>", "<cmd>CodeCompanionChat Toggle<CR><cmd>VimadeDisable<CR>", { silent = false, desc = "toggle ai chat" })
keyset("n", "<C-c><C-i>", "<cmd>CodeCompanion<CR>", { silent = false, desc = "start ai cmd" })

keyset({ "n", "v", "o" }, "<leader>j", require("flash").jump, { desc = "quick jump" })
keyset({ "n", "o" }, "<leader>v", require("flash").treesitter, { desc = "treesitter visual selection" })
keyset("n", "<leader>d", "<cmd>DiagnosticsVisualsNext<CR>", { desc = "rotate diagnostic visuals" })
