return {
  {
    -- 更现代的通知弹窗。
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    opts = {
      background_colour = "#1a1b26",
      fps = 60,
      on_open = function(win)
        vim.wo[win].winblend = 18
      end,
      render = "wrapped-compact",
      stages = "fade_in_slide_out",
      timeout = 2500,
      top_down = false,
    },
    config = function(_, opts)
      local notify = require("notify")
      notify.setup(opts)
      vim.notify = notify
    end,
  },
  {
    -- 提供接近 LazyVim 的命令行和消息界面。
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    opts = {
      cmdline = {
        enabled = true,
        view = "cmdline_popup",
      },
      messages = {
        enabled = true,
        view = "notify",
      },
      popupmenu = {
        enabled = true,
        backend = "nui",
      },
      lsp = {
        progress = {
          enabled = false,
        },
        hover = {
          enabled = true,
        },
        signature = {
          enabled = true,
        },
      },
      presets = {
        bottom_search = false,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = false,
        lsp_doc_border = true,
      },
    },
  },
}
