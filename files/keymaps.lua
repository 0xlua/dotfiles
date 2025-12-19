--Remap space as leader key
map("", "<Space>", "<Nop>", opts())

-- Better window navigation
map('n', '<C-h>','<C-w>h' , opts())
map('n', '<C-j>','<C-w>j' , opts())
map('n', '<C-k>','<C-w>k' , opts())
map('n', '<C-l>','<C-w>l' , opts())

-- Resize with arrows
map("n", "<C-Up>", "<cmd>resize +2<CR>", opts())
map("n", "<C-Down>", "<cmd>resize -2<CR>", opts())
map("n", "<C-Left>", "<cmd>vertical resize -2<CR>", opts())
map("n", "<C-Right>", "<cmd>vertical resize +2<CR>", opts())

-- Stay in indent mode
map("v", "<", "<gv", opts())
map("v", ">", ">gv", opts())

-- Move text up and down
map("v", "<A-j>", "<cmd>m .+1<CR>==", opts())
map("v", "<A-k>", "<cmd>m .-2<CR>==", opts())
map("v", "p", '"_dP', opts())

