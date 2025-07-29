return {
  -- Use LazyVim's coding extras for better commenting
  { import = "lazyvim.plugins.extras.coding.mini-comment" },

  -- Chezmoi integration for your dotfiles
  {
    "alker0/chezmoi.vim",
    lazy = false,
    init = function()
      vim.g["chezmoi#use_tmp_buffer"] = true
    end,
  },

  -- Enhanced JSON support for config files
  {
    "b0o/schemastore.nvim",
    ft = { "json", "jsonc" },
  },

  -- TOML support for chezmoi and other config files
  {
    "cespare/vim-toml",
    ft = "toml",
  },
}
