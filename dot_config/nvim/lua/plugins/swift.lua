return {
  -- Swift language support
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- SourceKit-LSP (Apple's official Swift language server)
        sourcekit = {
          cmd = {
            "xcrun",
            "sourcekit-lsp",
          },
          filetypes = { "swift", "objective-c", "objective-cpp" },
          root_dir = function(filename, _)
            local util = require("lspconfig.util")
            return util.root_pattern("buildServer.json")(filename)
              or util.root_pattern("*.xcodeproj", "*.xcworkspace")(filename)
              or util.root_pattern("Package.swift")(filename)
              or util.find_git_ancestor(filename)
          end,
          settings = {
            -- Add any SourceKit-LSP specific settings here
          },
        },
      },
    },
  },

  -- Enhanced treesitter for Swift and related languages
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "swift",
        "objc",
        "objcpp",
        "c",
        "cpp",
      })
    end,
  },

  -- Mason tool installer for Swift tools
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        -- Swift tools
        "swiftlint", -- Swift linter
        "swift-format", -- Swift formatter (if available)
      },
    },
  },

  -- Swift-specific file associations and settings
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = { "swift" },
      },
    },
  },

  -- Better markdown support for Swift documentation
  {
    "iamcco/markdown-preview.nvim",
    ft = { "markdown" },
    opts = {
      markdown = {
        fenced_languages = {
          "swift",
          "objc",
          "objective-c",
        },
      },
    },
  },
}
