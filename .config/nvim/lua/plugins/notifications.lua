-- notifications --

return {
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
    },
}
