-- IDE style features --

return {
    -- incremental parser
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
