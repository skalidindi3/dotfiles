-- multiple cursors support --

return {
    {
        "mg979/vim-visual-multi",
        init = function()
            vim.g.VM_default_mappings = 0
            vim.g.VM_mouse_mappings = 0
            vim.g.VM_maps = {
                ["Find Under"]          = "<C-d>",  -- normal mode
                ["Find Subword Under"]  = "<C-d>",  -- visual mode
                ["Switch Mode"]         = "v",      -- toggle back to normal mode
            }
        end,
    },
}

-- TODO: read https://medium.com/@schtoeffel/you-don-t-need-more-than-one-cursor-in-vim-2c44117d51db
