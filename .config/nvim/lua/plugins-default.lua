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

        -- statusline
        {
            "nvim-lualine/lualine.nvim",
            opts = {
                options = {
                    -- NOTE: can customize by passing a theme object (see lualine examples/)
                    theme = 'nordic',
                    icons_enabled = false,
                    component_separators = '|',
                    section_separators = '',
                },
                sections = { lualine_c = {'filename', 'filesize'} },
                inactive_sections = { lualine_x = {} },
            },
        },

        -- multiple cursors support
        -- TODO: read https://medium.com/@schtoeffel/you-don-t-need-more-than-one-cursor-in-vim-2c44117d51db
        {
            "mg979/vim-visual-multi",
            init = function()
                vim.g.VM_default_mappings = 0
                vim.g.VM_mouse_mappings = 0
                vim.g.VM_maps = {
                    ['Find Under']          = '<C-d>',  -- normal mode
                    ['Find Subword Under']  = '<C-d>',  -- visual mode
                    ['Switch Mode']         = 'v',      -- toggle back to normal mode
                }
            end,
        },

        -- enable surround semantics
        {
            "echasnovski/mini.surround",
            version = "*",
            opts = {},
        },

        -- visible indent lines
        {
            "lukas-reineke/indent-blankline.nvim",
            main = "ibl",
            opts = {
                -- PERF: issues/632
                scope = { include = { node_type = { ["*"] = { "*" } } } },
                -- see alternatives in doc/indent_blankline.txt
                indent = { char = "▏" },
            },
        },

        -- syntax highlighting for log files
        {
            'fei6409/log-highlight.nvim',
            opts = {
                extension = 'log',
                filename = { 'syslog' },
                pattern = {
                    '%/var%/log%/.*',
                    'console%-ramoops.*',
                    'log.*%.txt',
                    'logcat.*',
                },
            },
        },
    }
end

return M
