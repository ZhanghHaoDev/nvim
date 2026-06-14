local map = vim.keymap.set

local function with_lsp(method, opts)
    return function()
        vim.lsp.buf[method](opts)
    end
end

local function with_diagnostic(method, opts)
    return function()
        vim.diagnostic[method](opts)
    end
end

-- 跳转（遵循 Vim g 前缀惯例）
map("n", "gd", with_lsp("definition"), { desc = "跳转到定义" })
map("n", "gD", with_lsp("declaration"), { desc = "跳转到声明" })
map("n", "gi", with_lsp("implementation"), { desc = "跳转到实现" })
map("n", "gr", with_lsp("references"), { desc = "查看引用" })
map("n", "K", with_lsp("hover"), { desc = "查看文档" })

-- 代码操作（<leader>c = code）
map("n", "<leader>ca", with_lsp("code_action"), { desc = "代码操作" })
map("n", "<leader>cf", function()
    require("conform").format({ async = true })
end, { desc = "格式化" })
map("n", "<leader>ch", "<cmd>ClangdSwitchSourceHeader<cr>", { desc = "切换头文件/源文件" })
map("n", "<leader>ci", function()
    vim.lsp.buf.incoming_calls()
end, { desc = "谁调用了我" })
map("n", "<leader>co", function()
    vim.lsp.buf.outgoing_calls()
end, { desc = "我调用了谁" })
map("n", "<leader>cr", with_lsp("rename"), { desc = "重命名符号" })
map("n", "<leader>uh", function()
    local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = 0 })
    vim.lsp.inlay_hint.enable(not enabled, { bufnr = 0 })
end, { desc = "切换参数提示" })

-- 诊断（<leader>x = diagnostics）
map("n", "<leader>xx", with_diagnostic("open_float"), { desc = "当前行错误详情" })
map("n", "<leader>xd", "<cmd>Trouble diagnostics toggle focus=true filter.buf=0<cr>", { desc = "当前文件问题" })
map("n", "<leader>xw", "<cmd>Trouble diagnostics toggle focus=true<cr>", { desc = "全项目问题" })
map("n", "]d", with_diagnostic("goto_next"), { desc = "下一个诊断" })
map("n", "[d", with_diagnostic("goto_prev"), { desc = "上一个诊断" })
