vim.g.mapleader = " "
vim.g.maplocalleader = ","

pcall(require, "config.options")
pcall(require, "config.keymaps.core")

vim.schedule(function()
  vim.notify("已使用 safe.lua 启动: 未加载 lazy.nvim、LSP 和其他插件", vim.log.levels.WARN)
end)
