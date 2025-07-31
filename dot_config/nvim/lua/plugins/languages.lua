return {
  -- Shell scripting support (not included in LazyVim extras)
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        bash_ls = {},
      },
    },
  },

  -- Additional shell tools via Mason
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "bash-language-server",
        "shellcheck",
        "shfmt",
      })
    end,
  },
}
