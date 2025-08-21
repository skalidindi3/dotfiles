-- set leader-based macros
require("common")

-- tab management
keyset('n', '<leader>n', ':tabnext<CR>', { desc = "tab next" })
keyset('n', '<leader>p', ':tabprevious<CR>', { desc = "tab previous" })
keyset('n', '<leader><leader>', ':tab split<CR>', { desc = "fullscreen pane into new tab" })

-- system clipboard management
keyset({ 'n', 'v' }, '<leader>yy', '"+y', { desc = "copy to system clipboard" })
keyset({ 'n', 'v' }, '<leader>pp', '"+p', { desc = "paste from system clipboard" })
keyset({ 'n', 'v' }, '<leader>PP', '"+P', { desc = "paste from system clipboard behind cursor" })

-- shortcuts
keyset('n', '<leader>/', ':noh<CR>', { silent = false, desc = "clear search highlight" })
keyset('n', "<leader>gr", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { silent = false, desc = "global replace cursor word" })
keyset('v', "<leader>gr", [["ry:%s/\<<C-r>r\>/<C-r>r/gI<Left><Left><Left>]], { silent = false, desc = "global replace selection" })
keyset('n', '<leader>c', ':NoiceDismiss<CR>', { silent = false, desc = "clear notifications" })

-- toggles
keyset('n', '<leader>P', ':set paste!<CR>:set paste?<CR>', { silent = false, desc = "toggle paste mode" })
keyset('n', '<leader>F', ':VimadeToggle<CR>', { silent = false, desc = "toggle inactive pane fading" })
keyset('n', '<leader>I', ':IBLToggle<CR>', { silent = false, desc = 'toggle indent lines visibility' })

-- file quick access
keyset('n', '<leader>ev', function()
    vim.cmd('tabnew ' .. vim.fn.stdpath('config') .. '/init.lua')
end, { desc = "Edit configuration" })


