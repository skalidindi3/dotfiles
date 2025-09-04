-- selection extensions --

return {
    -- multiple cursors support --
    {
        "mg979/vim-visual-multi",
        init = function()
            vim.g.VM_default_mappings = 0
            vim.g.VM_mouse_mappings = 0
            -- stylua: ignore
            vim.g.VM_maps = {
                ["Find Under"]          = "<C-d>",  -- normal mode
                ["Find Subword Under"]  = "<C-d>",  -- visual mode
                ["Switch Mode"]         = "v",      -- toggle back to normal mode
            }
        end,
    },

    -- fuzzy finder and picker
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.8",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local actions = require("telescope.actions")
            require("telescope").setup({
                defaults = {
                    mappings = {
                        i = {
                            ["<C-s>"] = actions.select_horizontal,
                        },
                        n = {
                            ["<C-s>"] = actions.select_horizontal,
                        },
                    },
                },
            })
        end,
    },
}

-- TODO: read https://medium.com/@schtoeffel/you-don-t-need-more-than-one-cursor-in-vim-2c44117d51db
