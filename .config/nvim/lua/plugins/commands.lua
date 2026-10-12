-- define user commands for plugins --

-- LSP diagnostics
vim.api.nvim_create_user_command("FormatBuffer", function()
    require("conform").format()
    vim.notify("Formatted buffer", vim.log.levels.INFO)
end, { nargs = 0, desc = "strip whitespace for the current buffer" })
vim.api.nvim_create_user_command("DiagnosticsVisualsNext", function()
    if not _G.UserDiagnosticVisualEnum then
        _G.UserDiagnosticVisualEnum = 1
    end
    _G.UserDiagnosticVisualEnum = _G.UserDiagnosticVisualEnum + 1
    if _G.UserDiagnosticVisualEnum == 1 then
        vim.diagnostic.config({ virtual_lines = false, virtual_text = false })
        vim.notify("Diagnostic text disabled", vim.log.levels.INFO)
    elseif _G.UserDiagnosticVisualEnum == 2 then
        vim.diagnostic.config({ virtual_lines = false, virtual_text = true })
        vim.notify("Diagnostic virtual text enabled", vim.log.levels.INFO)
    else
        vim.diagnostic.config({ virtual_lines = true, virtual_text = false })
        vim.notify("Diagnostic virtual lines enabled", vim.log.levels.INFO)
        _G.UserDiagnosticVisualEnum = 0
    end
end, { nargs = 0, desc = "rotate through diagnostic visibility options" })

-- gitsigns
vim.api.nvim_create_user_command("GitsignsToggleAll", function()
    -- skip toggle_signs
    vim.cmd("Gitsigns toggle_numhl")
    vim.cmd("Gitsigns toggle_linehl")
    vim.cmd("Gitsigns toggle_word_diff")
    vim.cmd("Gitsigns toggle_deleted")
    vim.notify("Toggled git visuals", vim.log.levels.INFO)
end, { nargs = 0, desc = "toggle all extra gitsigns visuals" })
vim.api.nvim_create_user_command("Gitaa", function()
    vim.cmd("Gitsigns stage_hunk")
    vim.notify("Staged the current buffer", vim.log.levels.INFO)
end, { nargs = 0, desc = "stage the current buffer" })
vim.api.nvim_create_user_command("Gita", function()
    vim.cmd("Gitsigns stage_hunk")
    vim.notify("Staged the selected hunk", vim.log.levels.INFO)
end, { nargs = 0, desc = "stage the selected hunk" })
vim.api.nvim_create_user_command("Gitr", function()
    vim.cmd("Gitsigns undo_stage_hunk")
    vim.notify("Unstaged the selected hunk", vim.log.levels.INFO)
end, { nargs = 0, desc = "unstage the selected hunk" })
