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

    -- alternate colorscheme
    { "folke/tokyonight.nvim" },
}
