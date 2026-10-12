-- IDE style features --

return {
    -- incremental parser
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        dependencies = {
            "OXY2DEV/markview.nvim",
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
                "bash", "diff",
                "json", "jq",
                "yaml", "dockerfile", "caddy",
                "html", "css", "javascript", "sql",
                -- Query-only dependencies inherited by HTML and JavaScript.
                "html_tags", "ecma", "jsx",
                -- Previously auto-installed; keep them across the migration.
                "gitcommit", "make", "ssh_config", "t32", "toml",
                -- "tmux": currently unsupported upstream.
                -- "udev", "ini", "csv", "tsv",
                -- "cmake", "cuda", "arduino",
                -- "vim", "vimdoc", "help" :: vim specific
            }

            -- Keep parsers and their matching queries outside the plugin checkout.
            -- Prepending this path also keeps stale legacy parsers from shadowing them.
            treesitter.setup({
                install_dir = vim.fn.stdpath("data") .. "/site",
            })

            -- Upstream ships its parser catalog; no external registry is needed.
            local available = {}
            for _, language in ipairs(treesitter.get_available()) do
                available[language] = true
            end

            local installing = {}
            local function buffer_language(buf)
                local filetype = vim.bo[buf].filetype
                return vim.treesitter.language.get_lang(filetype) or filetype
            end

            local function attach(buf, language)
                if not vim.api.nvim_buf_is_loaded(buf) or buffer_language(buf) ~= language then
                    return
                end
                if not vim.treesitter.language.add(language) then
                    return
                end

                vim.treesitter.start(buf, language)

                local has_indent, indent_query = pcall(vim.treesitter.query.get, language, "indents")
                if has_indent and indent_query then
                    vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                end
            end

            local function install(langs)
                for _, language in ipairs(langs) do
                    installing[language] = true
                end
                -- Install asynchronously, then attach every waiting buffer. This
                -- also handles the first FileType event racing the initial install.
                treesitter.install(langs):await(function(err)
                    vim.schedule(function()
                        for _, language in ipairs(langs) do
                            installing[language] = nil
                        end
                        if err then
                            vim.notify(tostring(err), vim.log.levels.ERROR)
                            return
                        end
                        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                            if vim.api.nvim_buf_is_loaded(buf) then
                                local language = buffer_language(buf)
                                if vim.list_contains(langs, language) then
                                    attach(buf, language)
                                end
                            end
                        end
                    end)
                end)
            end

            vim.api.nvim_create_autocmd("FileType", {
                group = vim.api.nvim_create_augroup("user_treesitter", { clear = true }),
                callback = function(args)
                    local language = buffer_language(args.buf)

                    if vim.treesitter.language.add(language) then
                        attach(args.buf, language)
                    elseif available[language] and not installing[language] then
                        install({ language })
                    end
                end,
            })

            -- A no-op for installed parsers; retain the explicit language list.
            install(languages)
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
