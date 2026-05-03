local specs = {}

vim.list_extend(specs, require("plugins.specs.ui.misc"))
vim.list_extend(specs, require("plugins.specs.ui.statusline"))
vim.list_extend(specs, require("plugins.specs.ui.tabby"))
vim.list_extend(specs, require("plugins.specs.ui.theme"))
vim.list_extend(specs, require("plugins.specs.ui.notifications"))
vim.list_extend(specs, require("plugins.specs.ui.dashboard"))

return specs
