-- rendering & visual cues --

return {
    -- git info in statuscolumn & buffer
    { "lewis6991/gitsigns.nvim" },

    -- visible indentation
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        opts = {
            scope = {
                enabled = true,
                show_start = false,
                show_end = false,
                -- PERF: issues/632
                include = { node_type = { ["*"] = { "*" } } },
            },
            -- see alternatives in doc/indent_blankline.txt
            indent = { char = "▏" },
        },
    },

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

    -- better csv/tsv rendering
    {
        "hat0uma/csvview.nvim",
        config = function()
            vim.api.nvim_create_autocmd("FileType", {
                pattern = "csv",
                callback = function()
                    vim.cmd("CsvViewEnable")
                    print("did it")
                end,
            })
            require("csvview").setup({
                parser = { comments = { "#", "//" } },
                view = { display_mode = "border" },
            })
        end,
    },

    -- fade inactive panes
    {
        "TaDaa/vimade",
        opts = {
            -- terminal emulator already animates cursor
            recipe = { "default", { animate = false } },
            fadelevel = 0.4,
        },
        cmd = { "VimadeToggle", "VimadeEnable", "VimadeBufEnable", "VimadeWinEnable" },
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
