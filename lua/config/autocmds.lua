-- 启动行为：根据启动参数决定是否打开文件树。
local group = vim.api.nvim_create_augroup("user_startup", { clear = true })

vim.api.nvim_create_autocmd("VimEnter", {
    group = group,
    once = true,
    callback = function(data)
        local is_dir = vim.fn.isdirectory(data.file) == 1
        local is_file = data.file ~= "" and not is_dir and vim.fn.filereadable(data.file) == 1

        if is_dir then
            vim.cmd.cd(data.file)
            vim.cmd.enew()
            vim.cmd("Neotree show filesystem left")
        elseif is_file then
            vim.schedule(function()
                pcall(vim.cmd, "Neotree close")
            end)
        end
    end,
})
