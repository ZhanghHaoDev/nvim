return {
    {
        -- Lua 插件常用依赖。
        "nvim-lua/plenary.nvim",
        lazy = false,
    },
    {
        -- 大文件保护：打开超大文件时主动关闭重型特性，避免卡顿。
        "LunarVim/bigfile.nvim",
        lazy = false,
        priority = 900,
        opts = {
            filesize = 2,
            features = {
                "indent_blankline",
                "lsp",
                "treesitter",
                "syntax",
                "matchparen",
                "vimopts",
            },
        },
    },
}
