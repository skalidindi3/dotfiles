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

}
