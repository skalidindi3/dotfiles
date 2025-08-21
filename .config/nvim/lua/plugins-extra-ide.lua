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

        -- minimal vim.notify
        {
            "j-hui/fidget.nvim",
            opts = {
                notification = {
                    override_vim_notify = true,
                    view = {
                        stack_upwards = false,
                    },
                    window = {
                        x_padding = 1,
                        y_padding = 0,
                        align = "top",
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
