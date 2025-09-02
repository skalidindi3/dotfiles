-- AI coding assistance --

function SetupFidgetNotifications()
    local progress = require("fidget.progress")
    local handles = {}

    local group = vim.api.nvim_create_augroup("CodeCompanionFidget", {})

    vim.api.nvim_create_autocmd("User", {
        pattern = "CodeCompanionRequestStarted",
        group = group,
        callback = function(e)
            handles[e.data.id] = progress.handle.create({
                title = "CodeCompanion",
                message = "Thinking...",
                lsp_client = { name = e.data.adapter.formatted_name },
            })
        end,
    })

    vim.api.nvim_create_autocmd("User", {
        pattern = "CodeCompanionRequestFinished",
        group = group,
        callback = function(e)
            local handle = handles[e.data.id]
            if handle then
                -- TODO: distinguish notify errors
                handle.message = e.data.status == "success" and "Done" or "Failed"
                handle:finish()
                handles[e.data.id] = nil
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
        },
        config = function()
            SetupFidgetNotifications()

            local cc_adapters = require("codecompanion.adapters")
            require("codecompanion").setup({
                opts = { log_level = "DEBUG" },
                strategies = {
                    chat = { adapter = "ollama" },
                    inline = { adapter = "ollama" },
                    agent = { adapter = "ollama" },
                },
                adapters = {
                    http = {
                        ollama = function()
                            return cc_adapters.extend("ollama", {
                                env = { url = "https://ollama.int.saiaiai.com" },
                                parameters = { sync = true },
                            })
                        end,
                        gemini = function()
                            return cc_adapters.extend("gemini", {
                                env = { api_key = vim.fn.getenv("GEMINI_API_KEY") },
                                schema = {
                                    model = { default = "gemini-2.5-flash" },
                                },
                            })
                        end,
                    },
                    acp = {
                        gemini_cli = function()
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
                        end,
                    },
                },
            })
        end,
    },
}
