-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

local function augroup(name)
  return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
end

-- Swift-specific configurations
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("swift"),
  pattern = "swift",
  callback = function()
    -- Swift-specific settings
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.softtabstop = 4
    vim.opt_local.expandtab = true

    -- Swift-specific key mappings
    local map = vim.keymap.set
    local opts = { buffer = true, silent = true }

    -- Quick actions for Swift development
    map("n", "<leader>sr", ":!swift run<CR>", vim.tbl_extend("force", opts, { desc = "Swift Run" }))
    map("n", "<leader>sb", ":!swift build<CR>", vim.tbl_extend("force", opts, { desc = "Swift Build" }))
    map("n", "<leader>st", ":!swift test<CR>", vim.tbl_extend("force", opts, { desc = "Swift Test" }))

    -- Xcode integration
    map("n", "<leader>xb", ":!xcodebuild<CR>", vim.tbl_extend("force", opts, { desc = "Xcode Build" }))
    map("n", "<leader>xo", ":!open *.xcodeproj *.xcworkspace<CR>", vim.tbl_extend("force", opts, { desc = "Open in Xcode" }))
  end,
})

-- Objective-C configurations (often used with Swift)
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("objc"),
  pattern = { "objc", "objcpp" },
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.softtabstop = 4
    vim.opt_local.expandtab = true

    -- Header/implementation file switching
    local map = vim.keymap.set
    local opts = { buffer = true, silent = true }

    map("n", "<leader>ah", function()
      local current_file = vim.fn.expand("%:p")
      local basename = vim.fn.expand("%:r")
      local extension = vim.fn.expand("%:e")

      local alternate_file
      if extension == "h" then
        -- Try .m first, then .mm, then .cpp
        for _, ext in ipairs({"m", "mm", "cpp"}) do
          local candidate = basename .. "." .. ext
          if vim.fn.filereadable(candidate) == 1 then
            alternate_file = candidate
            break
          end
        end
      else
        -- Switch to header
        alternate_file = basename .. ".h"
      end

      if alternate_file and vim.fn.filereadable(alternate_file) == 1 then
        vim.cmd("edit " .. alternate_file)
      else
        vim.notify("No alternate file found", vim.log.levels.WARN)
      end
    end, vim.tbl_extend("force", opts, { desc = "Alternate Header/Implementation" }))
  end,
})

-- Enhanced file detection for iOS/macOS projects
vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
  group = augroup("ios_project"),
  pattern = "*.xcconfig",
  callback = function()
    vim.bo.filetype = "xcconfig"
  end,
})

-- Auto-format Swift files on save (if swift-format is available)
vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup("swift_format"),
  pattern = "*.swift",
  callback = function()
    if vim.fn.executable("swift-format") == 1 then
      vim.lsp.buf.format({ timeout_ms = 2000 })
    end
  end,
})
