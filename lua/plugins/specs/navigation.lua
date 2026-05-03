return {
  {
    -- 左侧文件树。
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    cmd = "Neotree",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    opts = {
      close_if_last_window = true,
      default_component_configs = {
        file_size = {
          enabled = false,
        },
        type = {
          enabled = false,
        },
        last_modified = {
          enabled = false,
        },
        created = {
          enabled = false,
        },
      },
      filesystem = {
        follow_current_file = { enabled = true },
        bind_to_cwd = true,
        hijack_netrw_behavior = "open_default",
        filtered_items = {
          hide_dotfiles = false,
          hide_gitignored = false,
          hide_hidden = false,
          never_show = {},
          never_show_by_pattern = {},
        },
      },
      window = {
        position = "left",
        width = 32,
      },
    },
  },
  {
    -- 文件大纲，基于 LSP 文档符号展示函数、类、方法等结构。
    "stevearc/aerial.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      backends = { "lsp", "treesitter", "markdown", "asciidoc", "man" },
      layout = {
        default_direction = "right",
        placement = "window",
        resize_to_content = false,
        min_width = 28,
        max_width = 42,
      },
      attach_mode = "window",
      close_automatic_events = {},
      highlight_mode = "full_width",
      highlight_closest = true,
      show_guides = true,
      filter_kind = false,
      guides = {
        mid_item = "├─",
        last_item = "└─",
        nested_top = "│ ",
        whitespace = "  ",
      },
    },
  },
  {
    -- 快速跳转到当前屏幕中的字符、单词和搜索结果。
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {
      modes = {
        search = {
          enabled = true,
        },
      },
    },
  },
}