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
