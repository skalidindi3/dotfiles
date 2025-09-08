-- AI coding assistance --

function SetupFidgetNotifications()
    local progress = require("fidget.progress")
    local handles = {}

    local group = vim.api.nvim_create_augroup("CodeCompanionFidget", {})

    vim.api.nvim_create_autocmd("User", {
        pattern = "CodeCompanionRequestStarted",
        group = group,
        callback = function(request)
            handles[request.data.id] = progress.handle.create({
                title = "CodeCompanion",
                message = " Sending...",
                lsp_client = { name = request.data.adapter.formatted_name },
            })
        end,
    })

    vim.api.nvim_create_autocmd("User", {
        pattern = "CodeCompanionRequestFinished",
        group = group,
        callback = function(request)
            local handle = handles[request.data.id]
            if handle then
                if request.data.status == "success" then
                    handle.message = " Completed"
                elseif request.data.status == "error" then
                    handle.message = " Error"
                else
                    handle.message = "󰜺 Cancelled"
                end
                handle:finish()
                handles[request.data.id] = nil
            end
        end,
    })
end

return {
    {
        "olimorris/codecompanion.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            "j-hui/fidget.nvim",
            "nvim-telescope/telescope.nvim",
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
                        ["<S-Tab>"] = { "select_prev", "fallback" },
                        ["<Esc>"] = { "hide", "fallback" },
                    },
                    cmdline = {
                        keymap = {
                            preset = "none",
                            ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
                            ["<Tab>"] = { "show", "select_next", "fallback" },
                            ["<S-Tab>"] = { "select_prev", "fallback" },
                            ["<Down>"] = { "select_next", "fallback" },
                            ["<Up>"] = { "select_prev", "fallback" },
                            ["<CR>"] = { "accept_and_enter", "fallback" },
                            ["<Esc>"] = { "hide", "fallback" },
                        },
                    },
                    sources = {
                        default = { "lsp", "path", "buffer", "codecompanion" },
                    },
                },
            },
        },
        config = function()
            SetupFidgetNotifications()

            table.insert(_G.user_doc_mappings, {
                mode = "i",
                noremap = 1,
                buffer = 0,
                lhs = "<C-Space>",
                desc = "[Blink]: show completion menu, show/hide documentation",
            })

            local cc_adapters = require("codecompanion.adapters")
            local ollama_setup = function()
                return cc_adapters.extend("ollama", {
                    env = { url = "https://ollama.int.saiaiai.com" },
                    parameters = { sync = true },
                })
            end
            local gemini_setup = function()
                return cc_adapters.extend("gemini", {
                    env = { api_key = vim.fn.getenv("GEMINI_API_KEY") },
                    schema = {
                        model = { default = "gemini-2.5-flash" },
                    },
                })
            end
            local gemini_pro_setup = function()
                return cc_adapters.extend("gemini", {
                    env = { api_key = vim.fn.getenv("GEMINI_API_KEY") },
                    schema = {
                        model = { default = "gemini-2.5-pro" },
                    },
                })
            end
            local gemini_cli_setup = function()
                return cc_adapters.extend("gemini_cli", {
                    env = { api_key = vim.fn.getenv("GEMINI_API_KEY") },
                    defaults = { auth_method = "gemini-api-key" },
                    commands = {
                        default = {
                            "gemini",
                            "--experimental-acp",
                            "-m",
                            "gemini-2.5-flash",
                        },
                    },
                })
            end
            local gemini_pro_cli_setup = function()
                return cc_adapters.extend("gemini_cli", {
                    env = { api_key = vim.fn.getenv("GEMINI_API_KEY") },
                    defaults = { auth_method = "gemini-api-key" },
                    commands = {
                        default = {
                            "gemini",
                            "--experimental-acp",
                            "-m",
                            "gemini-2.5-pro",
                        },
                    },
                })
            end

            require("codecompanion").setup({
                opts = { log_level = "DEBUG" },
                strategies = {
                    chat = { adapter = "ollama" },
                    inline = { adapter = "ollama" },
                    agent = { adapter = "ollama" },
                },
                adapters = {
                    http = {
                        opts = { show_defaults = false },
                        ollama = ollama_setup,
                        gemini = gemini_setup,
                        gemini_pro = gemini_pro_setup,
                    },
                    acp = {
                        opts = { show_defaults = false },
                        gemini_cli = gemini_cli_setup,
                        gemini_pro_cli = gemini_pro_cli_setup,
                    },
                },
            })
        end,
    },
}
