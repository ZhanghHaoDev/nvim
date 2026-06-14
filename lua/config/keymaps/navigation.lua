local map = vim.keymap.set

local function telescope(name, opts)
    return function()
        require("telescope.builtin")[name](opts or {})
    end
end

local function goto_listed_buffer(index)
    local bufs = vim.fn.getbufinfo({ buflisted = 1 })
    if bufs[index] then
        vim.api.nvim_set_current_buf(bufs[index].bufnr)
    end
end

local function visual_selection()
    local s = vim.fn.getpos("'<")
    local e = vim.fn.getpos("'>")
    local sl, sc, el, ec = s[2], s[3] - 1, e[2], e[3]
    if sl == 0 or el == 0 then
        return ""
    end
    local lines = vim.api.nvim_buf_get_text(0, sl - 1, sc, el - 1, ec, {})
    return vim.trim(table.concat(lines, " "):gsub("%s+", " "))
end

-- 文件树
map("n", "<leader>e", "<cmd>Neotree toggle<cr>", { desc = "文件树" })

-- 查找
map("n", "<leader><leader>", telescope("commands"), { desc = "命令面板" })
map("n", "<leader>ff", telescope("find_files", { hidden = true }), { desc = "查找文件" })
map("n", "<leader>fg", telescope("live_grep"), { desc = "全文搜索" })
map("n", "<leader>fw", function()
    require("telescope.builtin").grep_string({ search = vim.fn.expand("<cword>"), use_regex = false })
end, { desc = "搜索当前单词" })
map("x", "<leader>fw", function()
    require("telescope.builtin").grep_string({ search = visual_selection(), use_regex = false })
end, { desc = "搜索选中文本" })
map("n", "<leader>fb", telescope("buffers"), { desc = "切换 buffer" })
map("n", "<leader>fr", telescope("oldfiles", { only_cwd = true }), { desc = "最近文件" })
map("n", "<leader>/", telescope("current_buffer_fuzzy_find"), { desc = "当前文件搜索" })
map("n", "<leader>fs", telescope("lsp_dynamic_workspace_symbols"), { desc = "工作区符号" })

-- 搜索替换
map("n", "<leader>sr", function()
    require("grug-far").open({
        transient = true,
        prefills = {
            search = vim.fn.expand("<cword>"),
            filesFilter = vim.bo.buftype == "" and ("*." .. vim.fn.expand("%:e")) or nil,
        },
    })
end, { desc = "替换当前单词" })
map("x", "<leader>sr", function()
    require("grug-far").open({ transient = true, prefills = { search = visual_selection() } })
end, { desc = "替换选中文本" })

-- 大纲
map("n", "<leader>oo", "<cmd>AerialToggle!<cr>", { desc = "大纲" })

-- Buffer 管理
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "上一个 buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "下一个 buffer" })
map("n", "<leader>bd", function()
    require("mini.bufremove").delete(0, false)
end, { desc = "关闭 buffer" })
map("n", "<leader>bo", function()
    local cur = vim.api.nvim_get_current_buf()
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if buf ~= cur and vim.bo[buf].buflisted then
            require("mini.bufremove").delete(buf, false)
        end
    end
end, { desc = "关闭其他 buffer" })
for i = 1, 9 do
    map("n", "<leader>" .. i, function()
        goto_listed_buffer(i)
    end, { desc = "buffer " .. i })
end

-- 构建错误跳转
map("n", "]q", "<cmd>cnext<cr>", { desc = "下一个构建错误" })
map("n", "[q", "<cmd>cprev<cr>", { desc = "上一个构建错误" })
map("n", "<leader>xq", "<cmd>copen<cr>", { desc = "构建错误列表" })
