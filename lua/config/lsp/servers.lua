local utils = require("config.lsp.utils")
local config_utils = require("config.utils")
local clangd_bin = config_utils.preferred_executable("llvm", "clangd")
if clangd_bin == "" then
    clangd_bin = "/usr/bin/clangd"
end

return {
    autotools_ls = {
        filetypes = { "automake", "make", "makefile" },
    },
    bashls = {
        filetypes = { "bash", "sh", "zsh" },
    },
    clangd = {
        filetypes = { "c", "cpp", "objc", "objcpp" },
        cmd = {
            clangd_bin,
            "--background-index",
            "--clang-tidy",
            "--completion-style=detailed",
            "--header-insertion=iwyu",
        },
        root_dir = utils.clangd_root_dir,
        single_file_support = true,
        on_new_config = function(new_config, root_dir)
            local compile_commands_dir = utils.find_compile_commands_dir(root_dir)
            if not compile_commands_dir then
                return
            end

            local cmd = vim.deepcopy(new_config.cmd or {})
            for _, arg in ipairs(cmd) do
                if vim.startswith(arg, "--compile-commands-dir=") then
                    return
                end
            end

            table.insert(cmd, "--compile-commands-dir=" .. compile_commands_dir)
            new_config.cmd = cmd
        end,
        init_options = {
            clangdFileStatus = true,
            usePlaceholders = true,
            completeUnimported = true,
            semanticHighlighting = true,
        },
    },
    cmake = {
        filetypes = { "cmake" },
    },
    jsonls = {
        filetypes = { "json", "jsonc" },
    },
    lua_ls = {
        filetypes = { "lua" },
        settings = {
            Lua = {
                diagnostics = { globals = { "vim" } },
                workspace = { checkThirdParty = false },
                telemetry = { enable = false },
            },
        },
    },
    marksman = {
        filetypes = { "markdown" },
    },
    pyright = {
        filetypes = { "python" },
    },
    yamlls = {
        filetypes = { "yaml" },
    },
}
