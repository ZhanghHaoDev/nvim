-- Luacheck 配置:格式宽度交给 stylua,这里只查逻辑问题。
std = "luajit"
cache = true

max_line_length = false

read_globals = {
    "vim",
    "Snacks",
}

ignore = {
    "212", -- 未使用的参数(回调里常见,如 on_attach 的 _)
}
