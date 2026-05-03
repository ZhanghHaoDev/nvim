return {
  {
    -- 文件图标支持。
    "nvim-tree/nvim-web-devicons",
    lazy = true,
  },
  {
    -- 显示快捷键提示。
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      delay = 300,
      preset = "modern",
      win = {
        border = "rounded",
      },
      spec = {
        { "<leader>b", group = "缓冲区" },
        { "<leader>u", group = "界面" },
        { "<leader>f", group = "查找" },
        { "<leader>s", group = "搜索替换" },
        { "<leader>g", group = "Git" },
        { "<leader>c", group = "代码" },
        { "<leader>o", group = "大纲" },
        { "<leader>r", group = "重命名" },
        { "<leader>x", group = "诊断" },
        { "<leader>m", group = "CMake" },
      },
    },
  },
  {
    "kevinhwang91/nvim-hlslens",
    event = { "BufReadPost", "BufNewFile" },
    opts = { calm_down = true },
  },
  {
    -- 右侧滚动条与诊断标记。
    "petertriho/nvim-scrollbar",
    dependencies = { "kevinhwang91/nvim-hlslens" },
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      handle = {
        color = "#22c55e",
        blend = 0,
      },
      marks = {
        Search = { color = "#f59e0b" },
        Error = { color = "#ef4444" },
        Warn = { color = "#f59e0b" },
        Info = { color = "#38bdf8" },
        Hint = { color = "#22c55e" },
        Misc = { color = "#a78bfa" },
      },
      excluded_filetypes = {
        "alpha",
        "cmp_docs",
        "cmp_menu",
        "lazy",
        "mason",
        "neo-tree",
        "noice",
        "notify",
        "prompt",
        "TelescopePrompt",
      },
    },
    config = function(_, opts)
      require("scrollbar").setup(opts)
      require("scrollbar.handlers.search").setup({})
    end,
  },
}
