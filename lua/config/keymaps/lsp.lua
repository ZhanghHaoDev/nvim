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

map("n", "<leader>ch", "<cmd>ClangdSwitchSourceHeader<cr>", { desc = "切换头文件/源文件" })
map("n", "<leader>rn", with_lsp("rename"), { desc = "重命名符号" })
map("n", "gd", with_lsp("definition"), { desc = "跳转到定义" })
map("n", "gD", with_lsp("declaration"), { desc = "跳转到声明" })
map("n", "gi", with_lsp("implementation"), { desc = "跳转到实现" })
map("n", "<leader>D", with_lsp("type_definition"), { desc = "跳转到类型定义" })
map("n", "gr", with_lsp("references"), { desc = "查看引用" })
map("n", "K", with_lsp("hover"), { desc = "查看文档" })
map("n", "<leader>ca", with_lsp("code_action"), { desc = "代码操作" })
map("n", "<leader>cl", "<cmd>Trouble lsp toggle focus=true win.position=right<cr>", { desc = "LSP 列表" })
map("n", "<leader>cs", "<cmd>Trouble symbols toggle focus=true win.position=right<cr>", { desc = "符号列表" })
map("n", "<leader>uh", function()
  if not vim.lsp.inlay_hint then
    return
  end

  local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = 0 })
  vim.lsp.inlay_hint.enable(not enabled, { bufnr = 0 })
end, { desc = "切换参数提示" })
map("n", "<leader>xx", with_diagnostic("open_float"), { desc = "查看当前错误" })
map("n", "<leader>xd", "<cmd>Trouble diagnostics toggle focus=true filter.buf=0<cr>", { desc = "当前文件问题" })
map("n", "<leader>xw", "<cmd>Trouble diagnostics toggle focus=true<cr>", { desc = "工作区问题" })
map("n", "<leader>xr", "<cmd>Trouble lsp_references toggle focus=true<cr>", { desc = "引用面板" })
map("n", "[d", with_diagnostic("goto_prev"), { desc = "上一个诊断" })
map("n", "]d", with_diagnostic("goto_next"), { desc = "下一个诊断" })

map("n", "<leader>ci", function() vim.lsp.buf.incoming_calls() end, { desc = "谁调用了我" })
map("n", "<leader>co", function() vim.lsp.buf.outgoing_calls() end, { desc = "我调用了谁" })
