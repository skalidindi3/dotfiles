-- IDE style features --

return {
    -- incremental parser
    {
        "nvim-treesitter/nvim-treesitter",
        dependencies = { "OXY2DEV/markview.nvim" },
        lazy = false,
        branch = "master",  -- "main" documentation lacking
        build = ":TSUpdate",
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

    -- inspired by hendrikmi/neovim-kickstart-config
    -- NOTE: the above has info for using hrsh7th/cmp-nvim-lsp
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            -- auto install LSPs to stdpath for nvim
            -- NOTE: must be loaded before dependants
            { "mason-org/mason.nvim", config = true },
            -- auto install tools (linters, formatters, etc) to stdpath for nvim
            "WhoIsSethDaniel/mason-tool-installer.nvim",
            -- translate lsp names to package names
            -- NOTE: skipping config to use vim.lsp.config/vim.lsp.enable explicitly
            "mason-org/mason-lspconfig.nvim",
        },
        config = function()
            -- NOTE: can also override start command and filetypes
            local servers = {
                lua_ls = {
                    settings = {
                        Lua = {
                            runtime = { version = "LuaJIT" },
                            diagnostics = { globals = { "vim" } },
                            workspace = {
                                checkThirdParty = false,
                                library = vim.api.nvim_get_runtime_file("", true),
                            },
                            telemetry = { enable = false },
                        },
                    },
                },
                ty = {},
            }

            local extra_tools = {
                "stylua",
                "ruff",
            }

            local ensure_installed = vim.tbl_keys(servers or {})
            vim.list_extend(ensure_installed, extra_tools)
            require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

            for server, cfg in pairs(servers) do
                  vim.lsp.config(server, cfg)
                  vim.lsp.enable(server)
            end

            -- TODO: move elsewhere
            -- TODO: iterate with https://github.com/rachartier/tiny-inline-diagnostic.nvim
            -- https://gpanders.com/blog/whats-new-in-neovim-0-11/#virtual-text-handler-changed-from-opt-out-to-opt-in
            -- https://www.reddit.com/r/neovim/comments/1jo9oe9/i_set_up_my_config_to_use_virtual_lines_for/
            -- https://www.youtube.com/watch?v=bTWWFQZqzyI
            vim.diagnostic.config({
                virtual_lines = false, --not vim.diagnostic.config().virtual_lines,
                virtual_text = true, --not vim.diagnostic.config().virtual_text,
                signs = {
                    text = {
                        [vim.diagnostic.severity.ERROR] = '✘',
                        [vim.diagnostic.severity.WARN] = '',
                        [vim.diagnostic.severity.HINT] = '⚑',
                        [vim.diagnostic.severity.INFO] = '',
                    },
                },
            })
            require("common")
            keyset('n', '<leader>d', function()
                vim.diagnostic.config {
                   virtual_lines = not vim.diagnostic.config().virtual_lines,
                   virtual_text = not vim.diagnostic.config().virtual_text,
                }
            end, { desc = "Edit configuration" })
        end,
    },
    -- :LspInfo ( = :checkhealth vim.lsp )
    -- :LspLog

    {
        "stevearc/conform.nvim",
        opts = {
            notify_on_error = true,
            format_on_save = false,
            formatters_by_ft = {
                lua = { "stylua" },
                python = {
                    "ruff_fix", -- autofix lint errors
                    "ruff_format",
                    "ruff_organize_imports",
                },
            },
            formatters = {
                stylua = {
                    append_args = {
                        "--indent-type",
                        "Spaces",
                        "--indent-width",
                        "4",
                        "--quote-style",
                        "AutoPreferDouble"
                    },
                },
            },
        },
    },
}
