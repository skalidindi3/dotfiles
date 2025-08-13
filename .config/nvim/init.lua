-- vim:foldenable:foldmethod=marker:foldlevel=0
-- TODO: align comments
-- TODO: lint
-- TODO: lint single/double quotes
-- TODO: vim --> minimal
-- TODO: nvim --> IDE --> if os.getenv("NVIM_IDE") then \n require \n end

-- TODO: delete? vim.opt.lazyredraw = true
vim.opt.lazyredraw = false
vim.opt.number = true
vim.opt.showmode = false   -- mode in statusline instead
vim.opt.ruler = true       -- show cursor coordinates
vim.opt.showcmd = true     -- in visual mode, show selection stats
vim.opt.wildmenu = true    -- show autocomplete menu for commands

vim.opt.backspace = 'eol,start,indent'
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.g.mapleader = ','
vim.g.maplocalleader = "\\"

vim.opt.hlsearch = true        -- highlight searches
vim.opt.incsearch = true       -- realtime show next match
vim.opt.wrapscan = true        -- wrap around
vim.opt.inccommand = 'split'   -- live preview substitutions

kTabSize = 4
vim.opt.expandtab = true       -- convert <TAB> to spaces
vim.opt.tabstop = kTabSize     -- size of <TAB> and expanded spaces
vim.opt.shiftwidth = kTabSize  -- size of shifts in visual mode
vim.opt.softtabstop = kTabSize -- align backspace to <TAB>
vim.opt.autoindent = true      -- copy indentation from previous line
vim.opt.breakindent = true     -- display wrapped line with same indent

vim.opt.foldmethod = 'indent'  -- automatically fold by indent level
vim.opt.foldenable = false     -- but don't fold by default
vim.opt.foldminlines = 0       -- fold single-line nests too
vim.opt.foldlevel = 99         -- start with all folds open

-- vim.opt.statuscolumn = [[%{(foldlevel(v:lnum) && foldlevel(v:lnum) > foldlevel(v:lnum - 1)) ? (foldclosed(v:lnum) == -1 ? '⌄' : '›') : ' '}]] -- Folds
--     .. ' ' -- Spacer
--     .. '%=%{v:virtnum < 1 ? (v:relnum ? v:relnum : v:lnum) : " "}' -- Line number
--     .. '%s' -- Sign
--     .. '%{&signcolumn == "no" ? " " : ""}' -- Extra space if sign column is not enabled
-- -- TODO: revisit the statusline
-- vim.opt.laststatus = 2     -- always show statusline
-- vim.opt.statusline = table.concat({
--   '%f - %y',               -- filename - [filetype]
--   '%m',                    -- file modified flag
--   '%=',                    -- text-align right remainder
--   '[%c : %l/%L (%p%%)]',   -- [col : line/Total (pct)]
-- }, ' ')

vim.opt.list = true        -- enable list mode to show special characters
vim.opt.listchars = {
  trail = '•',
  tab = '»»',
}

-- highlight cursor line only for active pane
vim.api.nvim_create_augroup("CursorLineOnlyInActiveWindow", { clear = true })
vim.api.nvim_create_autocmd({ "VimEnter", "WinEnter", "BufWinEnter" }, {
  group = "CursorLineOnlyInActiveWindow",
  callback = function() vim.opt_local.cursorline = true end,
})
vim.api.nvim_create_autocmd({ "WinLeave" }, {
  group = "CursorLineOnlyInActiveWindow",
  callback = function() vim.opt_local.cursorline = false end,
})

require("remaps")
require("macros")
require("plugins")
