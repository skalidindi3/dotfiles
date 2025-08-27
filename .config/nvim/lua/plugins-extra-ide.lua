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
        },

        -- better highlighting for TODO/WARN/FIX, etc
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
        },

        { "lewis6991/gitsigns.nvim" },

        {
            "nvim-neo-tree/neo-tree.nvim",
            branch = "v3.x",
            dependencies = {
                "nvim-lua/plenary.nvim",
                "MunifTanjim/nui.nvim",
            },
            lazy = false, -- neo-tree will lazily load itself
            config = function()
                window_mappings = {
                    -- basic
                    ["?"] = "show_help",
                    ["q"] = "close_window",

                    -- filesystem interaction
                    ["r"] = "refresh",
                    ["i"] = "show_file_details",

                    -- folding
                    ["<space>"] = "toggle_node",
                    ["M"] = "close_all_nodes",
                    ["R"] = "expand_all_nodes",

                    -- access
                    ["<cr>"] = "open",
                    ['s'] = "open_split",
                    ["v"] = "open_vsplit",
                    ["t"] = "open_tabnew",

                    -- floating preview
                    ["<esc>"] = "cancel",
                    ["P"] = {
                        "toggle_preview",
                        config = {
                            use_float = true,
                            use_snacks_image = true,
                            use_image_nvim = true,
                            title = "Neo-tree Preview",
                        }
                    },

                    -- rotate through sources
                    ["<leader>p"] = "prev_source",
                    ["<leader>n"] = "next_source",
                }
                fs_window_mappings = {
                    -- filesystem interaction
                    ["H"] = "toggle_hidden",
                    ["<bs>"] = "navigate_up",
                    ["."] = "set_root",
                }
                buffers_window_mappings = {
                    -- filesystem interaction
                    ["<bs>"] = "navigate_up",
                    ["."] = "set_root",
                }

                -- overwrite the default mappings
                local config_to_override = require("neo-tree.defaults")
                config_to_override.window.mappings = window_mappings
                config_to_override.filesystem.window.mappings = fs_window_mappings
                config_to_override.buffers.window.mappings = buffers_window_mappings
                config_to_override.git_status.window.mappings = {}
                config_to_override.filesystem.window.fuzzy_finder_mappings = {}

                -- force "fullscreen" tree view when opening directory
                config_to_override.filesystem.hijack_netrw_behavior = "open_current"

                -- icons
                -- NOTE: more icons at https://github.com/ryanoasis/nerd-fonts/blob/master/bin/scripts/lib/
                config_to_override.default_component_configs.icon.default = ""
                config_to_override.default_component_configs.modified.symbol = ""
                config_to_override.default_component_configs.git_status.symbols.added = ""
                config_to_override.default_component_configs.git_status.symbols.modified = ""
            end,
        },

        {
            "OXY2DEV/markview.nvim",
            lazy = false,
            priority = 49,
            opts = {},
        },

        {
            'nvim-treesitter/nvim-treesitter',
            dependencies = { "OXY2DEV/markview.nvim" },
            lazy = false,
            branch = 'master',  -- 'main' documentation lacking
            build = ':TSUpdate',
            config = function()
                local treesitter = require("nvim-treesitter.configs")
                treesitter.setup({
                    sync_install = false,
                    auto_install = true,
                    indent = { enable = true },
                    highlight = {
                        enable = true,
                        additional_vim_regex_highlighting = false,
                    },
                    ensure_installed = {
                        "lua",
                        "c", "cpp", "asm", "disassembly", "objdump",
                        "python",
                        "markdown",
                        "bash", "diff", "tmux",
                        "json", "jq",
                        "yaml", "dockerfile", "caddy",
                        "html", "css", "javascript", "sql",
                        -- "udev", "ini", "csv", "tsv",
                        -- "cmake", "cuda", "arduino",
                        -- "vim", "vimdoc", "help" :: vim specific
                    },
                })
            end
        },
        -- nvim-treesitter/nvim-treesitter-context
        -- nvim-treesitter/nvim-treesitter-textobjects
        -- nvim-treesitter/nvim-treesitter-refactor (jump to definition)

        -- https://medium.com/@jogarcia/autoload-lsps-in-neovim-with-mason-f14154f51019
        {
            "mason-org/mason-lspconfig.nvim",
            dependencies = {
                "neovim/nvim-lspconfig",
                "mason-org/mason.nvim",
            },
            config = function()
                vim.diagnostic.config {
                   virtual_lines = false, --not vim.diagnostic.config().virtual_lines,
                   virtual_text = true, --not vim.diagnostic.config().virtual_text,
                }
                require("common")
                keyset('n', '<leader>d', function()
                    vim.diagnostic.config {
                       virtual_lines = not vim.diagnostic.config().virtual_lines,
                       virtual_text = not vim.diagnostic.config().virtual_text,
                    }
                end, { desc = "Edit configuration" })
                -- https://gpanders.com/blog/whats-new-in-neovim-0-11/#virtual-text-handler-changed-from-opt-out-to-opt-in
                -- https://www.reddit.com/r/neovim/comments/1jo9oe9/i_set_up_my_config_to_use_virtual_lines_for/
                -- TODO: iterate with https://github.com/rachartier/tiny-inline-diagnostic.nvim
                -- https://www.youtube.com/watch?v=bTWWFQZqzyI
                require('mason').setup({})
                local lspconfig = require('lspconfig')
                require('mason-lspconfig').setup({
                    ensure_installed = {
                        "lua_ls",
                        "clang-format",
                        "ruff",
                        "pyrefly",
                    },
                    handlers = {
                        -- custom setups
                        ['lua_ls'] = function()
                            lspconfig.lua_ls.setup({
                                settings = {
                                    Lua = {
                                        workspace = {
                                            -- Make the server aware of Neovim runtime files
                                            library = {
                                                "lua",
                                                "${3rd}/luv/library",
                                            },
                                            checkThirdParty = false,
                                        },
                                        diagnostics = { globals = { 'vim' } },
                                        runtime = { version = 'LuaJIT' },
                                        telemetry = { enable = false },
                                    },
                                },
                            })
                        end,

                        -- default setup for LSPs
                        function(server_name)
                            require("lspconfig")[server_name].setup({})
                        end,
                    },
                })
            end,
        },
        -- :checkhealth vim.lsp
    }
end

return M
