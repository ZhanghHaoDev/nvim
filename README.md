# Neovim 使用指南

> macOS · Ghostty · lazy.nvim · 以 C++ 开发为核心

## 目录

- [配置目录结构](#配置目录结构)
- [插件总览](#插件总览)
- [LSP 服务器](#lsp-服务器)
- [快捷键速查](#快捷键速查)
- [C++ 完整工作流](#c-完整工作流)
- [补全系统](#补全系统)
- [常用命令](#常用命令)

---

## 安装

```bash
# 安装 Neovim
brew install nvim

# 安装迷你地图依赖
brew install code-minimap

# 克隆本配置
git clone https://github.com/ZhanghHaoDev/nvim ~/.config/nvim
```

> 显示文件图标需要安装 [Nerd Font](https://www.nerdfonts.com/) 字体。

---

## 配置目录结构

```
~/.config/nvim/
├── init.lua                        # 入口：设置 leader，检测安全模式，调用 config
├── safe.lua                        # 顶层安全模式入口（NVIM_SAFE_MODE=1 时由 shell 直接指定）
├── README.md                       # 本文档
└── lua/
    ├── config/                     # 核心配置层（不依赖任何插件）
    │   ├── init.lua                # 配置主入口，按顺序加载 editor/keymaps/ui/behavior/lazy
    │   ├── editor.lua              # 设置 $EDITOR/$GIT_EDITOR 等环境变量，加载 options
    │   ├── options.lua             # 所有 vim.opt.* 设置：行号、缩进、搜索、折叠、标尺等
    │   ├── keymaps.lua             # 快捷键入口，按功能分发到子模块
    │   ├── keymaps/
    │   │   ├── core.lua            # 通用操作：保存、退出、清高亮、which-key、通知历史
    │   │   ├── editing.lua         # 编辑操作：折叠、行移动、flash 跳转、文档注释生成
    │   │   ├── navigation.lua      # 导航：文件树、telescope 搜索、buffer 管理、quickfix
    │   │   ├── lsp.lua             # LSP：跳转定义/引用、代码操作、重命名、诊断、调用链
    │   │   ├── git.lua             # Git：LazyGit、Diffview、文件历史、浏览器打开
    │   │   └── mouse.lua           # 鼠标行为：双击高亮当前词并搜索
    │   ├── ui.lua                  # UI 配置入口，加载 diagnostics
    │   ├── diagnostics.lua         # 诊断显示：虚拟文本格式、行号符号、undercurl 颜色
    │   ├── behavior.lua            # 行为配置入口，加载 autocmds
    │   ├── autocmds.lua            # 自动命令：启动时检测参数，目录→打开文件树，文件→关闭文件树
    │   ├── lazy.lua                # lazy.nvim 自动引导 + 插件 spec 注册
    │   ├── safe.lua                # 安全模式最小配置：仅加载 options 和 core keymaps
    │   ├── utils.lua               # 工具函数：Homebrew 路径查找、preferred_executable（LLVM 优先）
    │   └── lsp/
    │       ├── init.lua            # LSP 主逻辑：按 FileType 懒启动服务器、inlay hints
    │       ├── servers.lua         # 各语言服务器的 cmd/filetypes/settings 配置
    │       └── utils.lua           # LSP 工具：compile_commands.json 查找、clangd root_dir 检测
    └── plugins/
        └── specs/                  # 插件规格文件（lazy.nvim spec，按职责拆分）
            ├── core.lua            # 基础依赖：plenary、bigfile（大文件保护）
            ├── editor.lua          # 编辑增强：treesitter、conform、ufo 折叠等
            ├── coding.lua          # 补全系统：blink.cmp、LuaSnip、friendly-snippets 等
            ├── lsp.lua             # LSP 插件：mason、nvim-lspconfig、clangd_extensions 等
            ├── navigation.lua      # 导航插件：neo-tree、aerial、flash
            ├── search.lua          # 搜索插件：telescope、grug-far
            ├── git.lua             # Git 插件：gitsigns、lazygit、diffview
            └── ui/
                ├── init.lua        # UI 插件汇总入口
                ├── theme.lua       # 配色方案
                ├── statusline.lua  # 状态栏（lualine）
                ├── tabby.lua       # 标签栏（tabby.nvim）
                ├── misc.lua        # 杂项 UI：which-key、scrollbar、hlslens、devicons
                ├── notifications.lua # 通知系统（nvim-notify）
                └── dashboard.lua   # 项目根目录管理（project.nvim）
```

### 启动顺序

```
init.lua
  └─ config.init
       ├─ config.editor      →  $EDITOR 环境变量 + options.lua
       ├─ config.keymaps     →  keymaps/{core,editing,mouse,navigation,lsp,git}.lua
       ├─ config.ui          →  diagnostics.lua
       ├─ config.behavior    →  autocmds.lua
       └─ config.lazy        →  lazy.nvim 引导 + plugins/specs/* 加载
```

### 安全模式

排查启动问题时，使用安全模式可跳过所有插件和复杂配置：

```bash
NVIM_SAFE_MODE=1 nvim
```

安全模式只加载 `options.lua` 和 `keymaps/core.lua`，其余全部跳过。

---

## 插件总览

### 编辑器基础

| 插件 | 作用 |
|------|------|
| `nvim-treesitter` | 语法树 parser，驱动高亮、折叠、粘滞滚动 |
| `nvim-treesitter-context` | 粘滞滚动：顶部固定显示当前 namespace/class/function/struct |
| `nvim-ufo` | 代码折叠（LSP + Treesitter 双来源） |
| `indent-blankline` | 缩进参考线 + 当前作用域高亮 |
| `rainbow-delimiters` | 彩虹括号 |
| `nvim-autopairs` | 自动补全括号/引号 |
| `Comment.nvim` | `gcc` 注释当前行，`gc` + motion 注释区域 |
| `vim-illuminate` | 高亮当前光标下词的所有引用 |
| `nvim-surround` | 添加/替换/删除成对符号 |
| `vim-repeat` | `.` 重复支持插件操作 |
| `mini.ai` | 增强文本对象（函数、类、参数等） |
| `flash.nvim` | 屏幕内快速跳转 |
| `conform.nvim` | 保存时自动格式化 |
| `todo-comments` | 高亮 TODO / FIXME / NOTE / HACK / WARN |

### LSP & 补全

| 插件 | 作用 |
|------|------|
| `nvim-lspconfig` | LSP 核心配置 |
| `mason.nvim` | LSP / 工具安装器界面 |
| `mason-lspconfig` | 自动安装语言服务器 |
| `clangd_extensions` | C++ 专属：类型层级、AST、内联 hints |
| `blink.cmp` | 自动补全（Rust 实现，低延迟） |
| `LuaSnip` + `friendly-snippets` | Snippet 引擎 |
| `neogen` | 生成函数/类文档注释骨架 |
| `trouble.nvim` | 项目级诊断面板 |
| `lazydev.nvim` | Lua 配置文件专用 LSP 加速 |

### 导航 & 搜索

| 插件 | 作用 |
|------|------|
| `neo-tree` | 左侧文件树（不跟随 cwd，独立） |
| `telescope` + `fzf-native` | 模糊搜索（文件/内容/符号） |
| `aerial.nvim` | 代码大纲（LSP 文档符号） |
| `grug-far` | 跨文件搜索替换 |
| `project.nvim` | 自动检测项目根目录，统一 cwd |

### Git

| 插件 | 作用 |
|------|------|
| `gitsigns` | 行号旁显示 Git 增删改标记 |
| `lazygit.nvim` | 浮窗内打开 LazyGit |
| `diffview.nvim` | 文件 diff 和历史视图 |

### C++ 构建

| 插件 | 作用 |
|------|------|
| `cmake-tools` | CMake 项目管理，生成 `compile_commands.json` |
| `overseer` | 任务运行器，构建输出到 quickfix |

### UI

| 插件 | 作用 |
|------|------|
| `lualine` | 状态栏 |
| `tabby` | 标签栏 |
| `nvim-scrollbar` | 右侧滚动条 + 诊断标记 |
| `nvim-hlslens` | 搜索结果计数显示 |
| `which-key` | 快捷键提示面板 |
| `nvim-notify` | 通知弹窗 |
| `snacks.nvim` | 终端、草稿 buffer、Git 浏览器、平滑滚动 |
| `persistence.nvim` | Session 持久化，重启后恢复工作区 |
| `mini.bufremove` | 安全关闭 buffer |

---

## LSP 服务器

| 服务器 | 语言 | 安装方式 |
|--------|------|----------|
| `clangd` | C / C++ | 系统 LLVM（`/opt/homebrew/opt/llvm/bin/clangd`） |
| `pyright` | Python | Mason |
| `lua_ls` | Lua | Mason |
| `bashls` | Bash / Sh / Zsh | Mason |
| `cmake` | CMake | Mason |
| `jsonls` | JSON | Mason |
| `yamlls` | YAML | Mason |
| `marksman` | Markdown | Mason |
| `autotools_ls` | Makefile | Mason |

> clangd 启用了 `--background-index`、`--clang-tidy`、`--header-insertion=iwyu`，
> 需要项目根目录有 `compile_commands.json` 才能完整工作。

---

## 快捷键速查

> `<leader>` = 空格键

### 全局

| 键 | 说明 |
|----|------|
| `<leader>?` | 显示所有快捷键（which-key） |
| `<leader>h` | 清除搜索高亮 |
| `<leader>w` | 保存文件 |
| `<leader>q` | 退出当前窗口 |
| `<leader>un` | 查看通知历史 |

### 文件 & Buffer

| 键 | 说明 |
|----|------|
| `<leader>e` | 切换文件树 |
| `<S-h>` / `<S-l>` | 上 / 下一个 buffer |
| `<leader>bd` | 关闭当前 buffer |
| `<leader>bo` | 关闭其他所有 buffer |
| `<leader>1` ~ `<leader>9` | 直接跳转到第 N 个 buffer |
| `<leader>bs` | 打开草稿 buffer |

### 搜索 & 导航

| 键 | 模式 | 说明 |
|----|------|------|
| `<leader><leader>` | n | 命令面板 |
| `<leader>ff` | n | 查找文件（含隐藏文件） |
| `<leader>fg` | n | 全文搜索（ripgrep） |
| `<leader>fw` | n/x | 搜索光标下单词 / 选中文本 |
| `<leader>fb` | n | 切换已打开的 buffer |
| `<leader>fr` | n | 最近使用文件 |
| `<leader>/` | n | 在当前文件内模糊搜索 |
| `<leader>fs` | n | 搜索工作区符号（LSP） |
| `<leader>oo` | n | 切换代码大纲 |
| `s` | n/x/o | Flash 快速跳转 |

### 搜索替换

| 键 | 模式 | 说明 |
|----|------|------|
| `<leader>sr` | n | 替换光标下单词（当前文件类型） |
| `<leader>sr` | x | 替换选中文本（全项目） |

### LSP 跳转

| 键 | 说明 |
|----|------|
| `gd` | 跳转到定义 |
| `gD` | 跳转到声明 |
| `gi` | 跳转到实现 |
| `gr` | 查看所有引用 |
| `K` | 悬浮文档 |

### 代码操作（`<leader>c`）

| 键 | 说明 |
|----|------|
| `<leader>ca` | 代码操作（Code Action） |
| `<leader>cf` | 手动格式化当前文件 |
| `<leader>cr` | 重命名符号 |
| `<leader>ch` | 切换 .h / .cpp（仅 C++） |
| `<leader>ci` | 查看调用我的函数（Incoming） |
| `<leader>co` | 查看我调用的函数（Outgoing） |
| `<leader>cT` | 类型层级（仅 C++） |
| `<leader>cA` | 查看 AST（仅 C++） |
| `<leader>cM` | clangd 内存用量（仅 C++） |

### 诊断（`<leader>x`）

| 键 | 说明 |
|----|------|
| `<leader>xx` | 浮窗查看当前行错误详情 |
| `<leader>xd` | 当前文件所有问题（Trouble） |
| `<leader>xw` | 全项目问题（Trouble） |
| `<leader>xq` | 构建错误列表（quickfix） |
| `]d` / `[d` | 跳转到下 / 上一个诊断 |
| `]q` / `[q` | 跳转到下 / 上一个构建错误 |

### Git（`<leader>g`）

| 键 | 说明 |
|----|------|
| `<leader>gg` | 打开 LazyGit 浮窗 |
| `<leader>gD` | 打开 Diffview |
| `<leader>gh` | 当前文件 Git 历史 |
| `<leader>go` | 在浏览器打开当前文件（GitHub） |

### CMake（`<leader>m`）

| 键 | 说明 |
|----|------|
| `<leader>mg` | CMake Configure |
| `<leader>mb` | CMake Build |
| `<leader>mr` | CMake Run |
| `<leader>mt` | 选择 Build Target |
| `<leader>ml` | 选择 Run Target |
| `<leader>mo` | 切换构建输出面板 |

### 编辑

| 键 | 模式 | 说明 |
|----|------|------|
| `zR` | n | 展开所有折叠 |
| `zM` | n | 折叠所有 |
| `<leader>cn` | n | 生成文档注释 |
| `<A-j>` / `<A-k>` | n/x | 移动行 / 选区上下 |

### nvim-surround

| 操作 | 说明 | 示例 |
|------|------|------|
| `ysiw"` | 给单词加 `"` | `word` → `"word"` |
| `ys$"` | 给行尾加 `"` | |
| `cs"'` | 把 `"` 换成 `'` | `"word"` → `'word'` |
| `ds"` | 删除 `"` | `"word"` → `word` |
| `ysa)` | 给括号内容加 `()` | |

### mini.ai 文本对象

可用于 `v`, `d`, `c`, `y` 等操作，`i` = inner，`a` = around：

| 对象 | 说明 |
|------|------|
| `af` / `if` | 函数（含/不含签名） |
| `ac` / `ic` | 类 |
| `aa` / `ia` | 函数参数 |
| `a"` / `i"` | 双引号字符串 |
| `a(` / `i(` | 括号内容 |
| `a[` / `i[` | 方括号内容 |

### UI 开关（`<leader>u`）

| 键 | 说明 |
|----|------|
| `<leader>uh` | 切换 Inlay Hints |
| `<leader>us` | 切换拼写检查 |
| `<leader>uw` | 切换自动换行 |

### 终端

| 键 | 说明 |
|----|------|
| `<C-\>` | 切换悬浮终端（n/t 模式均有效） |

---

## C++ 完整工作流

### 1. 新建项目

```bash
mkdir my_project && cd my_project
# 创建 CMakeLists.txt
```

打开 nvim → `<leader>mg`（CMake Configure）  
生成 `build/compile_commands.json` 后，在项目根目录创建软链接供 clangd 使用：

```bash
ln -s build/compile_commands.json compile_commands.json
```

### 2. 编写代码

- 保存自动触发 `clang-format` 格式化
- `K` 查看函数文档 / 类型信息
- `gd` 跳转到定义，`gr` 查看所有引用
- `<leader>ch` 在 `.h` 和 `.cpp` 之间切换
- 头文件中的 `#include` 路径有下划线 = clangd 已解析到该文件
- Inlay hints 实时显示参数名和类型推断

### 3. 构建 & 错误修复

- `<leader>mb` 构建
- `<leader>mo` 查看构建输出
- `]q` / `[q` 在构建错误间跳转
- `<leader>xd` 查看当前文件所有 LSP 诊断

### 4. 重构

- `<leader>cr` 全局重命名符号
- `<leader>ci` / `<leader>co` 查看调用链
- `<leader>cT` 查看类型继承层级
- `<leader>sr` 批量文本替换（跨文件）

### 5. Git

- `<leader>gg` → LazyGit 处理提交 / 分支 / stash
- `<leader>gD` → Diffview 查看变更
- `<leader>gh` → 当前文件的修改历史

---

## 补全系统

使用 `blink.cmp`（Rust 实现，比 nvim-cmp 延迟更低）：

| 键 | 说明 |
|----|------|
| `<C-n>` / `<C-p>` | 下 / 上一个候选 |
| `<CR>` | 接受当前候选 |
| `<C-space>` | 手动触发补全 |
| `<C-e>` | 关闭补全 |

补全来源优先级：LSP → 路径 → Snippet → Buffer

---

## 常用命令

| 命令 | 说明 |
|------|------|
| `:Mason` | 打开 LSP / 工具安装器 |
| `:MasonUpdate` | 更新所有已安装工具 |
| `:Lazy` | 打开插件管理器 |
| `:Lazy update` | 更新所有插件 |
| `:TSInstall <lang>` | 安装 Treesitter parser |
| `:TSUpdate` | 更新已安装的 parser |
| `:LspInfo` | 查看当前 buffer 的 LSP 状态 |
| `:LspRestart` | 重启当前 LSP |
| `:Notifications` | 查看通知历史 |
| `:Neotree` | 打开文件树 |
| `:AerialToggle` | 切换代码大纲 |
| `:CMakeGenerate` | CMake Configure |
| `:CMakeBuild` | CMake Build |
| `:OverseerToggle` | 切换构建输出面板 |
| `:DiffviewOpen` | 打开 Diffview |
