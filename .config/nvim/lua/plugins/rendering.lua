-- rendering --

return {
    -- better highlighting for TODO/WARN/FIX, etc
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {
            signs = false,
            keywords = { TODO = { alt = { "TODOs" } } },
            highlight = { multiline = false },
        },
    },

    -- better markdown rendering
    {
        "OXY2DEV/markview.nvim",
        lazy = false,
        priority = 49,
        opts = {
            preview = {
                filetypes = { "markdown", "codecompanion" },
                ignore_buftypes = {},
            },
        },
    },

    -- syntax highlighting for log files
    {
        "fei6409/log-highlight.nvim",
        opts = {
            extension = "log",
            filename = { "syslog" },
            pattern = {
                "%/var%/log%/.*",
                "console%-ramoops.*",
                "log.*%.txt",
                "logcat.*",
            },
        },
    },
}
