-- extra vim semantics --

return {
    -- enable surround semantics
    {
        "echasnovski/mini.surround",
        version = "*",
        opts = {},
    },

    -- enable jumping & treesitter visual selection
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        opts = {
            modes = {
                char = {
                    enabled = false,
                },
            },
        },
    },

    -- show register contents
    {
        "tversteeg/registers.nvim",
        opts = {
            show = '"*+/.1234567890',
            -- " unnamed register
            -- * system clipboard
            -- + system clipboard (X11)
            -- / last search pattern
            -- . last inserted test
        },
    },
}
