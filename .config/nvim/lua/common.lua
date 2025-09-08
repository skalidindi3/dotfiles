-- global functions for usage in lua --

-- NOTE: from vim lua command line, use print(vim.inspect(object))

vim.api.nvim_create_user_command("DumpIntoBuffer", function(opts)
    local result = load("return " .. opts.args)()
    -- NOTE: can't format with conform/treesitter in an anonymous buffer
    local note = "-- NOTE: save to temp lua file to format with conform"
    local lines = vim.split(note .. "local dump = " .. vim.inspect(result), "\n")
    vim.api.nvim_buf_set_lines(0, -1, -1, false, lines)
    vim.cmd([[%s/\(<function \d>\)/"\1"/g]]) -- wrap fns as strings
end, { nargs = 1 })

-- helper for remapping the default keymap
function keyset(mode, lhs, rhs, opts)
    local options = { noremap = true, silent = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.keymap.set(mode, lhs, rhs, options)
end

function flatten2d(list2d)
    local flattened = {}
    for _, list1d in ipairs(list2d) do
        vim.list_extend(flattened, list1d)
    end
    return flattened
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
-- Registers:
-- - " unnamed register
-- - * system clipboard
-- - + system clipboard (X11)
-- - / last search pattern
-- - . last inserted test
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
