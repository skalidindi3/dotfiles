-- file tree navigation --

return {
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
        },
        lazy = false,
        config = function()
            local window_mappings = {
                -- basic
                ["?"] = "show_help",
                ["q"] = "close_window",

                -- filesystem interaction
                ["r"] = "refresh",
                ["i"] = "show_file_details",

                -- folding
                ["-"] = "close_node",
                ["="] = "toggle_node",
                ["_"] = "close_all_nodes",
                ["+"] = "expand_all_nodes",
                ["M"] = "close_all_nodes",
                ["R"] = "expand_all_nodes",

                -- access
                ["<cr>"] = "open",
                ["s"] = "open_split",
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
                    },
                },

                -- rotate through sources
                ["<leader>p"] = "prev_source",
                ["<leader>n"] = "next_source",
                ["<"] = "prev_source",
                [">"] = "next_source",
            }
            local fs_window_mappings = {
                -- filesystem interaction
                ["H"] = "toggle_hidden",
                ["<bs>"] = "navigate_up",
                ["."] = "set_root",
            }
            local buffers_window_mappings = {
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

            require("neo-tree").setup({
                event_handlers = {
                    {
                        -- keep focus on tree window when opening panes & tabs
                        event = "file_opened",
                        handler = function(_)
                            -- reopen the tree and focus back on it
                            require("neo-tree.command").execute({ action = "focus", source = "filesystem" })
                        end,
                    },
                },
            })
        end,
    },
}
