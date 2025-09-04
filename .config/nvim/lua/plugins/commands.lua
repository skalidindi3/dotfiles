-- define user commands for plugins --

vim.api.nvim_create_user_command("StripTrailingWhitespace", function()
    vim.cmd([[%s/\s\+$//e]])
end, { nargs = 0, desc = "stage the current buffer" })

vim.api.nvim_create_user_command("DiagnosticsVisualsNext", function()
    if not _G.UserDiagnosticVisualEnum then
        _G.UserDiagnosticVisualEnum = 1
    end
    _G.UserDiagnosticVisualEnum = _G.UserDiagnosticVisualEnum + 1
    if _G.UserDiagnosticVisualEnum == 1 then
        vim.diagnostic.config({ virtual_lines = false, virtual_text = false })
        print("Diagnostic text disabled")
    elseif _G.UserDiagnosticVisualEnum == 2 then
        vim.diagnostic.config({ virtual_lines = false, virtual_text = true })
        print("Diagnostic virtual text enabled")
    else
        vim.diagnostic.config({ virtual_lines = true, virtual_text = false })
        print("Diagnostic virtual lines enabled")
        _G.UserDiagnosticVisualEnum = 0
    end
end, { nargs = 0, desc = "stage the current buffer" })

-- gitsigns
-- stylua: ignore start
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
-- stylua: ignore end
