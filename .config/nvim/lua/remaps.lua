-- set common key remaps
require("common")

-- disable arrow keys
keyset({ 'n', 'v' }, '<Up>', '<Nop>')
keyset({ 'n', 'v' }, '<Down>', '<Nop>')
keyset({ 'n', 'v' }, '<Left>', '<Nop>')
keyset({ 'n', 'v' }, '<Right>', '<Nop>')

-- autocorrect common typos
keyset('c', 'Wq', 'wq', { silent = false })
keyset('c', 'Qa', 'qa', { silent = false })
keyset('c', 'Cq', 'cq', { silent = false })

-- consistency for yank & paste
keyset('n', 'Y', 'y$')
keyset('v', 'p', 'pgvy')

-- navigate lines visually (for wrapped lines)
keyset('n', 'j', 'gj')
keyset('n', 'k', 'gk')
keyset('v', 'j', 'gj')
keyset('v', 'k', 'gk')

-- faster navigation to extremes
keyset('n', 'H', '^')
keyset('v', 'H', '^')
keyset('n', 'L', '$')
keyset('v', 'L', '$')
keyset('n', 'J', 'G')
keyset('v', 'J', 'G')
keyset('n', 'K', 'gg')
keyset('v', 'K', 'gg')
keyset('n', '<C-j>', '<PageDown>')
keyset('n', '<C-k>', '<PageUp>')

-- smarter shifting in visual mode
keyset('v', '<', '<gv')
keyset('v', '>', '>gv')

-- code folding
keyset('n', '<space>', 'za')
keyset('n', '-', 'zc')
keyset('n', '=', 'zo')
keyset('n', '_', 'zM')
keyset('n', '+', 'zR')

-- ex mode is annoying
keyset('n', 'Q', '<Nop>')
