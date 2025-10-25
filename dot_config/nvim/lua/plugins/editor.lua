return {
  -- Git integration (using LazyVim defaults)
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      current_line_blame = true,
    },
  },

  -- File explorer (using LazyVim defaults with minor tweaks)
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      filesystem = {
        filtered_items = {
          hide_dotfiles = false,
        },
      },
    },
  },

  -- Custom telescope shortcuts for dotfiles
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      {
        "<leader>fd",
        function()
          require("telescope.builtin").find_files({
            cwd = vim.fn.expand("~/.local/share/chezmoi"),
            prompt_title = "Dotfiles",
          })
        end,
        desc = "Find Dotfiles",
      },
      {
        "<leader>fc",
        function()
          require("telescope.builtin").find_files({
            cwd = vim.fn.expand("~/.config"),
            prompt_title = "Config Files",
          })
        end,
        desc = "Find Config Files",
      },
    },
  },
}
