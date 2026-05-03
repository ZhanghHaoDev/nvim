local map = vim.keymap.set

map("n", "<leader>h", "<cmd>nohlsearch<cr>", { desc = "清除搜索高亮" })
map("n", "<leader>w", "<cmd>write<cr>", { desc = "保存文件" })
map("n", "<leader>q", "<cmd>quit<cr>", { desc = "退出窗口" })
map("n", "<leader>Q", "<cmd>qa!<cr>", { desc = "强制退出 Neovim" })
map("n", "<leader>?", function()
  require("which-key").show({ global = true })
end, { desc = "显示全部快捷键" })
map("n", "<leader>un", "<cmd>Noice<cr>", { desc = "查看消息历史" })
map("n", "<leader>cf", function() require("conform").format({ async = true }) end, { desc = "格式化文件" })
map("n", "<leader>qs", function() require("persistence").load() end, { desc = "恢复上次 session" })
