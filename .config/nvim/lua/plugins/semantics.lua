-- extra semantics for getting to & interacting with vim text objects --

return {
    -- enable surround semantics
    {
        "echasnovski/mini.surround",
        version = "*",
        opts = {},
    },

    -- enable comment test objects (ac, ic, aC)
    {
        "glts/vim-textobj-comment",
        dependencies = {
            "kana/vim-textobj-user",
        },
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
}
