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
            {
                "saghen/blink.cmp",
                lazy = false,
                version = "*",
                opts = {
                    keymap = {
                        preset = "enter",
                        ["<S-Tab>"] = { "select_prev", "fallback" },
                        ["<Tab>"] = { "select_next", "fallback" },
                    },
                    cmdline = { sources = { "cmdline" } },
                    sources = {
                        default = { "lsp", "path", "buffer", "codecompanion" },
                    },
                },
            },
        },
        config = function()
            SetupFidgetNotifications()

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

            require("codecompanion").setup({
                opts = { log_level = "DEBUG" },
                strategies = {
                    chat = { adapter = "ollama" },
                    inline = { adapter = "ollama" },
                    agent = { adapter = "ollama" },
                },
                adapters = {
                    http = {
                        ollama = ollama_setup,
                        gemini = gemini_setup,
                    },
                    acp = {
                        gemini_cli = gemini_cli_setup,
                    },
                },
            })
        end,
    },
}
