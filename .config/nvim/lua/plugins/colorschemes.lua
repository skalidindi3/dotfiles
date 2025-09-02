-- colorschemes --

return {
    -- default colorscheme
    {
        "AlexvZyl/nordic.nvim",
        priority = 1000, -- force loading first
        lazy = false,
        config = function()
            require("nordic").load({
                -- NOTE: after_palette overrides C.<color>
                -- NOTE: on_highlight overrides G.<color>
                on_highlight = function(highlights, palette)
                    -- neo-tree
                    highlights.TreeFolderIcon = { fg = palette.gray5 }
                    highlights.TreeFileIcon = { fg = palette.gray5 }
                    highlights.TreeGitStaged = { fg = palette.green.base }
                    highlights.NeoTreeGitModified = { fg = palette.orange.bright }
                    highlights.NeoTreeGitUnstaged = { fg = palette.yellow.bright }
                    highlights.NeoTreeModified = { fg = palette.yellow.bright }
                    -- indent-blankline
                    highlights.IblIndent = { fg = palette.gray2 }
                    highlights.IblScope = { fg = palette.blue0 }
                end,
            })
        end,
    },

    -- low contrast
    { "kdheepak/monochrome.nvim" },
    { "slugbyte/lackluster.nvim" },
    -- color bias
    { "everviolet/nvim" },
    { "rmehri01/onenord.nvim" },
    { "alexmozaidze/palenight.nvim" },
    { "neanias/everforest-nvim" },
    -- multi-set
    { "folke/tokyonight.nvim" },
    { "EdenEast/nightfox.nvim" },
    { "thesimonho/kanagawa-paper.nvim" },

    {
        "zaldih/themery.nvim",
        cmd = "Themery",
        config = function()
            local all_colorschemes = vim.fn.getcompletion("", "color")
            local plugin_exclude = {
                "dayfox", -- only light theme worth using, but ignore here
                "dawnfox",
                "evergarden",
                "evergarden-summer",
                "kanagawa-paper",
                "kanagawa-paper-canvas",
                "lackluster",
                "lackluster-hack",
                "onenord-light",
                "tokyonight",
                "tokyonight-day",
            }
            local plugin_colorschemes = ListDifference(all_colorschemes, _G.core_colorschemes)
            plugin_colorschemes = ListDifference(plugin_colorschemes, plugin_exclude)
            require("themery").setup({ themes = plugin_colorschemes })
        end,
    },
}

-- TODO: different colorscheme for diffs?
