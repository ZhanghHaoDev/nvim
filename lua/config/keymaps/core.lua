local map = vim.keymap.set

map("n", "<leader>h", "<cmd>nohlsearch<cr>", { desc = "清除搜索高亮" })
map("n", "<leader>w", "<cmd>write<cr>", { desc = "保存文件" })
map("n", "<leader>q", "<cmd>quit<cr>", { desc = "退出窗口" })
map("n", "<leader>?", function()
    require("which-key").show({ global = true })
end, { desc = "显示全部快捷键" })
map("n", "<leader>un", "<cmd>Notifications<cr>", { desc = "通知历史" })
