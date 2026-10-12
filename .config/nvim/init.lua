-- neovim top-level config --

-- general config
require("core.options")
require("core.util")
require("core.remaps")
require("core.macros")
require("core.commands")

-- cache default setup info
_G.core_colorschemes = vim.fn.getcompletion("", "color")

-- set up plugins
require("plugins.bootstrap")
local plugin_lists = {
    require("plugins.colorschemes"),
    require("plugins.statusline"),
    require("plugins.notifications"),
    require("plugins.ai"),
}
-- cache plugin list before setup
_G.all_plugins = vim.iter(plugin_lists):flatten():totable()
require("lazy").setup({ _G.all_plugins })
-- TODO: goolord/alpha-nvim start logo
