return {
  -- Chezmoi integration for dotfiles management
  {
    "alker0/chezmoi.vim",
    lazy = false,
    init = function()
      vim.g["chezmoi#use_tmp_buffer"] = true
    end,
  },

  -- TOML syntax support
  {
    "cespare/vim-toml",
    ft = "toml",
  },
}
