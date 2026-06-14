local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    spec = {
        { import = "plugins.specs.core" },
        { import = "plugins.specs.ui" },
        { import = "plugins.specs.editor" },
        { import = "plugins.specs.git" },
        { import = "plugins.specs.navigation" },
        { import = "plugins.specs.search" },
        { import = "plugins.specs.coding" },
        { import = "plugins.specs.lsp" },
    },
    install = { colorscheme = { "habamax" } },
    checker = { enabled = true, notify = true },
    change_detection = { notify = false },
    performance = {
        rtp = {
            -- 关闭用不到的内置插件,减少启动开销。
            disabled_plugins = {
                "gzip",
                "netrwPlugin",
                "tarPlugin",
                "tohtml",
                "tutor",
                "zipPlugin",
            },
        },
    },
})
