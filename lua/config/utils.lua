local M = {}

local brew_prefix_cache = {}

local function joinpath(...)
    return table.concat({ ... }, "/")
end

function M.brew_prefix(package)
    if brew_prefix_cache[package] ~= nil then
        return brew_prefix_cache[package] or nil
    end

    local homebrew_prefix = vim.env.HOMEBREW_PREFIX
    if homebrew_prefix and homebrew_prefix ~= "" then
        local candidate = joinpath(homebrew_prefix, "opt", package)
        if vim.uv.fs_stat(candidate) then
            brew_prefix_cache[package] = candidate
            return candidate
        end
    end

    local brew = vim.fn.exepath("brew")
    if brew ~= "" then
        local result = vim.system({ brew, "--prefix", package }, { text = true }):wait()
        local prefix = vim.trim(result.stdout or "")
        if result.code == 0 and prefix ~= "" and vim.uv.fs_stat(prefix) then
            brew_prefix_cache[package] = prefix
            return prefix
        end
    end

    brew_prefix_cache[package] = false
    return nil
end

function M.homebrew_bin(package, executable)
    local prefix = M.brew_prefix(package)
    if prefix then
        local candidate = joinpath(prefix, "bin", executable)
        if vim.uv.fs_stat(candidate) then
            return candidate
        end
    end

    return nil
end

function M.preferred_executable(package, executable)
    return M.homebrew_bin(package, executable) or vim.fn.exepath(executable)
end

return M
