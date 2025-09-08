-- neovim top-level config --

require("common")

-- general config
require("core.options")
require("core.remaps")
require("core.macros")

-- cache default setup info
_G.core_colorschemes = vim.fn.getcompletion("", "color")
_G.user_doc_mappings = {}

-- set up plugins
require("plugins.bootstrap")
local plugin_lists = {
    require("plugins.colorschemes"),
    require("plugins.statusline"),
    require("plugins.selection"),
    require("plugins.semantics"),
    require("plugins.rendering"),
    require("plugins.notifications"),
    require("plugins.filetree"),
    require("plugins.ide"),
    require("plugins.ai"),
}
-- cache plugin list before setup
_G.all_plugins = vim.iter(plugin_lists):flatten():totable()
require("lazy").setup({ _G.all_plugins })
-- TODO: goolord/alpha-nvim start logo

-- plugin config
require("plugins.commands")
require("plugins.macros")
