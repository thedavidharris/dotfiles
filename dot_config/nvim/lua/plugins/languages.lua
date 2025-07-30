return {
  -- Shell scripting support (not included in LazyVim extras)
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        bashls = {},
      },
    },
  },

  -- Additional shell tools via Mason
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "bashls",
        "shellcheck",
        "shfmt",
      })
    end,
  },
}
