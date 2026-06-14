local map = vim.keymap.set

map("n", "<leader>gg", "<cmd>LazyGit<cr>", { desc = "LazyGit" })
map("n", "<leader>gD", "<cmd>DiffviewOpen<cr>", { desc = "Diffview" })
map("n", "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", { desc = "当前文件历史" })
map("n", "<leader>go", function()
    Snacks.gitbrowse()
end, { desc = "浏览器打开" })
