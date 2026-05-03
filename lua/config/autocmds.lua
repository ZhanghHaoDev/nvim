-- LSP document link 下划线（头文件识别标记）。
local doc_link_ns = vim.api.nvim_create_namespace("user_lsp_doc_links")
vim.api.nvim_set_hl(0, "LspDocumentLink", { underline = true, sp = "#7dcfff" })

local function update_doc_links(bufnr)
  local params = { textDocument = vim.lsp.util.make_text_document_params(bufnr) }
  vim.lsp.buf_request(bufnr, "textDocument/documentLink", params, function(err, links)
    if err or not links then return end
    vim.api.nvim_buf_clear_namespace(bufnr, doc_link_ns, 0, -1)
    for _, link in ipairs(links) do
      local r = link.range
      vim.api.nvim_buf_set_extmark(bufnr, doc_link_ns, r.start.line, r.start.character, {
        end_col = r["end"].character,
        hl_group = "LspDocumentLink",
      })
    end
  end)
end

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("user_lsp_doc_links", { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client or not client.supports_method("textDocument/documentLink") then return end
    local bufnr = args.buf
    local buf_group = vim.api.nvim_create_augroup("user_lsp_doc_links_buf_" .. bufnr, { clear = true })
    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "CursorHold" }, {
      group = buf_group,
      buffer = bufnr,
      callback = function() update_doc_links(bufnr) end,
    })
    update_doc_links(bufnr)
  end,
})

-- 启动时的界面行为。
local group = vim.api.nvim_create_augroup("user_startup_behavior", { clear = true })
local format_group = vim.api.nvim_create_augroup("user_format_on_save", { clear = true })

vim.api.nvim_create_autocmd("VimEnter", {
  group = group,
  once = true,
  callback = function(data)
    local is_dir  = vim.fn.isdirectory(data.file) == 1
    local is_file = data.file ~= "" and not is_dir and vim.fn.filereadable(data.file) == 1

    if is_dir then
      -- nvim <dir>：进入目录并打开文件树
      vim.cmd.cd(data.file)
      vim.cmd.enew()
      vim.cmd("Neotree show filesystem left")
    elseif is_file then
      -- nvim <file>：只编辑文件，关掉可能被 session 带回的文件树
      vim.schedule(function()
        pcall(vim.cmd, "Neotree close")
      end)
    end
  end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  group = format_group,
  pattern = { "*.c", "*.h", "*.cpp", "*.hpp", "*.cc", "*.lua", "*.py" },
  callback = function(args)
    local ok, conform = pcall(require, "conform")
    if not ok then
      return
    end

    conform.format({
      bufnr = args.buf,
      async = false,
      lsp_format = "fallback",
      timeout_ms = 2000,
    })
  end,
})
