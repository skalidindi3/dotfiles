-- set leader-based macros --

require("core.util")

-- tab management
keyset("n", "<leader>n", "<cmd>tabnext<CR>", { desc = "[Core]: tab next" })
keyset("n", "<leader>p", "<cmd>tabprevious<CR>", { desc = "[Core]: tab previous" })
keyset("n", "<leader><leader>", "<cmd>tab split<CR>", { desc = "[Core]: break pane into new tab" })

-- system clipboard management
keyset({ "n", "v" }, "<leader>yy", [["+y]], { desc = "[Core]: copy to system clipboard" })
keyset({ "n", "v" }, "<leader>pp", [["+p]], { desc = "[Core]: paste from system clipboard" })
keyset({ "n", "v" }, "<leader>PP", [["+P]], { desc = "[Core]: paste from system clipboard behind cursor" })
keyset("n", "<leader>P", "<cmd>set paste!<CR><cmd>set paste?<CR>", { silent = false, desc = "[Core]: toggle paste mode" })

-- search & replace
keyset("n", "<leader>/", "<cmd>noh<CR>", { silent = false, desc = "[Core]: clear search highlight" })
keyset(
    "n",
    "<leader>gr",
    [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
    { silent = false, desc = "[Core]: global replace cursor word" }
)
keyset(
    "v",
    "<leader>gr",
    [["ry:%s/\<<C-r>r\>/<C-r>r/gI<Left><Left><Left>]],
    { silent = false, desc = "[Core]: global replace selection" }
)
