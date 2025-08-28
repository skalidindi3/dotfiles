-- define user commands for plugins --

-- gitsigns
vim.api.nvim_create_user_command(
    "GitsignsToggleAll",
    function()
        -- skip toggle_signs
        vim.cmd("Gitsigns toggle_numhl")
        vim.cmd("Gitsigns toggle_linehl")
        vim.cmd("Gitsigns toggle_word_diff")
        vim.cmd("Gitsigns toggle_deleted")
        vim.notify("Toggled git visuals", vim.log.levels.INFO)
    end,
    { nargs = 0, desc = "toggle all extra gitsigns visuals" }
)
vim.api.nvim_create_user_command(
    "Gitaa",
    function() vim.cmd("Gitsigns stage_hunk") end,
    { nargs = 0, desc = "stage the current buffer" }
)
vim.api.nvim_create_user_command(
    "Gita",
    function() vim.cmd("Gitsigns stage_hunk") end,
    { nargs = 0, desc = "stage the selected hunk" }
)
vim.api.nvim_create_user_command(
    "Gitr",
    function() vim.cmd("Gitsigns undo_stage_hunk") end,
    { nargs = 0, desc = "unstage the selected hunk" }
)
