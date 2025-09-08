-- custom picker for key mappings with opinionated sorting --

local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local sorters = require("telescope.sorters")
local utils = require("telescope.utils")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local action_utils = require("telescope.actions.utils")
local make_entry = require("telescope.make_entry")
local entry_display = require("telescope.pickers.entry_display")

local function format_desc(mapping)
    if mapping.callback and not mapping.desc then
        return action_utils._get_anon_function_name(debug.getinfo(mapping.callback))
    else
        local rhs = mapping.rhs == "" and "<nop>" or mapping.rhs
        return (mapping.desc or rhs):gsub("\n", "\\n"):gsub("^ +", "")
    end
end

local function format_lhs(mapping)
    local lhs = mapping.lhs == " " and "<Space>" or mapping.lhs
    return utils.display_termcodes(lhs)
end

function GetAllCurrentMappings(sort_table)
    -- NOTE: ignored modes: "c", "i", "x", "s", "!", "t"
    local modes = { "n", "v", "o" }

    local mode_mappings_list = {}
    for _, mode in ipairs(modes) do
        mode_mappings_list[#mode_mappings_list + 1] = vim.api.nvim_get_keymap(mode)
        mode_mappings_list[#mode_mappings_list + 1] = vim.api.nvim_buf_get_keymap(0, mode)
    end
    if _G.user_doc_mappings ~= nil then
        mode_mappings_list[#mode_mappings_list + 1] = _G.user_doc_mappings
    end

    local all_mappings = {}
    local mode_mappings = vim.iter(mode_mappings_list):flatten():totable()
    for _, mapping in ipairs(mode_mappings) do
        -- patch specific fields
        mapping.desc = format_desc(mapping)
        mapping["lhs_fmt"] = format_lhs(mapping)

        -- skip plugin inputs
        if not string.find(mapping.lhs_fmt, "<Plug>") then
            all_mappings[#all_mappings + 1] = mapping
        end
    end

    if sort_table then
        table.sort(all_mappings, function(a, b)
            -- prioritize buffer-local keymaps
            if a.buffer ~= b.buffer then
                return b.buffer < a.buffer
            end

            -- then prioritize explicitly tagged keymaps
            local a_tagged = string.match(a.desc, "^%[.-%]:") ~= nil
            local b_tagged = string.match(b.desc, "^%[.-%]:") ~= nil
            if a_tagged ~= b_tagged then
                return a_tagged
            end

            -- then prioritize vim api keymaps
            local a_vim = string.match(a.desc, "^vim") ~= nil
            local b_vim = string.match(b.desc, "^vim") ~= nil
            if a_vim ~= b_vim then
                return a_vim
            end

            -- then deprioritize remaps
            local a_remap = string.match(a.desc, "remap:") ~= nil
            local b_remap = string.match(b.desc, "remap:") ~= nil
            if a_remap ~= b_remap then
                return b_remap
            end

            -- then deprioritize nops
            local a_nop = string.match(a.desc, "<nop>") ~= nil
            local b_nop = string.match(b.desc, "<nop>") ~= nil
            if a_nop ~= b_nop then
                return b_nop
            end

            -- then deprioritize cmds
            local a_cmd = string.match(a.desc, "^:") ~= nil
            local b_cmd = string.match(b.desc, "^:") ~= nil
            if a_cmd ~= b_cmd then
                return b_cmd
            end

            -- then prioritize remappable keymaps
            if a.noremap ~= b.noremap then
                return a.noremap < b.noremap
            end

            -- then prioritize descriptions
            if a.desc ~= b.desc then
                return a.desc < b.desc
            end

            -- then prioritize keystrokes
            local a_lhs = a.lhs
            local b_lhs = b.lhs
            if a_lhs ~= b_lhs then
                return a_lhs < b_lhs
            end

            -- finally prioritize vim mode
            return a.mode < b.mode
        end)
    end

    return all_mappings
end

function MakeCustomKeymapsPicker()
    local all_mappings = GetAllCurrentMappings(true)

    local max_len_lhs = 0
    for _, keymap in ipairs(all_mappings) do
        max_len_lhs = math.max(max_len_lhs, #utils.display_termcodes(keymap.lhs))
    end

    local displayer = entry_display.create({
        separator = "▏",
        hl_chars = { ["["] = "Builtin", ["]"] = "Builtin" },
        items = {
            { width = 3 },
            { width = 3 },
            { width = 7 },
            { width = max_len_lhs + 1 },
            { remaining = true },
        },
    })

    local function make_display(entry)
        local mapping = entry.value
        local is_remap = mapping.noremap ~= 0 and { "no", "Comment" } or { "re", "Macro" }
        local type = mapping.buffer ~= 0 and "buffer" or { "global", "Comment" }
        return displayer({
            mapping.mode,
            is_remap,
            type,
            mapping.lhs_fmt,
            mapping.desc,
        })
    end

    local function entry_from_mapping(mapping)
        return make_entry.set_default_entry_mt({
            value = mapping,
            display = make_display,
            -- define what to fuzzy search:
            ordinal = mapping.mode .. mapping.lhs_fmt .. mapping.desc,
        })
    end

    pickers
        .new({}, {
            prompt_title = "Search Mappings",
            results_title = "Key Mappings",
            finder = finders.new_table({
                results = all_mappings,
                entry_maker = entry_from_mapping,
            }),
            sorter = sorters.get_fzy_sorter(),
            attach_mappings = function(prompt_bufnr)
                actions.select_default:replace(function()
                    local selection = action_state.get_selected_entry()
                    if selection == nil then
                        utils.__warn_no_selection("builtin.keymaps")
                        return
                    end

                    vim.api.nvim_feedkeys(
                        vim.api.nvim_replace_termcodes(selection.value.lhs, true, false, true),
                        "t",
                        true
                    )
                    return actions.close(prompt_bufnr)
                end)
                return true
            end,
        })
        :find()
end
