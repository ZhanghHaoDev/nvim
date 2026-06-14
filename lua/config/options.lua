-- 基础显示设置。
vim.opt.encoding = "utf-8"
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.cursorline = true
-- 常用模式下统一使用竖线光标。
vim.opt.guicursor = "n-v-c-sm-i-ci-ve-r-cr-o:ver25"
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.list = true
vim.opt.listchars = {
    tab = "> ",
    trail = ".",
    nbsp = "+",
    extends = ">",
    precedes = "<",
}

-- 缩进规则：4 空格，不保留真实 Tab。
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.smartindent = true

-- 搜索体验：默认忽略大小写，带大写时自动区分。
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.hlsearch = true

-- 标尺：80 软提示，120 硬上限。
vim.opt.colorcolumn = "80,120"
vim.opt.textwidth = 0

-- 分屏和滚动体验。
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.wrap = false
vim.opt.scrolloff = 6
vim.opt.sidescrolloff = 8
vim.opt.foldcolumn = "1"
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true

-- 关闭备份和交换文件，保留撤销历史。
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.undofile = true

-- 安全：禁用 modelines，防止文件末尾嵌入恶意配置。
vim.opt.modelines = 0

-- Ghostty undercurl 支持。
vim.cmd([[let &t_Cs = "\e[4:3m"]])
vim.cmd([[let &t_Ce = "\e[4:0m"]])
