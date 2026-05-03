-- 安全模式只加载最小可用配置，便于排查启动问题。
require("config.options")
require("config.keymaps.core")

return true