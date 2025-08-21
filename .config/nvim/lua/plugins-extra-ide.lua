-- plugins for a more IDE-style nvim setup
local M = {}

function M.get_plugins()
    return {
        -- fade inactive panes
        {
            "TaDaa/vimade",
            opts = {
                -- terminal emulator already animates cursor
                recipe = {'default', {animate = false}},
                fadelevel = 0.25,
            },
            --config = function()
            --    -- disable at startup
            --    vim.cmd("VimadeDisable")
            --end,
        },

        {
            "folke/todo-comments.nvim",
            dependencies = { "nvim-lua/plenary.nvim" },
            opts = {
                signs = false,
                keywords = { TODO = { alt = { "TODOs" } } },
                highlight = { multiline = false },
            },
        },

        {
            "folke/noice.nvim",
            event = "VeryLazy",
            opts = {
                cmdline = {
                    format = {
                        cmdline = { icon = ">" },
                        search_down = { icon = "🔍⌄" },
                        search_up = { icon = "🔍⌃" },
                        filter = { icon = "$" },
                        lua = { icon = "☾" },
                        help = { icon = "?" },
                    },
                },
                format = {
                    level = {
                        icons = {
                          error = "✖",
                          warn = "▼",
                          info = "●",
                        },
                    },
                },
                popupmenu = {
                    kind_icons = false,
                },
                inc_rename = {
                    cmdline = {
                        format = {
                            IncRename = { icon = "⟳" },
                        },
                    },
                },
            },
            dependencies = {
                "MunifTanjim/nui.nvim",
                "rcarriga/nvim-notify",
            }
        },
    }
end

return M
