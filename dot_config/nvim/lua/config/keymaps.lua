-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

-- Dotfiles specific shortcuts
map("n", "<leader>ce", function()
  vim.cmd("edit " .. vim.fn.expand("~/.local/share/chezmoi"))
end, { desc = "Edit dotfiles" })

map("n", "<leader>ca", function()
  vim.cmd("terminal chezmoi apply")
end, { desc = "Apply chezmoi" })

-- Quick config access
map("n", "<leader>cz", function()
  vim.cmd("edit " .. vim.fn.expand("~/.config/zsh/.zshrc"))
end, { desc = "Edit zshrc" })

map("n", "<leader>cv", function()
  vim.cmd("edit " .. vim.fn.expand("~/.config/nvim/init.lua"))
end, { desc = "Edit neovim config" })

-- LazyVim management shortcuts (in addition to defaults)
map("n", "<leader>lc", "<cmd>Lazy check<cr>", { desc = "Check for updates" })
map("n", "<leader>lr", "<cmd>Lazy restore<cr>", { desc = "Restore plugins" })
