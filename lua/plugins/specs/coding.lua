return {
  {
    -- 生成函数、类、模块等文档注释骨架。
    "danymat/neogen",
    cmd = "Neogen",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      snippet_engine = "luasnip",
    },
  },
  {
    -- LuaSnip snippet 引擎，供 neogen 和 blink.cmp 使用。
    "L3MON4D3/LuaSnip",
    lazy = true,
    dependencies = { "rafamadriz/friendly-snippets" },
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
    end,
  },
  {
    -- 快速包裹、替换、删除成对符号（括号、引号等）。
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    opts = {},
  },
  {
    -- 让 . 重复命令支持插件操作（surround 等）。
    "tpope/vim-repeat",
    event = "VeryLazy",
  },
  {
    -- 增强文本对象：函数、类、参数等。
    "echasnovski/mini.ai",
    version = false,
    event = "VeryLazy",
    opts = { n_lines = 500 },
  },
  {
    -- 自动补全主插件，用 Rust 实现，性能优于 nvim-cmp。
    "saghen/blink.cmp",
    version = "*",
    dependencies = { "L3MON4D3/LuaSnip" },
    opts = {
      keymap = {
        preset = "default",
        ["<CR>"] = { "accept", "fallback" },
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
      snippets = { preset = "luasnip" },
      completion = {
        documentation = { auto_show = true, auto_show_delay_ms = 200 },
      },
    },
  },
}
