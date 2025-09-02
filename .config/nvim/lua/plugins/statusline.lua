-- statusline --

return {
    {
        "nvim-lualine/lualine.nvim",
        opts = {
            options = {
                -- NOTE: can customize by passing a theme object (see lualine examples/)
                theme = "nordic",
                icons_enabled = false,
                component_separators = "|",
                section_separators = "",
            },
            sections = { lualine_c = { "filename", "filesize" } },
            inactive_sections = { lualine_x = {} },
        },
    },
}

-- TODO: akinsho/bufferline.nvim just for tab highlighting?
