local map = vim.keymap.set

map("n", "<leader>gg", "<cmd>LazyGit<cr>", { desc = "打开 LazyGit" })
map("n", "<leader>gf", "<cmd>LazyGitCurrentFile<cr>", { desc = "打开当前文件 LazyGit" })
map("n", "<leader>gF", "<cmd>LazyGitFilterCurrentFile<cr>", { desc = "查看当前文件提交" })
map("n", "<leader>gb", "<cmd>Gitsigns blame_line<cr>", { desc = "查看当前行 blame" })
map("n", "<leader>gB", "<cmd>Gitsigns toggle_current_line_blame<cr>", { desc = "切换行内 blame 显示" })
map("n", "<leader>gd", "<cmd>Gitsigns diffthis<cr>", { desc = "查看当前文件 diff" })
map("n", "<leader>gD", "<cmd>DiffviewOpen<cr>", { desc = "打开 Diffview" })
map("n", "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", { desc = "查看当前文件历史" })
map("n", "<leader>gp", "<cmd>Gitsigns preview_hunk<cr>", { desc = "预览代码块改动" })
map("n", "<leader>gr", "<cmd>Gitsigns reset_hunk<cr>", { desc = "重置当前代码块" })
