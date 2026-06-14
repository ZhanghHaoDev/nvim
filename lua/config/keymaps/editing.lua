local map = vim.keymap.set

-- 折叠
map("n", "zR", function()
    require("ufo").openAllFolds()
end, { desc = "展开所有折叠" })
map("n", "zM", function()
    require("ufo").closeAllFolds()
end, { desc = "折叠所有" })

-- 文档注释
map("n", "<leader>cn", function()
    require("neogen").generate()
end, { desc = "生成文档注释" })

-- 快速跳转
map({ "n", "x", "o" }, "s", function()
    require("flash").jump()
end, { desc = "快速跳转" })

-- 行移动
map("n", "<A-j>", "<cmd>move .+1<cr>==", { desc = "行下移" })
map("n", "<A-k>", "<cmd>move .-2<cr>==", { desc = "行上移" })
map("x", "<A-j>", ":move '>+1<cr>gv=gv", { desc = "选区下移" })
map("x", "<A-k>", ":move '<-2<cr>gv=gv", { desc = "选区上移" })
