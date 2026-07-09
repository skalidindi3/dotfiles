-- IDE style features --

return {
    -- incremental parser
    {
        "neovim-treesitter/nvim-treesitter",
        name = "nvim-treesitter",
        dependencies = {
            "OXY2DEV/markview.nvim",
            "neovim-treesitter/treesitter-parser-registry",
        },
        lazy = false,
        build = ":TSUpdate",
        config = function()
            local treesitter = require("nvim-treesitter")
            local languages = {
                "lua",
                "c", "cpp", "asm", "disassembly", "objdump",
                "python",
                "markdown", "markdown_inline",
                "bash", "diff", "tmux",
                "json", "jq",
                "yaml", "dockerfile", "caddy",
                "html", "css", "javascript", "sql",
                -- Query-only dependencies inherited by HTML and JavaScript.
                "html_tags", "ecma", "jsx",
                -- Previously auto-installed; keep them across the migration.
                "gitcommit", "make", "ssh_config", "t32", "toml",
                -- "udev", "ini", "csv", "tsv",
                -- "cmake", "cuda", "arduino",
                -- "vim", "vimdoc", "help" :: vim specific
            }

            -- Keep parsers and their matching queries outside the plugin checkout.
            -- Prepending this path also keeps stale legacy parsers from shadowing them.
            treesitter.setup({
                install_dir = vim.fn.stdpath("data") .. "/site",
            })

            -- This is asynchronous and a no-op for parsers that are already installed.
            treesitter.install(languages)

            -- Registry loading schedules its callback; do not assume get_available()
            -- is populated during startup.
            local available = {}
            require("treesitter-registry").load(function(entries, err)
                if entries then
                    available = entries
                elseif err then
                    vim.notify(err, vim.log.levels.WARN)
                end
            end)

            local installing = {}
            local function attach(buf, language)
                if not vim.api.nvim_buf_is_valid(buf) then
                    return
                end
                if not vim.treesitter.language.add(language) then
                    return
                end

                local ok = pcall(vim.treesitter.start, buf, language)
                if not ok then
                    return
                end

                local has_indent, indent_query = pcall(vim.treesitter.query.get, language, "indents")
                if has_indent and indent_query then
                    vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                end
            end

            vim.api.nvim_create_autocmd("FileType", {
                group = vim.api.nvim_create_augroup("user_treesitter", { clear = true }),
                callback = function(args)
                    local filetype = vim.bo[args.buf].filetype
                    local language = vim.treesitter.language.get_lang(filetype) or filetype

                    if vim.treesitter.language.add(language) then
                        attach(args.buf, language)
                    elseif available[language] and not installing[language] then
                        installing[language] = true
                        treesitter.install({ language }, { summary = true }):await(function(err, ok)
                            installing[language] = nil
                            if err or not ok then
                                return
                            end
                            vim.schedule(function()
                                attach(args.buf, language)
                            end)
                        end)
                    end
                end,
            })
        end,
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
            -- TODO: move into plugins.macros
            -- https://blog.pabuisson.com/2022/08/neovim-modern-features-treesitter-and-lsp/
        end,
    },

    -- linting & formatting
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
                        "AutoPreferDouble",
                    },
                },
            },
        },
    },


    -- TAB completion
    {
        "saghen/blink.cmp",
        lazy = false,
        version = "*",
        opts = {
            keymap = {
                preset = "none",
                ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
                ["<CR>"] = { "select_and_accept", "fallback" },
                ["<Tab>"] = { "select_next", "fallback" },
                ["<Down>"] = { "select_next", "fallback" },
                ["<S-Tab>"] = { "select_prev", "fallback" },
                ["<Up>"] = { "select_prev", "fallback" },
                ["<Esc>"] = { "hide", "fallback" },
            },
            cmdline = {
                keymap = {
                    preset = "inherit",
                    ["<Tab>"] = { "show_and_insert_or_accept_single", "select_next", "fallback" },
                    ["<Right>"] = { "accept", "fallback" },
                    ["<Esc>"] = {
                        function(cmp)
                            if cmp.is_menu_visible() then
                                cmp.cancel()
                            else
                                vim.api.nvim_input("<C-c>")
                            end
                        end,
                    },
                },
            },
            sources = {
                default = { "lsp", "path", "buffer" },
            },
        },
    },
}
