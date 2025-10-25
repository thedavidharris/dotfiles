return {
  -- Kotlin LSP support (Python and Java handled by LazyVim extras)
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Kotlin
        kotlin_language_server = {},
      },
    },
  },

  -- Additional Kotlin tools via Mason
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        -- Kotlin tools
        "kotlin-language-server",
      })
    end,
  },
}
