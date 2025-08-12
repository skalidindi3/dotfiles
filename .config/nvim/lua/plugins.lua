-- plugins managed by folke/lazy.nvim

-- get lazy.nvim if not present
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({
        "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath
    })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
    -- default colorscheme
    {
        "AlexvZyl/nordic.nvim",
        lazy = false,
        priority = 1000,    -- force loading first
        config = function() require("nordic").load() end,
    },

    -- alternate colorscheme
    {
        "folke/tokyonight.nvim",
        lazy = false,
    },

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
                --component_separators = { left = ' ', right = ' '},
                --section_separators = { left = ' ', right = ' '},
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

--- MIN ---

    --{
    --    "j-hui/fidget.nvim",
    --    opts = {
    --        notification = {
    --            override_vim_notify = true,
    --            view = {
    --                stack_upwards = false,
    --            },
    --            window = {
    --                x_padding = 1,
    --                y_padding = 0,
    --                align = "top",
    --            },
    --        },
    --    },
    --}

--- IDE ---

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
        "luukvbaal/statuscol.nvim"
    },

    {
        "kevinhwang91/nvim-ufo",
        dependencies = { "kevinhwang91/promise-async" },
        config = function()
            vim.o.foldcolumn = '1' -- '0' is not bad
            vim.o.fillchars = [[eob: ,fold: ,foldopen:>,foldsep: ,foldclose:v]]
            vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
            vim.o.foldlevelstart = 99
            vim.o.foldenable = true
        end,
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
            --{ 'echasnovski/mini.notify', version = false },
        }
    },
})

local builtin = require("statuscol.builtin")
require("statuscol").setup({
    foldfunc = "builtin",
    setopt = true,
    relculright = false,
    segments = {
        { text = { builtin.foldfunc }, click = "v:lua.ScFa" },
        { text = { "%s" } },
        { text = { builtin.lnumfunc, " " } },
    },
})

--require('lualine').setup({
--    options = {
--        icons_enabled = false,
--    },
--    sections = {
--    },
--})

-- TODO: nvim as MANPAGER
-- TODO: extra plugins
-- https://dotfyle.com/neovim/plugins/trending
--
-- rcarriga/nvim-notify
--
-- https://blog.pabuisson.com/2022/08/neovim-modern-features-treesitter-and-lsp/
-- - https://www.youtube.com/watch?v=w7i4amO_zaE
--   - treesitter playground
-- - https://medium.com/@jacksmithxyz/setting-up-neovim-tree-sitter-and-built-in-lsp-86a853d70590
-- - https://www.youtube.com/watch?v=x__SZUuLOxw
-- sindrets/diffview.nvim
-- - https://github.com/sindrets/diffview.nvim/issues/546
-- - https://www.reddit.com/r/neovim/comments/n2vww8/diffviewnvim_cycle_through_diffs_for_all_modified/
-- dstein64/vim-startuptime
-- - https://lazy.folke.io/spec/examples
-- fei6409/log-highlight.nvim
-- folke/snacks.nvim/blob/main/docs/indent.md
-- folke/noice.nvim
-- folke/which-key.nvim
-- - "*" search word under cursor / or visual block
-- - g as the global command
--   - https://www.youtube.com/watch?v=1M-XDGc20ns
-- - VimodeDisable for fading windows?
-- folke/flash.nvim
-- folke/twilight.nvim
-- b0o/incline.nvim
-- OXY2DEV/markview.nvim




-- mg979/vim-visual-multi
-- - https://www.youtube.com/watch?v=LhcnGU-COpo
-- - lazy = false
