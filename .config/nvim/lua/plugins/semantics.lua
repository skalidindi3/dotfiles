-- extra semantics for getting to & interacting with vim text objects --

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
}
