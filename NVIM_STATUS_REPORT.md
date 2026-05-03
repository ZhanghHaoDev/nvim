# Neovim 配置状态报告

> 这份报告是 2026-03-28 的历史快照，当前配置与插件清单请优先参考 PLUGIN_GUIDE.md。

生成时间：2026-03-28

## 1. 总体状态

- Neovim 版本：0.11.6
- 配置类型：纯 lazy.nvim 自定义配置，不是 AstroNvim，也不是 LazyVim
- 主配置入口：init.lua
- 配置目录：~/.config/nvim
- 插件目录：~/.local/share/nvim/lazy
- Mason 包目录：~/.local/share/nvim/mason/packages
- 当前主题：tokyonight-night
- 当前状态：配置可正常加载，headless 启动无报错

## 2. 配置结构

当前配置是模块化组织，入口和职责如下：

- init.lua
  - 负责加载基础模块
- lua/config/options.lua
  - 基础编辑器选项
- lua/config/keymaps.lua
  - 快捷键定义
- lua/config/diagnostics.lua
  - 诊断显示样式
- lua/config/autocmds.lua
  - 自动命令，例如目录启动时自动打开文件树
- lua/config/lazy.lua
  - lazy.nvim 引导加载
- lua/plugins/init.lua
  - 所有插件声明和大部分功能配置

## 3. 当前基础行为

### 显示与编辑

- 绝对行号开启
- 相对行号关闭
- 当前行高亮开启
- 光标为竖线样式
- 支持鼠标
- 启用系统剪贴板
- 关闭换行
- 分屏默认向右、向下打开
- 使用 4 空格缩进
- 不保留 swap、backup、writebackup
- 保留 undofile

### 搜索体验

- 默认忽略大小写
- 搜索词里出现大写时自动区分大小写
- 增量搜索开启
- 搜索高亮开启

## 4. 界面与插件状态

### 已安装插件

当前已安装的插件目录如下：

- LuaSnip
- alpha-nvim
- bufferline.nvim
- cmp-buffer
- cmp-nvim-lsp
- cmp-path
- cmp_luasnip
- friendly-snippets
- gitsigns.nvim
- lazy.nvim
- lualine.nvim
- mason-lspconfig.nvim
- mason-tool-installer.nvim
- mason.nvim
- mini.bufremove
- neo-tree.nvim
- nui.nvim
- nvim-autopairs
- nvim-cmp
- nvim-lspconfig
- nvim-notify
- nvim-treesitter
- nvim-web-devicons
- plenary.nvim
- rainbow-delimiters.nvim
- telescope-fzf-native.nvim
- telescope.nvim
- todo-comments.nvim
- tokyonight.nvim
- which-key.nvim

### 界面功能概览

- 文件树：neo-tree
  - 打开目录时自动显示左侧文件树
- 顶部标签栏：bufferline
  - 支持编号、未保存圆点、鼠标中键关闭
- 状态栏：lualine
  - 当前显示内容：当前目录/文件名、Git 分支、LSP 状态、位置、百分比、文件类型、编码
- 启动页：alpha-nvim
- 快捷键提示：which-key
- 通知弹窗：nvim-notify
- Git 行内标记：gitsigns
- 彩虹括号：rainbow-delimiters
- TODO 高亮：todo-comments
- 自动补全括号：nvim-autopairs

## 5. LSP 状态

### 配置中启用的语言服务器

在配置里启用了以下 LSP：

- bashls
- clangd
- cmake
- jsonls
- lua_ls
- marksman
- pyright
- autotools_ls
- yamlls

### 当前和你需求直接相关的常用语言支持

- C / C++：clangd
- CMake：cmake
- Make / Makefile：autotools_ls
- Python：pyright
- Lua：lua_ls

### 已安装的 Mason 包

当前 Mason 包目录里已有：

- autotools-language-server
- bash-language-server
- clang-format
- clangd
- cmake-language-server
- json-lsp
- lua-language-server
- marksman
- pyright
- stylua
- yaml-language-server

### LSP 配置特点

- 使用的是 Neovim 0.11 原生方式：vim.lsp.config() + vim.lsp.enable()
- clangd 已额外开启：
  - background index
  - clang-tidy
  - detailed completion
  - header insertion
- clangd 已补充项目根识别和编译数据库检测：
  - 优先识别 compile_commands.json、compile_flags.txt、.clangd
  - 其次识别 CMakeLists.txt、Makefile、configure.ac、configure.in、.git
  - 会自动检测常见构建目录中的 compile_commands.json
  - 已覆盖 build、Build、cmake-build-debug、cmake-build-release、cmake-build-relwithdebinfo、out、out/build
- lualine 状态栏会显示当前 buffer 已附着的 LSP 名称

## 6. 补全与代码体验

当前补全链路：

- nvim-cmp：补全主框架
- cmp-nvim-lsp：LSP 补全源
- cmp-buffer：当前缓冲区补全
- cmp-path：路径补全
- LuaSnip：代码片段
- friendly-snippets：通用片段库

当前插入模式补全行为：

- Ctrl+Space：手动触发补全
- Enter：确认补全
- Tab：下一个候选 / 展开片段
- Shift+Tab：上一个候选 / 反向跳片段

## 7. 常用快捷键摘要

### 文件与搜索

- Space e：切换文件树
- Space ff：查找文件
- Space fg：全文搜索
- Space fb：查找缓冲区
- Space ft：查找 TODO

### 标签与缓冲区

- Shift+h：上一个标签
- Shift+l：下一个标签
- Space bd：关闭当前标签
- Space 1 到 Space 9：跳转到指定标签

### LSP 与诊断

- gd：跳转定义
- gr：查看引用
- K：查看悬浮文档
- Space rn：重命名
- Space ca：代码操作
- Space f：格式化当前文件
- Space xx：查看当前位置错误
- [d：上一个诊断
- ]d：下一个诊断

### Git

- Space gb：查看当前行 blame
- Space gd：查看 diff
- Space gp：预览 hunk
- Space gr：重置 hunk

### 其他

- Space h：清除搜索高亮
- Space w：保存
- Space q：退出当前窗口
- Space un：查看通知历史

## 8. 当前优点

- 配置结构清晰，只有一个插件总入口，易维护
- UI 已经比较完整，接近日常 IDE 使用体验
- C/C++、CMake、Python、Lua 都已接入 LSP
- Makefile 也已经补上基础语言服务支持
- 启动目录时自动显示文件树，适合项目浏览
- 标签关闭逻辑已经处理过，不会再轻易导致整个 nvim 一起退出

## 9. 当前已知问题或注意点

- Make 的语言服务生态本身不如 clangd、pyright、lua_ls 成熟，所以体验会弱一些
- Linux kernel 这类没有 compile_commands.json 的工程，clangd 仍会退回 fallback 解析，诊断精度不如标准 CMake 项目
- Treesitter 目前是轻量启用，没有再加更深的高亮和文本对象扩展
- diagnostics.lua 里仍然使用 sign_define，未来版本可能继续提示弃用警告，但当前不影响使用
- 目前没有统一自动保存或保存时自动格式化逻辑，格式化仍以手动触发为主

## 10. 建议的下一步

如果继续完善，这几个方向最值得做：

1. 增加保存时自动格式化，至少给 C/C++、Lua、Python 开启
2. 针对 Linux kernel 这类非 CMake 工程，补 clangd 的 compile_flags.txt 或专门生成编译数据库
3. 补 Treesitter 的高亮和增量选择配置
4. 给 Makefile、CMake、Python 分别做真实文件附着验证，确认每种语言都能看到 LSP
5. 把 diagnostics 的旧 sign 定义方式改成新版写法，去掉潜在弃用告警
6. 给各语言补自动格式化和更细的 formatter 区分

## 11. 结论

你现在这套 Neovim 已经不是“刚能用”的状态，而是一套完整、可日常开发的 lazy.nvim 配置：

- 有文件树
- 有标签栏
- 有状态栏
- 有启动页
- 有 Git
- 有通知
- 有 TODO 高亮
- 有彩虹括号
- 有补全
- 有常用语言 LSP

对你当前这类 C/C++ 和工程类项目场景来说，已经可以直接作为主力编辑器使用。