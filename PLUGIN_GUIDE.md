# Neovim 配置与插件总览

更新时间：2026-04-03

## 1. 当前结论

- 空启动约 28ms。
- 打开普通 Lua 文件约 43ms。
- 打开约 4MB 的合成大文件约 64ms。
- 当前性能已经不差，真正值得补的是大文件保护和前置加载热点，而不是继续过度拆插件。

## 2. 配置结构

- init.lua：唯一入口，负责安全加载 config。
- lua/config/init.lua：高层装配入口。
- lua/config/options.lua：基础选项。
- lua/config/keymaps.lua：键位入口，再分发到 core、editing、navigation、lsp、git。
- lua/config/behavior.lua：运行时行为入口。
- lua/config/autocmds.lua：自动命令。
- lua/config/lazy.lua：lazy.nvim 引导与插件 spec 导入。
- lua/config/lsp/*.lua：LSP 注册、server 列表、clangd 工具函数。
- lua/plugins/specs/*.lua：按领域拆分插件规格。
- lua/plugins/specs/ui/*.lua：UI 规格已进一步拆成目录，分别收纳状态栏、主题、消息、启动页等。
- lua/plugins/specs/git.lua：Git 交互插件，当前承载 lazygit 集成。

## 3. 结构评估

- 目前的高层结构是清晰的，入口、配置、插件 spec 已经分层。
- 之前最大的结构热点是单文件 UI 规格；现在已拆成 lua/plugins/specs/ui/ 目录，职责更清晰。
- 这类整理对维护收益明显，但不直接等于性能收益。
- 当前更优先的改进项应该是：大文件模式、文档补齐、按需维护插件边界。

## 4. 插件清单

### 核心基础

- nvim-lua/plenary.nvim：常用 Lua 工具库，很多插件依赖它。
- LunarVim/bigfile.nvim：大文件保护，针对超大文件禁用高开销特性。

### UI 与反馈

- lua/plugins/specs/ui/misc.lua：图标、which-key、滚动条。
- lua/plugins/specs/ui/statusline.lua：lualine 与状态栏辅助函数。
- lua/plugins/specs/ui/bufferline.lua：bufferline 与右上角 buffer 统计。
- lua/plugins/specs/ui/theme.lua：Tokyo Night 主题与高亮覆写。
- lua/plugins/specs/ui/notifications.lua：notify 与 noice。
- lua/plugins/specs/ui/dashboard.lua：alpha 启动页。

- nvim-tree/nvim-web-devicons：文件图标。
- folke/which-key.nvim：快捷键提示。
- nvim-lualine/lualine.nvim：状态栏。
- akinsho/bufferline.nvim：顶部 buffer 标签栏。
- folke/tokyonight.nvim：主题。
- rcarriga/nvim-notify：通知弹窗。
- folke/noice.nvim：命令行、消息、LSP UI 增强。
- goolord/alpha-nvim：启动页。

### 导航与浏览

- nvim-neo-tree/neo-tree.nvim：文件树。
- stevearc/aerial.nvim：文档符号大纲。
- folke/flash.nvim：屏幕内快速跳转。

### Git

- kdheepak/lazygit.nvim：在 Neovim 中直接打开 lazygit 浮窗。

### 搜索

- nvim-telescope/telescope.nvim：查找文件、全文搜索、buffers、symbols。
- nvim-telescope/telescope-fzf-native.nvim：Telescope 原生 FZF 排序加速。

### 编辑体验

- echasnovski/mini.bufremove：安全删除 buffer。
- windwp/nvim-autopairs：自动补全括号引号。
- numToStr/Comment.nvim：注释。
- stevearc/conform.nvim：统一格式化入口。
- nvim-treesitter/nvim-treesitter：语法树高亮与增量选择。
- nvim-treesitter/nvim-treesitter-context：粘滞滚动，在顶部固定当前函数/类上下文。
- lukas-reineke/indent-blankline.nvim：缩进线与当前作用域高亮。
- kevinhwang91/nvim-ufo：折叠增强。
- kevinhwang91/promise-async：ufo 依赖。
- HiPhish/rainbow-delimiters.nvim：括号层级高亮。
- folke/todo-comments.nvim：TODO/FIXME 高亮。

### 代码与补全

- danymat/neogen：文档注释生成。
- hrsh7th/nvim-cmp：补全主框架。
- L3MON4D3/LuaSnip：片段引擎。
- saadparwaiz1/cmp_luasnip：LuaSnip 补全源。
- hrsh7th/cmp-nvim-lsp：LSP 补全源。
- hrsh7th/cmp-buffer：buffer 补全源。
- hrsh7th/cmp-cmdline：命令行补全源。
- hrsh7th/cmp-path：路径补全源。
- rafamadriz/friendly-snippets：通用片段库。

### LSP 与诊断

- williamboman/mason.nvim：语言工具安装器。
- williamboman/mason-lspconfig.nvim：LSP 安装桥接。
- WhoIsSethDaniel/mason-tool-installer.nvim：格式化器/工具安装器。
- neovim/nvim-lspconfig：LSP 主配置。
- folke/trouble.nvim：诊断、引用、符号问题面板。

## 5. 插件加载策略概览

- 启动即加载：plenary.nvim、bigfile.nvim、tokyonight.nvim、nvim-lspconfig。
- 命令触发：neo-tree、telescope、mason、trouble、neogen。
- 命令触发：neo-tree、telescope、mason、trouble、neogen、lazygit.nvim。
- 插入模式触发：nvim-cmp、nvim-autopairs。
- 打开文件后触发：treesitter、treesitter-context、ibl、ufo、Comment、rainbow-delimiters、todo-comments、aerial。
- VeryLazy：which-key、lualine、bufferline、notify、noice、flash、mason-lspconfig、mason-tool-installer。

## 6. 性能检查结论

### 启动速度

- 空启动已足够快，不建议为了 5 到 10ms 的收益过度改造结构。
- 当前启动耗时主要集中在 require("config.lazy")，这属于 lazy.nvim 和插件规格解析成本。
- 大文件保护插件会带来少量启动常驻成本，但换回了更稳的大文件路径。

### 打开普通文件

- 当前普通文件打开速度已经比较健康。
- 主要耗时来自打开文件后按需加载的 Treesitter、treesitter-context、ibl、ufo、rainbow-delimiters 等界面增强插件。

### 打开大型文件

- 这是当前最值得专门优化的路径。
- 已接入 bigfile.nvim，阈值为 2 MiB。
- 超过阈值后会主动关闭：indent_blankline、LSP、Treesitter、syntax、matchparen、部分影响速度的 vim 选项。
- 另外已把 LSP 键位改为按调用时再触发 vim.lsp，并把 mason-lspconfig 延后到 VeryLazy，普通文件打开路径有明显收益。

## 7. 结构优化建议

### 现在值得保留的结构

- config 与 plugins/specs 的分层已经合理。
- LSP 相关单独拆分是正确方向。
- keymaps 再分文件也合理。

### 现在最值得继续优化的地方

- 把 lua/plugins/specs/ui.lua 再拆成 statusline、appearance、notifications、startup 四块。
- 把现有状态报告与插件文档收敛，避免多份文档互相过时。
- 对大型文件和特殊文件类型建立统一策略，而不是分散在多个插件里单独处理。

## 8. 推荐的下一步

1. 再跑一次真实项目中的大文件验证，确认 bigfile.nvim 的阈值是否要从 2 MiB 调整到 1 MiB 或 4 MiB。
2. 如果后续继续扩展 UI，优先拆分 lua/plugins/specs/ui.lua，而不是再往里面追加配置。
3. 如果想进一步减轻打开文件时的加载量，可以考虑把 aerial.nvim 改成命令/键位触发，而不是 BufReadPost 即加载。