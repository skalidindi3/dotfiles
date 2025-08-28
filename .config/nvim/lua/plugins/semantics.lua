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
        -- stylua: ignore
        keys = {
            { "<leader>j", mode = { "n", "o" }, function() require("flash").jump() end, desc = "quick jump" },
            { "<leader>v", mode = { "n", "o" }, function() require("flash").treesitter() end, desc = "treesitter visual selection" },
        },
    },
}
