local map = vim.keymap.set

local function jump_to_mouse()
    local mouse = vim.fn.getmousepos()
    if mouse.winid and mouse.winid ~= 0 then
        pcall(vim.api.nvim_set_current_win, mouse.winid)
    end
    local line = mouse.line or 1
    local column = math.max((mouse.column or 1) - 1, 0)
    pcall(vim.api.nvim_win_set_cursor, 0, { line, column })
end

map("n", "<2-LeftMouse>", function()
    jump_to_mouse()
    vim.cmd("normal! *N")
end, { desc = "双击高亮同名单词", silent = true })
