-- 编辑器基础能力：先固定子进程可见的编辑器环境，再加载基础选项。
local nvim_path = vim.fn.exepath("nvim")
if nvim_path ~= "" then
    vim.env.EDITOR = nvim_path
    vim.env.VISUAL = nvim_path
    vim.env.GIT_EDITOR = nvim_path
    vim.env.GIT_SEQUENCE_EDITOR = nvim_path
end

require("config.options")

return true
