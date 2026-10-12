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

}
