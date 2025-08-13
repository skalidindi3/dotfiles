-- default plugins for all setups

local M = {}

function M.get_plugins()
    return {
        -- default colorscheme
        {
            "AlexvZyl/nordic.nvim",
            lazy = false,
            priority = 1000,    -- force loading first
            config = function()
                require('nordic').load({
                    after_palette = function(palette)
                        palette.bg_fold = palette.gray0
                        palette.fg_fold = palette.yellow.base
                    end,
                })
            end,
        },

        -- alternate colorscheme
        { "folke/tokyonight.nvim" },

        -- statusline
        {
            "nvim-lualine/lualine.nvim",
            opts = {
                options = {
                    theme = 'nordic',
                    -- TODO: customize nordic colorscheme
                    icons_enabled = false,
                    component_separators = '|',
                    section_separators = '',
                },
                sections = {
                    lualine_c = {'filename', 'filesize'},
                    -- TODO: add mark for saved/unsaved buffer
                    -- Unicode Character “✔” (U+2714)
                    -- Unicode Character “✘” (U+2718)
                    -- Unicode Character “✗” (U+2717)
                },
                inactive_sections = {
                    lualine_x = {},
                },
            },
        },

        -- multiple cursors support
        {
            "mg979/vim-visual-multi",
            init = function()
                vim.g.VM_default_mappings = 0
                vim.g.VM_mouse_mappings = 0
                vim.g.VM_maps = {
                    ['Find Under']         = '<C-d>',   -- normal mode
                    ['Find Subword Under'] = '<C-d>',   -- visual mode
                }
            end,
        },

        -- visible indent lines
        {
            "lukas-reineke/indent-blankline.nvim",
            main = "ibl",
            opts = {},
        },
    }
end

return M
