-- 设置主快捷键和本地快捷键前缀。
vim.g.mapleader = " "
vim.g.maplocalleader = ","

local startup_errors = {}

local function safe_require(module)
    local ok, result = pcall(require, module)
    if ok then
        return result
    end

    table.insert(startup_errors, string.format("%s: %s", module, result))
    return nil
end

if vim.env.NVIM_SAFE_MODE == "1" then
    safe_require("config.safe")

    vim.schedule(function()
        vim.notify(
            "NVIM_SAFE_MODE=1: 已跳过插件和大部分配置，使用安全模式启动",
            vim.log.levels.WARN
        )
    end)

    return
end

-- 启动入口保持精简，具体装配在 config.init 中完成。
safe_require("config")

if #startup_errors > 0 then
    vim.schedule(function()
        vim.notify(table.concat(startup_errors, "\n"), vim.log.levels.ERROR, { title = "Neovim 启动配置错误" })
    end)
end
