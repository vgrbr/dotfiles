-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Super+S to save (Ghostty passes this as kitty keyboard protocol \e[115;9u)
vim.keymap.set({ "n", "i", "v" }, "<D-s>", "<cmd>w<cr><esc>", { desc = "Save file" })

-- zz to center and save
vim.keymap.set("n", "zz", "zz<cmd>w<cr>", { desc = "Center and save" })
