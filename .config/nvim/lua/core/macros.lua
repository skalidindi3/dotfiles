-- set leader-based macros --

require("common")

-- tab management
keyset("n", "<leader>n", "<cmd>tabnext<CR>", { desc = "tab next" })
keyset("n", "<leader>p", "<cmd>tabprevious<CR>", { desc = "tab previous" })
keyset("n", "<leader><leader>", "<cmd>tab split<CR>", { desc = "fullscreen pane into new tab" })

-- system clipboard management
keyset({ "n", "v" }, "<leader>yy", [["+y]], { desc = "copy to system clipboard" })
keyset({ "n", "v" }, "<leader>pp", [["+p]], { desc = "paste from system clipboard" })
keyset({ "n", "v" }, "<leader>PP", [["+P]], { desc = "paste from system clipboard behind cursor" })
keyset("n", "<leader>P", "<cmd>set paste!<CR><cmd>set paste?<CR>", { silent = false, desc = "toggle paste mode" })

-- search & replace
keyset("n", "<leader>/", "<cmd>noh<CR>", { silent = false, desc = "clear search highlight" })
keyset(
    "n",
    "<leader>gr",
    [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
    { silent = false, desc = "global replace cursor word" }
)
keyset(
    "v",
    "<leader>gr",
    [["ry:%s/\<<C-r>r\>/<C-r>r/gI<Left><Left><Left>]],
    { silent = false, desc = "global replace selection" }
)
