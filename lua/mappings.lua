require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
map("i", "JK", "<ESC>")

-- Configurar Delete correctamente en modo normal e insertar
map("n", "<Del>", "x", { desc = "Delete character under cursor in normal mode" })
map("i", "<Del>", "<C-o>x", { desc = "Delete character under cursor in insert mode" })
map("c", "<Del>", "<C-o>x", { desc = "Delete character under cursor in command mode" })
map(
  "n",
  "<leader>hh",
  "<cmd>lua vim.lsp.buf.hover()<CR>",
  { noremap = true, silent = true, desc = "Show LSP hover info" }
)

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
-- increase or decrease buffer size
map("n", "<S-Up>", ":resize +2<CR>", { desc = "Increase buffer height" })
map("n", "<S-Down>", ":resize -2<CR>", { desc = "Decrease buffer height" })
map("n", "<S-Left>", ":vertical resize -2<CR>", { desc = "Decrease buffer width" })
map("n", "<S-Right>", ":vertical resize +2<CR>", { desc = "Increase buffer width" })
