-- define user commands for plugins --

-- gitsigns
-- stylua: ignore start
vim.api.nvim_create_user_command(
    "GitsignsToggleAll",
    function()
        -- skip toggle_signs
        vim.cmd("Gitsigns toggle_numhl")
        vim.cmd("Gitsigns toggle_linehl")
        vim.cmd("Gitsigns toggle_word_diff")
        vim.cmd("Gitsigns toggle_deleted")
        vim.notify("Toggled git visuals", vim.log.levels.INFO)
    end,
    { nargs = 0, desc = "toggle all extra gitsigns visuals" }
)
vim.api.nvim_create_user_command(
    "Gitaa",
    function() vim.cmd("Gitsigns stage_hunk") end,
    { nargs = 0, desc = "stage the current buffer" }
)
vim.api.nvim_create_user_command(
    "Gita",
    function() vim.cmd("Gitsigns stage_hunk") end,
    { nargs = 0, desc = "stage the selected hunk" }
)
vim.api.nvim_create_user_command(
    "Gitr",
    function() vim.cmd("Gitsigns undo_stage_hunk") end,
    { nargs = 0, desc = "unstage the selected hunk" }
)
-- stylua: ignore end

-- snap fuzzy finder
local snap = require("snap")
local snap_mappings = {
    exit = { "<Esc>", "<C-c>" },
    enter = { "<CR>", "<C-o>", "<C-e>" },
    ["enter-split"] = { "<C-s>" },
    ["enter-vsplit"] = { "<C-v>" },
    ["enter-tab"] = { "<C-t>" },
    ["prev-item"] = { "<Up>", "<C-k>" },
    ["next-item"] = { "<Down>", "<C-j>" },
    ["prev-page"] = { "<PageUp>" },
    ["next-page"] = { "<PageDown>" },
    ["view-toggle-hide"] = { "<C-p>" },
    -- NOTE: multiselect opens quickfix window & starts on 1st selection
    select = { "<Tab>" },
    ["select-all"] = { "<C-a>" },
    -- removed mappings
    next = {},
    unselect = {},
    ["view-page-down"] = {},
    ["view-page-up"] = {},
}
vim.api.nvim_create_user_command("FuzzyRipgrep", function()
    snap.run({
        prompt = "pattern>",
        producer = snap.get("producer.ripgrep.vimgrep"),
        select = snap.get("select.vimgrep").select,
        multiselect = snap.get("select.vimgrep").multiselect,
        views = { snap.get("preview.vimgrep") },
        mappings = snap_mappings,
    })
end, { nargs = 0, desc = "unstage the selected hunk" })
vim.api.nvim_create_user_command("FuzzyFiles", function()
    snap.run({
        prompt = "files>",
        producer = snap.get("consumer.fzf")(snap.get("producer.ripgrep.file")),
        select = snap.get("select.file").select,
        multiselect = snap.get("select.file").multiselect,
        views = { snap.get("preview.file") },
        mappings = snap_mappings,
    })
end, { nargs = 0, desc = "unstage the selected hunk" })
