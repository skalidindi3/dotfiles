-- global functions for usage in lua --

-- NOTE: from vim lua command line, use print(vim.inspect(object))

-- helper for remapping the default keymap
function keyset(mode, lhs, rhs, opts)
    local options = { noremap = true, silent = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.keymap.set(mode, lhs, rhs, options)
end

function ListDifference(B, A)
    -- convert A to a set
    local A_set = {}
    for _, value in ipairs(A) do
        A_set[value] = true
    end
    -- conditionally create B - A
    local BmA = {}
    for _, value in ipairs(B) do
        if not A_set[value] then
            table.insert(BmA, value)
        end
    end
    return BmA
end

-- TODO: curated cheatsheet
-- - "*" search word under cursor / or visual block
-- - "#" search word under cursor / or visual block (backwords)
-- - g* / g# to include partial matches
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
--     " V                 - visual select LINES
--     " viw               - visual select inner word
--     " diW               - delete inside until whitespace
--     " vap               - select around paragraph (function)
--     " vip               - select inside paragraph (any contiguous text?)
--     " A                 - start typing at end of line
--     " O                 - start new line above cursor
--     " :echo has("lua")  - check for depenedency
--     " "*p               - paste from system clipboard
--     " e                 - end of word
--     " E                 - end of word (whitespace)
--     " ge                - end of previous word
--     " f                 - prefix for "find next"
--     " t                 - prefix for "till next"
--     " zz                - center screen on line
--     " 10o0.             - make 10 lines starting with "0."
--     " g<C-a>            - (for selection) increment proportionally
--     " <C-j>             - (insert mode) newline
--     " <C-w>             - (insert mode) delete previous word
--     " <C-o>             - (insert mode) switch to normal mode for a single command
--     " m<alphanum>       - mark line (jump with telescope), lowercase local to buffer, uppercase global
--     " '<alphanum>       - jump to mark (special marks exist, like w/ special registers)
--     " :w !<shell cmd>   - (normal or visual) pipe to shell comamand
--     " gv                - reselect last selection
--     " =                 - re-indent (works with visual, # lines, etc)
--     " %                 - toggle between nearest pairs (braces, blocks, etc)
--     " gx                - open URL under cursor
--     " gf                - open file under cursor (as a buffer)
-- " }
-- b/B as (/{ brace shortcuts for textobjects
-- in visual block mode, can still do $/L to get to end, and then A for appending to those lines
-- mksession exists
-- :g/:v commands: https://www.youtube.com/watch?v=PDYpP22wAow
-- Registers:
-- - " unnamed register
-- - * system clipboard
-- - + system clipboard (X11)
-- - / last search pattern
-- - . last inserted test
-- - ac, ic, aC text objects from plugin
-- TODO: tips
-- - :Inspect / :InspectTree
-- - :LspInfo ( = :checkhealth vim.lsp ) / :LspLog
-- - ,v treesitter select & gc for comment block
-- - visual select & s/search/replace/g inside selection
--   - useful for unmatched tabsize
-- - (normal) <C-w>d opens a floating window showing the diagnostics in the line under the cursor
-- - (normal) [d and ]d can be used to move the cursor to the previous and next diagnostic of the current file
-- - trouble.nvim
--   - bassamsdata/namu.nvim ? might be redundant
-- - https://vonheikemen.github.io/devlog/tools/neovim-lsp-client-guide/
--   - extended LSP usage and key mappings
-- - rmagatti/goto-preview
-- - use Telecope help to find help docstrings
--   - vim internal flatten --> now deprecated for iter.flatten
-- - :TodoTelescope keywords=TODO,FIX cwd=.config
-- - normal mode :.lua to execute current line in lua
-- - visual mode :lua to execute selection with lua interpreter
