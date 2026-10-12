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
                    -- csv view
                    highlights.CsvViewCol0 = { fg = palette.red.bright }
                    highlights.CsvViewCol1 = { fg = palette.orange.bright }
                    highlights.CsvViewCol2 = { fg = palette.yellow.bright }
                    highlights.CsvViewCol3 = { fg = palette.green.bright }
                    highlights.CsvViewCol4 = { fg = palette.cyan.bright }
                    highlights.CsvViewCol5 = { fg = palette.blue1 }
                    highlights.CsvViewCol6 = { fg = palette.magenta.bright }
                    --highlights.CsvViewCol7 = { fg = palette.orange.bright }
                    --highlights.CsvViewCol8 = { fg = palette.orange.bright }
                end,
            })
        end,
    },

    -- NEW: ayu
    { "shatur/neovim-ayu" },
    -- low contrast
    { "kdheepak/monochrome.nvim" },
    { "slugbyte/lackluster.nvim" },
    -- color bias
    { "everviolet/nvim" , name = "evergarden-nvim" },
    { "neanias/everforest-nvim" },
    { "rmehri01/onenord.nvim" },
    { "alexmozaidze/palenight.nvim" },
    -- multi-set
    { "folke/tokyonight.nvim" },
    { "EdenEast/nightfox.nvim" },
    { "thesimonho/kanagawa-paper.nvim" },
}

-- TODO: different colorscheme for diffs?
