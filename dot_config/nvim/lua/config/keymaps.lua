-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

-- Better movement
map("n", "H", "^", { desc = "Go to start of line" })
map("n", "L", "$", { desc = "Go to end of line" })

-- Better window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- Better indenting
map("v", "<", "<gv", { desc = "Indent left" })
map("v", ">", ">gv", { desc = "Indent right" })

-- Move lines up/down
map("n", "<A-j>", ":m .+1<cr>==", { desc = "Move line down" })
map("n", "<A-k>", ":m .-2<cr>==", { desc = "Move line up" })
map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move selection down" })
map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move selection up" })

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

-- Better search
map("n", "<leader>nh", ":nohlsearch<cr>", { desc = "No highlight" })

-- Quick save
map("n", "<leader>w", ":w<cr>", { desc = "Save file" })

-- LazyVim management shortcuts
map("n", "<leader>l", "", { desc = "+lazy" })
map("n", "<leader>ll", "<cmd>Lazy<cr>", { desc = "Open Lazy" })
map("n", "<leader>lu", "<cmd>Lazy update<cr>", { desc = "Update plugins" })
map("n", "<leader>ls", "<cmd>Lazy sync<cr>", { desc = "Sync plugins" })
map("n", "<leader>lc", "<cmd>Lazy check<cr>", { desc = "Check for updates" })
map("n", "<leader>lp", "<cmd>Lazy profile<cr>", { desc = "Profile startup" })
map("n", "<leader>lr", "<cmd>Lazy restore<cr>", { desc = "Restore plugins" })
