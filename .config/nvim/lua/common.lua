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

function GetCurrentKeyMappings()
    -- NOTE: ignored modes: "c", "i", "x", "s", "!", "t"
    local modes = { "n", "v", "o" }

    -- create mappings list
    local all_mappings = {}
    for _, mode in ipairs(modes) do
        local mode_maps = vim.api.nvim_get_keymap(mode)
        for _, mode_map in ipairs(mode_maps) do
            local desc = mode_map["desc"] or ""
            local cmd = mode_map["rhs"] or ""
            local skip_condition = string.find(mode_map["lhs"], "<Plug>")
                or string.find(desc, "^:")
                or string.find(desc, "^ :")
                or string.find(cmd, "<Plug>")
            if mode_map["lhs"] == " " then
                mode_map["lhs"] = "<space>"
            end
            if mode_map["rhs"] == "" then
                mode_map["rhs"] = "<nop>"
            end
            if not skip_condition then
                all_mappings[#all_mappings + 1] = {
                    desc = desc,
                    keys = mode_map["lhs"],
                    mode = mode_map["mode"],
                    cmd = mode_map["rhs"] or mode_map["callback"],
                    --debug = mode_map,
                }
            end
        end
    end

    -- sort mappings list
    table.sort(all_mappings, function(a, b)
        if a.desc ~= b.desc then
            return a.desc < b.desc
        elseif a.keys ~= b.keys then
            return a.keys < b.keys
        else
            -- order mode just so merging looks nicer
            return a.mode < b.mode
        end
    end)

    -- merge mappings separated only by mode
    local merged_mappings = {}
    for _, mapping in ipairs(all_mappings) do
        local prev = merged_mappings[#merged_mappings]
        if prev and prev.keys == mapping.keys and prev.desc == mapping.desc then
            prev.mode = prev.mode .. "/" .. mapping.mode
        else
            table.insert(merged_mappings, mapping)
        end
    end

    return merged_mappings
end

function Cheatsheet()
    -- alts: mrjones2014/legendary.nvim , FeiyouG/commander.nvim
    local Popup = require("nui.popup")
    local event = require("nui.utils.autocmd").event
    local Table = require("nui.table")

    -- create & mount the popup window
    local popup = Popup({
        enter = true,
        focusable = true,
        border = {
            style = "rounded",
            text = {
                top = "nvim cheatsheet",
                top_align = "center",
            },
        },
        position = "50%",
        size = { width = "80%", height = "80%" },
        buf_options = { modifiable = false, readonly = true },
    })
    popup:mount()

    -- create & render the table
    local table = Table({
        bufnr = popup.bufnr,
        columns = {
            {
                align = "center",
                header = "Name",
                columns = {
                    { accessor_key = "desc", header = "Description" },
                    { accessor_key = "mode", header = "Mode" },
                    { accessor_key = "keys", header = "Key Mapping" },
                    { accessor_key = "cmd", header = "Command" },
                },
            },
        },
        data = GetCurrentKeyMappings(),
    })
    table:render()

    -- close on <q> press or by leaving the buffer
    popup:map("n", "q", function()
        popup:unmount()
    end, { noremap = true })
    popup:on(event.BufLeave, function()
        popup:unmount()
    end)
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
