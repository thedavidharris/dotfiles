return {
  -- Swift LSP support
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        sourcekit = {
          cmd = vim.fn.has("mac") == 1 and { "xcrun", "sourcekit-lsp" } or { "sourcekit-lsp" },
        },
      },
    },
  },

  -- Swift syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "swift" })
      end
    end,
  },
}
