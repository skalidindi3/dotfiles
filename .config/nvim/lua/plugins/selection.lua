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

    -- extensible fuzzy finder & picker
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope-ui-select.nvim",
        },
        config = function()
            local actions = require("telescope.actions")
            require("telescope").setup({
                defaults = {
                    mappings = {
                        i = { ["<C-s>"] = actions.select_horizontal },
                        n = { ["<C-s>"] = actions.select_horizontal },
                    },
                },
                pickers = {
                    -- live preview colorschemes
                    colorscheme = { enable_preview = true },
                    quickfix = { theme = "ivy" },
                    treesitter = { theme = "ivy" },
                },
            })
            require("telescope").load_extension("ui-select")
            require("plugins.telescope.custom_keymaps")
            require("plugins.telescope.live_ripgrep")
        end,
    },
}

-- TODO: read https://medium.com/@schtoeffel/you-don-t-need-more-than-one-cursor-in-vim-2c44117d51db
