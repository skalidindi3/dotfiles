-- set key mappings & macros for plugins --

require("core.util")

local tb = require("telescope.builtin")

keyset("n", "<C-t><C-t>", "<cmd>Neotree toggle<CR>", { desc = "[Neotree]: toggle Neotree" })
keyset("n", "<C-t><C-f>", tb.find_files, { desc = "[Telescope]: fuzzy finder for files" })
keyset("n", "<C-t><C-r>", LiveRipgrep, { desc = "[Telescope]: live ripgrep" })
keyset("n", "<C-t><C-b>", tb.buffers, { desc = "[Telescope]: fuzzy finder for buffers" })
keyset("n", "<C-t><C-q>", tb.quickfix, { desc = "[Telescope]: fuzzy finder for quickfix menu" })
keyset("n", "<C-t><C-s>", tb.treesitter, { desc = "[Telescope]: fuzzy finder for treesitter symbols" })
keyset("n", "<C-t><C-h>", tb.help_tags, { desc = "[Telescope]: fuzzy finder for help info" })
keyset("n", "<C-t><C-k>", MakeCustomKeymapsPicker, { desc = "[Telescope]: fuzzy finder for key mappings" })
keyset("n", "<C-p>", "<cmd>VimadeToggle<CR>", { desc = "[Vimade]: toggle inactive pane fading/dimming" })
keyset("n", "<C-g><C-g>", "<cmd>GitsignsToggleAll<CR>", { desc = "[Gitsigns]: toggle all extra gitsigns visuals" })
keyset("n", "<C-g><C-b>", "<cmd>Gitsigns blame<CR>", { desc = "[Gitsigns]: open git blame pane" })
keyset("n", "<C-f>", "<cmd>FormatBuffer<CR>", { desc = "[Conform]: run conform format" })
keyset("n", "<C-c><C-c>", "<cmd>CodeCompanionChat Toggle<CR>", { desc = "[CodeCompanion]: toggle ai chat" })
keyset("n", "<C-c><C-i>", "<cmd>CodeCompanion<CR>", { desc = "[CodeCompanion]: start ai cmd" })

keyset("n", "<leader>d", "<cmd>DiagnosticsVisualsNext<CR>", { desc = "[LSP]: rotate diagnostic visuals" })
keyset({ "n", "v", "o" }, "<leader>j", require("flash").jump, { desc = "[Flash]: quick jump" })
keyset({ "n", "o" }, "<leader>v", require("flash").treesitter, { desc = "[Flash]: treesitter visual selection" })
keyset("n", "<leader>en", function()
    require("telescope.builtin").find_files({
        find_command = { "fd", "--type", "f", "--follow", "--hidden", "--exclude", ".git" },
        cwd = vim.fn.stdpath("config"),
    })
end, { desc = "[Telescope]: edit nvim config files" })
keyset("n", "<leader>ep", function()
    require("telescope.builtin").find_files({
        find_command = { "fd", "--type", "f", "--follow", "--hidden", "--exclude", ".git" },
        cwd = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy"),
    })
end, { desc = "[Telescope]: edit nvim plugin files" })
