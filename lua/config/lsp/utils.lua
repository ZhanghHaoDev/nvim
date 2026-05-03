local M = {}

local util = require("lspconfig.util")

function M.find_compile_commands_dir(root_dir)
  if not root_dir or root_dir == "" then
    return nil
  end

  local candidates = {
    root_dir,
    util.path.join(root_dir, "build"),
    util.path.join(root_dir, "Build"),
    util.path.join(root_dir, "cmake-build-debug"),
    util.path.join(root_dir, "cmake-build-release"),
    util.path.join(root_dir, "cmake-build-relwithdebinfo"),
    util.path.join(root_dir, "out"),
    util.path.join(root_dir, "out", "build"),
  }

  for _, candidate in ipairs(candidates) do
    local compile_commands = util.path.join(candidate, "compile_commands.json")
    if vim.uv.fs_stat(compile_commands) then
      return candidate
    end
  end

  return nil
end

function M.clangd_root_dir(bufnr, on_dir)
  local fname = vim.api.nvim_buf_get_name(bufnr)
  if fname == "" then
    on_dir(nil)
    return
  end

  local root = util.root_pattern("compile_commands.json", "compile_flags.txt", ".clangd")(fname)
  if root then
    on_dir(root)
    return
  end

  root = util.root_pattern("CMakeLists.txt", "Makefile", "configure.ac", "configure.in", ".git")(fname)
  if root then
    on_dir(root)
    return
  end

  on_dir(util.path.dirname(fname))
end

function M.enable_inlay_hints(client, bufnr)
  if not vim.lsp.inlay_hint then
    return
  end

  if client.server_capabilities.inlayHintProvider then
    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
  end
end

return M
