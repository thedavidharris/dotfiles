-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt

-- Editor appearance
opt.conceallevel = 0 -- Show concealed text normally
opt.cmdheight = 1 -- Height of command line
opt.pumheight = 10 -- Max items in popup menu

-- Indentation
opt.tabstop = 2 -- Insert 2 spaces for a tab
opt.shiftwidth = 2 -- Number of spaces for indent
opt.expandtab = true -- Convert tabs to spaces
opt.smartindent = true -- Smart autoindenting

-- Search
opt.ignorecase = true -- Ignore case in search
opt.smartcase = true -- Override ignorecase if search contains uppercase

-- File handling
opt.backup = false -- Don't create backup files
opt.writebackup = false -- Don't backup before overwriting
opt.swapfile = false -- Don't create swap files
opt.undofile = true -- Enable persistent undo

-- Performance
opt.updatetime = 100 -- Faster completion (default is 4000ms)
opt.timeoutlen = 300 -- Time to wait for mapped sequence

-- Better splitting
opt.splitbelow = true -- Horizontal splits go below
opt.splitright = true -- Vertical splits go right

-- Line numbers
opt.relativenumber = true -- Relative line numbers
opt.numberwidth = 4 -- Line number column width

-- Visual
opt.wrap = false -- Don't wrap lines
opt.scrolloff = 8 -- Keep 8 lines above/below cursor
opt.sidescrolloff = 8 -- Keep 8 columns left/right of cursor
opt.signcolumn = "yes" -- Always show sign column

-- Clipboard
opt.clipboard = "unnamedplus" -- Use system clipboard

-- Shell integration
if vim.fn.executable("zsh") == 1 then
  opt.shell = "zsh"
end
