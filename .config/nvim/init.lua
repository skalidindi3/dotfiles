-- vim:foldenable:foldmethod=marker:foldlevel=0
-- neovim top-level config --

require("common")

-- general config
require("core.options")
require("core.remaps")
require("core.macros")

-- cache default setup info
_G.core_colorschemes = vim.fn.getcompletion("", "color")

-- set up plugins
require("plugins.bootstrap")
local plugin_lists = {
    require("plugins.colorschemes"),
    require("plugins.statusline"),
    require("plugins.multicursor"),
    require("plugins.semantics"),
    require("plugins.visual-cues"),
    require("plugins.rendering"),
    require("plugins.notifications"),
    require("plugins.filebrowser"),
    require("plugins.ide"),
}
local all_plugins = flatten2d(plugin_lists)
require("lazy").setup({ all_plugins })
-- TODO: goolord/alpha-nvim start logo

-- plugin config
require("plugins.commands")
require("plugins.macros")
