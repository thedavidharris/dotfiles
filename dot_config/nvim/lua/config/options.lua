-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt

-- Only override LazyVim defaults where needed
opt.conceallevel = 0 -- Show concealed text (LazyVim default is 2)

-- Shell integration
if vim.fn.executable("zsh") == 1 then
  opt.shell = "zsh"
end
