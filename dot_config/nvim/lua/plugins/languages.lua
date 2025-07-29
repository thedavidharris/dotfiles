return {
  -- Use LazyVim language extras (includes LSP, treesitter, and mason tools)
  { import = "lazyvim.plugins.extras.lang.yaml" },
  { import = "lazyvim.plugins.extras.lang.json" },
  { import = "lazyvim.plugins.extras.lang.python" },
  { import = "lazyvim.plugins.extras.lang.go" },
  { import = "lazyvim.plugins.extras.lang.typescript" },
  { import = "lazyvim.plugins.extras.lang.markdown" },
  { import = "lazyvim.plugins.extras.lang.docker" },

  -- Shell scripting support (not covered by LazyVim extras)
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        bashls = {}, -- Bash language server
      },
    },
  },

  -- Additional tools for shell scripting
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "bashls",
        "shellcheck",
        "shfmt",
      },
    },
  },
}
