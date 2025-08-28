-- visual cues --

return {
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

    -- git info in statuscolumn & buffer
    { "lewis6991/gitsigns.nvim" },

    -- fade inactive panes
    {
        "TaDaa/vimade",
        opts = {
            -- terminal emulator already animates cursor
            recipe = { "default", { animate = false } },
            fadelevel = 0.25,
        },
    },
}
