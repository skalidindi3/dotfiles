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

-- plugin config
require("plugins.commands")
require("plugins.macros")




-- " TODOs: {{{
-- https://dotfyle.com/neovim/plugins/trending
--
-- treesitter compatible colorschemes
-- https://github.com/nvim-treesitter/nvim-treesitter/wiki/Colorschemes
--
-- block commenting
--
-- fuzzy find for commands
-- - FeiyouG/commander.nvim
-- - mrjones2014/legendary.nvim
--
-- folke/which-key.nvim
-- - "*" search word under cursor / or visual block
-- - g as the global command
--   - https://www.youtube.com/watch?v=1M-XDGc20ns
-- - :verbose nmap <leader>G
--   - shows mapping and where it comes from (in this case, for <leader>G)
-- - :Fidget history
--   - shows notification history
-- - :messages
--   - shows command output history (like startup errors)
-- - VimodeDisable for fading windows?
-- " http://tnerual.eriogerg.free.fr/vimqrc.html
-- " Reminders {
--     " <C-w>r            - swap panes
--     " viw               - visual select inner word
--     " A                 - start typing at end of line
--     " O                 - start new line above cursor
--     " :echo has("lua")  - check for depenedency
--     " "*p               - paste from system clipboard
--     " e                 - end of word
--     " ge                - end of previous word
--     " f                 - prefix for "find next"
--     " t                 - prefix for "till next"
--     " zz                - center screen on line
-- " }
--
-- " strip whitespace fn
-- https://www.reddit.com/r/neovim/comments/1c0bemk/using_ripgrep_as_grepprg_to_search_in_the_current/
--
-- different colorscheme for diffs?
-- " }}}
