-- global commands for usage from nvim command line --

vim.api.nvim_create_user_command("DumpIntoBuffer", function(opts)
    local result = load("return " .. opts.args)()
    -- NOTE: can't format with conform/treesitter in an anonymous buffer
    local note = "-- NOTE: save to temp lua file to format with conform"
    local lines = vim.split(note .. "local dump = " .. vim.inspect(result), "\n")
    vim.api.nvim_buf_set_lines(0, -1, -1, false, lines)
    vim.cmd([[%s/\(<function \d>\)/"\1"/g]]) -- wrap fns as strings
end, { nargs = 1, desc = "[Core]: vim.inspect output of arg into buffer" })

vim.api.nvim_create_user_command("StripTrailingWhitespace", function()
    vim.cmd([[%s/\s\+$//e]])
    vim.notify("Stripped whitespace", vim.log.levels.INFO)
end, { nargs = 0, desc = "[Core]: strip whitespace for the current buffer" })
