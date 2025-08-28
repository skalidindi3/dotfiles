-- global functions for usage in lua --

-- helper for remapping the default keymap
function keyset(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend('force', options, opts)
  end
  vim.keymap.set(mode, lhs, rhs, options)
end

-- debug helpers to use from vim lua command line
function DebugList(arr)
    for i, v in ipairs(arr)
        do print(i, ":", v)
    end
end
function DebugDict(dict)
    for k, v in pairs(dict)
        do print(k, ":", v)
    end
end
