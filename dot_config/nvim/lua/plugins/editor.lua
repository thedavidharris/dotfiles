return {
  -- Better Git integration
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      current_line_blame = true,
      current_line_blame_opts = {
        delay = 300,
      },
    },
  },

  -- Enhanced file explorer
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      filesystem = {
        filtered_items = {
          visible = true, -- Show hidden files
          hide_dotfiles = false,
          hide_gitignored = false,
        },
        follow_current_file = { enabled = true },
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
