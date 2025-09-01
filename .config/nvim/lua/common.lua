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

function flatten2d(list2d)
    local flattened = {}
    for _, list1d in ipairs(list2d) do
        vim.list_extend(flattened, list1d)
    end
    return flattened
end
