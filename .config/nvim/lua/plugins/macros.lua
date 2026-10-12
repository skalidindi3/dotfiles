-- set key mappings & macros for plugins --

require("core.util")

keyset("n", "<C-p>", "<cmd>VimadeToggle<CR>", { desc = "[Vimade]: toggle inactive pane fading/dimming" })
keyset("n", "<C-g><C-g>", "<cmd>GitsignsToggleAll<CR>", { desc = "[Gitsigns]: toggle all extra gitsigns visuals" })
keyset("n", "<C-g><C-b>", "<cmd>Gitsigns blame<CR>", { desc = "[Gitsigns]: open git blame pane" })
keyset({ "n", "v", "o" }, "<leader>j", require("flash").jump, { desc = "[Flash]: quick jump" })
keyset({ "n", "o" }, "<leader>v", require("flash").treesitter, { desc = "[Flash]: treesitter visual selection" })
