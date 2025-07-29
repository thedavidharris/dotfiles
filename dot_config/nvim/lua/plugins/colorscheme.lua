return {
  -- Catppuccin theme to match your other tools
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      flavour = "macchiato", -- consistent with your terminal/tools
      integrations = {
        cmp = true,
        gitsigns = true,
        neotree = true, -- Fixed: it's neotree, not neo_tree
        treesitter = true,
        telescope = true,
        which_key = true,
      },
    },
  },

  -- Configure LazyVim to use Catppuccin
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
}
