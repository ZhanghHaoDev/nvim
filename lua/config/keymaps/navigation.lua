local map = vim.keymap.set

local function telescope_builtin(name, opts)
  return function()
    require("telescope.builtin")[name](opts or {})
  end
end

local function get_visual_selection()
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")
  local start_line = start_pos[2]
  local start_col = start_pos[3] - 1
  local end_line = end_pos[2]
  local end_col = end_pos[3]

  if start_line == 0 or end_line == 0 then
    return ""
  end

  if start_line > end_line or (start_line == end_line and start_col > end_col) then
    start_line, end_line = end_line, start_line
    start_col, end_col = end_col - 1, start_col + 1
  end

  local lines = vim.api.nvim_buf_get_text(0, start_line - 1, start_col, end_line - 1, end_col, {})
  local text = table.concat(lines, " ")
  return vim.trim(text:gsub("%s+", " "))
end

local function grep_string(search)
  if not search or search == "" then
    return
  end

  require("telescope.builtin").grep_string({
    search = search,
    use_regex = false,
  })
end

local function goto_listed_buffer(index)
  local listed_buffers = vim.fn.getbufinfo({ buflisted = 1 })
  local target = listed_buffers[index]

  if not target then
    return
  end

  vim.api.nvim_set_current_buf(target.bufnr)
end

local function open_search_replace(search)
  local ext = vim.bo.buftype == "" and vim.fn.expand("%:e") or ""
  require("grug-far").open({
    transient = true,
    prefills = {
      search = search,
      filesFilter = ext ~= "" and "*." .. ext or nil,
    },
  })
end

map("n", "<leader>e", "<cmd>Neotree toggle<cr>", { desc = "切换文件树" })
map("n", "<leader><leader>", telescope_builtin("commands"), { desc = "命令面板" })
map("n", "<leader>ff", telescope_builtin("find_files", { hidden = true }), { desc = "查找文件" })
map("n", "<leader>fG", telescope_builtin("git_files", { show_untracked = true }), { desc = "Git 文件" })
map("n", "<leader>fg", telescope_builtin("live_grep"), { desc = "全文搜索" })
map("n", "<leader>fw", function()
  grep_string(vim.fn.expand("<cword>"))
end, { desc = "搜索当前单词" })
map("x", "<leader>fw", function()
  grep_string(get_visual_selection())
end, { desc = "搜索选中文本" })
map("n", "<leader>fb", telescope_builtin("buffers"), { desc = "查找缓冲区" })
map("n", "<leader>fr", telescope_builtin("oldfiles", { only_cwd = true }), { desc = "最近文件" })
map("n", "<leader>fR", telescope_builtin("oldfiles"), { desc = "全部最近文件" })
map("n", "<leader>fh", telescope_builtin("help_tags"), { desc = "帮助文档" })
map("n", "<leader>fk", telescope_builtin("keymaps"), { desc = "快捷键列表" })
map("n", "<leader>fd", telescope_builtin("diagnostics"), { desc = "诊断搜索" })
map("n", "<leader>f.", telescope_builtin("resume"), { desc = "恢复上次搜索" })
map("n", "<leader>/", telescope_builtin("current_buffer_fuzzy_find"), { desc = "当前文件搜索" })
map("n", "<leader>fs", telescope_builtin("lsp_dynamic_workspace_symbols"), { desc = "工作区符号" })
map("n", "<leader>fS", telescope_builtin("lsp_document_symbols"), { desc = "当前文件符号" })
map("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "查找 TODO" })
map("n", "<leader>sr", function()
  open_search_replace(vim.fn.expand("<cword>"))
end, { desc = "搜索并替换当前单词" })
map("x", "<leader>sr", function()
  open_search_replace(get_visual_selection())
end, { desc = "搜索并替换选中文本" })
map("n", "<leader>oo", "<cmd>AerialToggle!<cr>", { desc = "切换文件大纲" })
map("n", "<leader>of", "<cmd>AerialNavToggle<cr>", { desc = "切换大纲导航" })
map("n", "<leader>os", "<cmd>AerialOpen<cr>", { desc = "打开文件大纲" })
map("n", "<leader>ot", "<cmd>Telescope aerial<cr>", { desc = "当前文件符号面板" })
map("n", "<leader>uC", "<cmd>TSContext toggle<cr>", { desc = "切换粘滞滚动" })
map("n", "[C", function()
  require("treesitter-context").go_to_context(vim.v.count1)
end, { silent = true, desc = "跳到上级上下文" })
map("n", "[s", "<cmd>AerialPrev<cr>", { desc = "上一个符号" })
map("n", "]s", "<cmd>AerialNext<cr>", { desc = "下一个符号" })
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "切换到上一个标签" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "切换到下一个标签" })

map("n", "]q", "<cmd>cnext<cr>",  { desc = "下一个构建错误" })
map("n", "[q", "<cmd>cprev<cr>",  { desc = "上一个构建错误" })
map("n", "<leader>xq", "<cmd>copen<cr>", { desc = "打开构建错误列表" })
map("n", "<leader>bd", function()
  require("mini.bufremove").delete(0, false)
end, { desc = "关闭当前缓冲区" })
map("n", "<leader>bo", function()
  local current = vim.api.nvim_get_current_buf()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if buf ~= current and vim.bo[buf].buflisted then
      require("mini.bufremove").delete(buf, false)
    end
  end
end, { desc = "关闭其他缓冲区" })

for i = 1, 9 do
  map("n", "<leader>" .. i, function()
    goto_listed_buffer(i)
  end, { desc = "跳到标签 " .. i })
end
