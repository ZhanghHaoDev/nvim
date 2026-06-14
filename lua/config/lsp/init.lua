local M = {}

local utils = require("config.lsp.utils")
local servers = require("config.lsp.servers")

local enabled_servers = {}
local pending_servers = {}

local function list_contains(items, target)
    for _, item in ipairs(items or {}) do
        if item == target then
            return true
        end
    end

    return false
end

local function enable_server_for_filetype(server_name, config, filetype)
    if enabled_servers[server_name] or pending_servers[server_name] then
        return
    end

    if not list_contains(config.filetypes, filetype) then
        return
    end

    pending_servers[server_name] = true

    -- 把 LSP 启动延后到调度队列，避免在首个 FileType 阶段阻塞界面打开。
    vim.schedule(function()
        pending_servers[server_name] = nil
        if enabled_servers[server_name] then
            return
        end

        vim.lsp.enable(server_name)
        enabled_servers[server_name] = true
    end)
end

-- 所有浮窗统一圆角边框(hover/signatureHelp 等),替代已弃用的 vim.lsp.with。
vim.o.winborder = "rounded"

-- 头文件识别下划线：clangd 通过 documentLink 标记已解析的 #include 路径。
local doc_link_ns = vim.api.nvim_create_namespace("user_lsp_doc_links")
vim.api.nvim_set_hl(0, "LspDocumentLink", { underline = true, sp = "#7dcfff" })

local function update_doc_links(bufnr)
    local params = { textDocument = vim.lsp.util.make_text_document_params(bufnr) }
    vim.lsp.buf_request(bufnr, "textDocument/documentLink", params, function(err, links)
        if err or not links then
            return
        end
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
        if not client or not client:supports_method("textDocument/documentLink") then
            return
        end
        local bufnr = args.buf
        vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "CursorHold" }, {
            group = vim.api.nvim_create_augroup("user_lsp_doc_links_buf_" .. bufnr, { clear = true }),
            buffer = bufnr,
            callback = function()
                update_doc_links(bufnr)
            end,
        })
        update_doc_links(bufnr)
    end,
})

function M.setup()
    local capabilities = require("blink.cmp").get_lsp_capabilities()
    local group = vim.api.nvim_create_augroup("user_lsp_auto_enable", { clear = true })
    local resolved_servers = {}

    for server, config in pairs(servers) do
        config = vim.deepcopy(config)
        config.capabilities = vim.tbl_deep_extend("force", config.capabilities or {}, capabilities)

        local original_on_attach = config.on_attach
        config.on_attach = function(client, bufnr)
            utils.enable_inlay_hints(client, bufnr)
            if original_on_attach then
                original_on_attach(client, bufnr)
            end
        end

        vim.lsp.config(server, config)
        resolved_servers[server] = config
    end

    vim.api.nvim_create_autocmd("FileType", {
        group = group,
        callback = function(args)
            local filetype = vim.bo[args.buf].filetype
            if filetype == "" then
                return
            end

            for server_name, config in pairs(resolved_servers) do
                enable_server_for_filetype(server_name, config, filetype)
            end
        end,
    })

    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(bufnr) then
            local filetype = vim.bo[bufnr].filetype
            if filetype ~= "" then
                for server_name, config in pairs(resolved_servers) do
                    enable_server_for_filetype(server_name, config, filetype)
                end
            end
        end
    end
end

return M
