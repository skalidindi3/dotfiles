-- plugins managed by folke/lazy.nvim

-- get lazy.nvim if not present
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({
        "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath
    })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-- function to setup lazy.nvim
function install_plugins()
    plugins_list = require("plugins-default").get_plugins()

    -- selectively install extra plugins
    if os.getenv("NVIM_IDE") then
        plugins_extra = require("plugins-extra-ide")
    else
        plugins_extra = require("plugins-extra-minimal")
    end

    -- merge plugin lists
    for _, item in ipairs(plugins_extra.get_plugins()) do
        table.insert(plugins_list, item)
    end

    require("lazy").setup(plugins_list)
    -- NOTE: can do post-setup procedures here as needed
end

-- actually install the plugins
install_plugins()


-- TODO: nvim as MANPAGER
-- TODO: extra plugins
-- https://dotfyle.com/neovim/plugins/trending
--
--
-- https://blog.pabuisson.com/2022/08/neovim-modern-features-treesitter-and-lsp/
-- - https://www.youtube.com/watch?v=w7i4amO_zaE
--   - treesitter playground
-- - https://medium.com/@jacksmithxyz/setting-up-neovim-tree-sitter-and-built-in-lsp-86a853d70590
-- - https://www.youtube.com/watch?v=x__SZUuLOxw
--
-- sindrets/diffview.nvim
-- - https://github.com/sindrets/diffview.nvim/issues/546
-- - https://www.reddit.com/r/neovim/comments/n2vww8/diffviewnvim_cycle_through_diffs_for_all_modified/
--
-- dstein64/vim-startuptime
-- - https://lazy.folke.io/spec/examples
--
-- fei6409/log-highlight.nvim
-- folke/snacks.nvim/blob/main/docs/indent.md
-- folke/which-key.nvim
-- - "*" search word under cursor / or visual block
-- - g as the global command
--   - https://www.youtube.com/watch?v=1M-XDGc20ns
-- - VimodeDisable for fading windows?
-- folke/flash.nvim
-- folke/twilight.nvim
-- b0o/incline.nvim
-- OXY2DEV/markview.nvim




-- mg979/vim-visual-multi
-- - https://www.youtube.com/watch?v=LhcnGU-COpo
-- - lazy = false
