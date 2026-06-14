return {
    {
        -- LSP 安装器界面。
        "williamboman/mason.nvim",
        cmd = { "Mason", "MasonInstall", "MasonUpdate" },
        build = ":MasonUpdate",
        opts = {},
    },
    {
        -- 自动安装语言服务器。
        "williamboman/mason-lspconfig.nvim",
        event = "VeryLazy",
        dependencies = {
            "williamboman/mason.nvim",
            "neovim/nvim-lspconfig",
        },
        opts = {
            ensure_installed = {
                "bashls",
                "cmake",
                "jsonls",
                "lua_ls",
                "marksman",
                "pyright",
                "autotools_ls",
                "yamlls",
            },
            automatic_installation = {
                exclude = { "clangd" },
            },
            automatic_enable = false,
        },
        config = function(_, opts)
            require("mason").setup()
            require("mason-lspconfig").setup(opts)
        end,
    },
    {
        -- 自动安装格式化和诊断工具。
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        event = "VeryLazy",
        dependencies = { "williamboman/mason.nvim" },
        opts = {
            ensure_installed = {
                "black",
                "cmake-language-server",
                "lua-language-server",
                "pyright",
                "stylua",
            },
            auto_update = false,
            run_on_start = false,
            start_delay = 3000,
        },
    },
    {
        -- 加速 Neovim 配置目录的 Lua LSP，替代 lua_ls 的全量扫描。
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
            library = {
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
        },
    },
    {
        -- LSP 主配置。
        "neovim/nvim-lspconfig",
        lazy = false,
        dependencies = {
            "saghen/blink.cmp",
        },
        config = function()
            require("config.lsp").setup()
        end,
    },
    {
        -- clangd 增强：类型层级、AST 查看、内存用量、更好的 inlay hints。
        "p00f/clangd_extensions.nvim",
        ft = { "c", "cpp", "objc", "objcpp" },
        opts = {
            inlay_hints = {
                inline = true,
                only_current_line = false,
                only_current_line_autocmd = "CursorHold",
                show_parameter_hints = true,
                parameter_hints_prefix = "← ",
                other_hints_prefix = "» ",
            },
            ast = {
                role_icons = {
                    type = "",
                    declaration = "",
                    expression = "",
                    specifier = "",
                    statement = "",
                    ["template argument"] = "",
                },
            },
            memory_usage = { border = "rounded" },
            symbol_info = { border = "rounded" },
        },
        keys = {
            { "<leader>cT", "<cmd>ClangdTypeHierarchy<cr>", ft = { "c", "cpp" }, desc = "类型层级" },
            { "<leader>cA", "<cmd>ClangdAST<cr>", ft = { "c", "cpp" }, desc = "查看 AST" },
            { "<leader>cM", "<cmd>ClangdMemoryUsage<cr>", ft = { "c", "cpp" }, desc = "内存用量" },
        },
    },
    {
        -- 统一的问题列表和诊断/引用面板。
        "folke/trouble.nvim",
        cmd = "Trouble",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {
            focus = true,
            warn_no_results = false,
            open_no_results = true,
        },
    },
}
