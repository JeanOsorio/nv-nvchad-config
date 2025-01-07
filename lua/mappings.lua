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

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
