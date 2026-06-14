return {
    {
        -- 文件图标：比 nvim-web-devicons 更现代，基于 filetype 而非扩展名匹配。
        -- mock_nvim_web_devicons() 让所有依赖 devicons 的插件无缝使用 mini.icons。
        "echasnovski/mini.icons",
        version = false,
        lazy = true,
        opts = {},
        init = function()
            package.preload["nvim-web-devicons"] = function()
                require("mini.icons").mock_nvim_web_devicons()
                return package.loaded["nvim-web-devicons"]
            end
        end,
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
                { "<leader>b", group = "buffer" },
                { "<leader>c", group = "code" },
                { "<leader>f", group = "find" },
                { "<leader>g", group = "git" },
                { "<leader>m", group = "cmake" },
                { "<leader>o", group = "outline" },
                { "<leader>s", group = "replace" },
                { "<leader>u", group = "ui" },
                { "<leader>x", group = "diagnostics" },
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
