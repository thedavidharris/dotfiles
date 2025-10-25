return {
  -- Treesitter configuration for better syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      -- Add useful languages for your workflow
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, {
          -- Shell scripting
          "bash",
          "fish",
          "zsh",

          -- Configuration files
          "toml",
          "yaml",
          "json",
          "jsonc",

          -- Markup
          "markdown",
          "markdown_inline",

          -- Git
          "gitcommit",
          "gitignore",
          "gitattributes",

          -- Programming languages
          "python",
          "java",
          "kotlin",
          "go",
          "rust",
          "lua",
          "vim",
          "vimdoc",
          "swift", -- Already configured in swift.lua, but good to have here too
        })
      end

      -- Simple performance optimizations
      opts.auto_install = true -- Automatically install missing parsers

      return opts
    end,
  },
}
