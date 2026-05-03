# nvim

个人 Neovim 配置，基于 [lazy.nvim](https://github.com/folke/lazy.nvim) 插件管理器。

## 简介

Neovim 是 Vim 编辑器的现代化分支，具备更好的性能、可扩展性和用户体验。本配置面向 C/C++ 开发，集成 LSP、Git、文件树等常用功能。

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

## 卸载

```bash
# 删除配置
rm -rf ~/.config/nvim

# 卸载 Neovim
brew uninstall nvim
```

## 功能特性

| 功能 | 说明 |
|------|------|
| 文件树 | 右侧文件树，支持文件图标 |
| 迷你地图 | 左侧自动启动，显示当前位置，高亮选中行 |
| 标签页 | 显示图标，`Tab` / `F1` / `F2` 切换 |
| LSP | C/C++ clangd/cmake 代码补全、`gd` 跳转声明 |
| Git | 行内新增/删除/修改标记，`:LazyGit` 打开 |
| 终端 | `Ctrl+T` 打开内置终端 |
| 分屏 | 鼠标拖动支持 |
| 状态栏 | 橘黄色主题 |

## 快捷键

| 快捷键 | 功能 |
|--------|------|
| `w` | 保存全部文件 |
| `q` | 退出当前页面 / 文件树 |
| `Tab` / `F1` / `F2` | 切换标签页 |
| `gd` | 跳转到声明 |
| `Ctrl+T` | 打开终端 |

## 目录结构

```
~/.config/nvim/
├── init.lua              # 入口
├── lazy-lock.json        # 插件版本锁定
└── lua/
    ├── config/           # 核心配置（选项、快捷键、LSP 等）
    └── plugins/          # 插件规格定义
```

## 插件管理

本配置使用 [lazy.nvim](https://github.com/folke/lazy.nvim) 管理插件。

```vim
:Lazy          " 打开插件管理界面
:Lazy update   " 更新所有插件
:Lazy sync     " 同步插件
```
