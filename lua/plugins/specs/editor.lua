local config_utils = require("config.utils")

return {
  {
    -- 多合一工具集：快速打开、草稿 buffer、git 浏览器、内置终端、平滑滚动。
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      bigfile    = { enabled = false },
      dashboard  = { enabled = false },
      indent     = { enabled = false },
      notifier   = { enabled = false },
      words      = { enabled = false },
      lazygit    = { enabled = false },
      picker     = { enabled = false },
      quickfile  = { enabled = true },
      scratch    = { enabled = true },
      gitbrowse  = { enabled = true },
      terminal   = { enabled = true },
      scroll     = { enabled = true },
      toggle     = { enabled = true },
    },
    keys = {
      { "<leader>bs", function() Snacks.scratch() end,      desc = "草稿缓冲区",           mode = "n" },
      { "<leader>go", function() Snacks.gitbrowse() end,    desc = "浏览器打开当前文件",   mode = { "n", "v" } },
      { "<C-\\>",     function() Snacks.terminal() end,     desc = "切换终端",             mode = { "n", "t" } },
      { "<leader>us", function() Snacks.toggle.option("spell") end,  desc = "切换拼写检查" },
      { "<leader>uw", function() Snacks.toggle.option("wrap") end,   desc = "切换自动换行" },
    },
  },
  {
    -- CMake 项目管理，自动生成 compile_commands.json 供 clangd 使用。
    "Civitasv/cmake-tools.nvim",
    ft = { "c", "cpp", "cmake" },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      cmake_command = "cmake",
      cmake_build_directory = "build",
      cmake_generate_options = { "-DCMAKE_EXPORT_COMPILE_COMMANDS=ON" },
      cmake_build_options = { "--parallel" },
      cmake_console_size = 12,
      cmake_console_position = "bottom",
      cmake_runner = { name = "overseer" },
    },
    keys = {
      { "<leader>mg", "<cmd>CMakeGenerate<cr>",            desc = "Configure" },
      { "<leader>mb", "<cmd>CMakeBuild<cr>",               desc = "Build" },
      { "<leader>mr", "<cmd>CMakeRun<cr>",                 desc = "Run" },
      { "<leader>mt", "<cmd>CMakeSelectBuildTarget<cr>",   desc = "选择 Build Target" },
      { "<leader>ml", "<cmd>CMakeSelectLaunchTarget<cr>",  desc = "选择 Run Target" },
      { "<leader>mc", "<cmd>CMakeClean<cr>",               desc = "Clean" },
    },
  },
  {
    -- 任务运行器，在 nvim 内执行 cmake/make 等构建任务，结果输出到 quickfix。
    "stevearc/overseer.nvim",
    cmd = { "OverseerRun", "OverseerToggle", "OverseerBuild" },
    keys = {
      { "<leader>mo", "<cmd>OverseerToggle<cr>", desc = "任务面板" },
      { "<leader>mR", "<cmd>OverseerRun<cr>",    desc = "运行任务" },
    },
    opts = {
      task_list = {
        direction = "bottom",
        min_height = 12,
        max_height = 20,
      },
    },
  },
  {
    -- Session 持久化，重新打开 Neovim 时恢复上次的工作区布局。
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = { dir = vim.fn.stdpath("state") .. "/sessions/" },
  },
  {
    -- 安全删除 buffer，避免关闭标签时把整个 Neovim 一起关掉。
    "echasnovski/mini.bufremove",
    version = false,
    event = "VeryLazy",
  },
  {
    -- 自动补全括号、引号等。
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {},
  },
  {
    -- 快速注释代码，支持 gcc/gc 等高频操作。
    "numToStr/Comment.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
  },
  {
    -- 高亮当前词及其引用，让选中感更明显。
    "RRethy/vim-illuminate",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      delay = 120,
      under_cursor = true,
      large_file_cutoff = 2000,
      min_count_to_highlight = 2,
    },
    config = function(_, opts)
      require("illuminate").configure(opts)
    end,
  },
  {
    -- 统一格式化入口，补齐更像 IDE 的保存即格式化体验。
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    opts = {
      formatters = {
        clang_format = {
          command = config_utils.preferred_executable("llvm", "clang-format"),
        },
      },
      formatters_by_ft = {
        c = { "clang_format" },
        cpp = { "clang_format" },
        h = { "clang_format" },
        hpp = { "clang_format" },
        lua = { "stylua" },
        python = { "black" },
      },
      format_on_save = false,
      notify_on_error = true,
    },
  },
  {
    -- Treesitter 语法树支持，补齐高亮、缩进和增量选择。
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      ensure_installed = {
        "bash",
        "c",
        "css",
        "cmake",
        "cpp",
        "dockerfile",
        "git_config",
        "gitcommit",
        "gitignore",
        "go",
        "html",
        "javascript",
        "json",
        "lua",
        "make",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "rust",
        "sql",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "xml",
        "yaml",
      },
      -- 未列入的语言在首次打开时也会尝试安装 parser，只负责高亮，不会顺带启动 LSP。
      auto_install = true,
      highlight = {
        enable = true,
      },
      indent = {
        enable = true,
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "gnn",
          node_incremental = "grn",
          scope_incremental = "grc",
          node_decremental = "grm",
        },
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.config").setup(opts)
    end,
  },
  {
    -- 粘滞滚动，在窗口顶部固定显示当前函数、类等上下文。
    "nvim-treesitter/nvim-treesitter-context",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      enable = true,
      multiwindow = false,
      max_lines = 4,
      min_window_height = 18,
      line_numbers = false,
      multiline_threshold = 6,
      trim_scope = "outer",
      mode = "topline",
      separator = "─",
      on_attach = function(bufnr)
        local filetype = vim.bo[bufnr].filetype
        local buftype = vim.bo[bufnr].buftype
        local disabled_filetypes = {
          alpha = true,
          dashboard = true,
          help = true,
          lazy = true,
          mason = true,
          ["neo-tree"] = true,
          noice = true,
          notify = true,
          TelescopePrompt = true,
          trouble = true,
        }

        return buftype == "" and not disabled_filetypes[filetype]
      end,
    },
    config = function(_, opts)
      local function apply_highlights()
        vim.api.nvim_set_hl(0, "TreesitterContext", { bg = "#1f2335" })
        vim.api.nvim_set_hl(0, "TreesitterContextBottom", { underline = true, sp = "#414868" })
        vim.api.nvim_set_hl(0, "TreesitterContextSeparator", { fg = "#3b4261", bg = "#1f2335" })
      end

      apply_highlights()

      vim.api.nvim_create_autocmd("ColorScheme", {
        group = vim.api.nvim_create_augroup("StickyScrollHighlights", { clear = true }),
        callback = apply_highlights,
      })

      require("treesitter-context").setup(opts)
    end,
  },
  {
    -- 缩进参考线，并用 Treesitter 高亮当前作用域。
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      indent = {
        char = "│",
        tab_char = "│",
        highlight = { "IblIndent" },
      },
      scope = {
        enabled = true,
        char = "│",
        show_start = true,
        show_end = true,
        show_exact_scope = true,
        highlight = {
          "RainbowDelimiterRed",
          "RainbowDelimiterYellow",
          "RainbowDelimiterBlue",
          "RainbowDelimiterOrange",
          "RainbowDelimiterGreen",
          "RainbowDelimiterViolet",
          "RainbowDelimiterCyan",
        },
      },
      whitespace = {
        remove_blankline_trail = false,
      },
      exclude = {
        filetypes = {
          "alpha",
          "checkhealth",
          "dashboard",
          "help",
          "lazy",
          "lspinfo",
          "mason",
          "neo-tree",
          "notify",
          "snacks_dashboard",
          "TelescopePrompt",
          "toggleterm",
          "trouble",
        },
        buftypes = { "terminal", "nofile", "prompt", "quickfix" },
      },
    },
    config = function(_, opts)
      local hooks = require("ibl.hooks")

      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        vim.api.nvim_set_hl(0, "IblIndent", { fg = "#2f354d", nocombine = true })
      end)

      hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)

      require("ibl").setup(opts)
    end,
  },
  {
    -- 更现代的代码折叠，支持 LSP/Treesitter 提供折叠范围。
    "kevinhwang91/nvim-ufo",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "kevinhwang91/promise-async",
    },
    opts = {
      provider_selector = function(_, filetype, _)
        local no_lsp_filetypes = {
          git = true,
          markdown = true,
        }

        if no_lsp_filetypes[filetype] then
          return { "indent" }
        end

        return { "lsp", "indent" }
      end,
    },
  },
  {
    -- 彩虹括号，高亮不同层级的成对符号。
    "HiPhish/rainbow-delimiters.nvim",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      vim.g.rainbow_delimiters = {
        highlight = {
          "RainbowDelimiterRed",
          "RainbowDelimiterYellow",
          "RainbowDelimiterBlue",
          "RainbowDelimiterOrange",
          "RainbowDelimiterGreen",
          "RainbowDelimiterViolet",
          "RainbowDelimiterCyan",
        },
      }
    end,
  },
  {
    -- 高亮 TODO、FIXME、NOTE 等关键标记。
    "folke/todo-comments.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      signs = true,
      highlight = {
        multiline = false,
      },
      keywords = {
        FIX = { icon = "F ", color = "error" },
        TODO = { icon = "T ", color = "info" },
        HACK = { icon = "H ", color = "warning" },
        WARN = { icon = "W ", color = "warning", alt = { "WARNING", "XXX" } },
        NOTE = { icon = "N ", color = "hint", alt = { "INFO" } },
      },
    },
  },
}
