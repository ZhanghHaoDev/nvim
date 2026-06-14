return {
    {
        -- 在行号旁显示 Git 增删改标记，并提供 hunk 级操作。
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        opts = {
            signs = {
                add = { text = "│" },
                change = { text = "│" },
                delete = { text = "_" },
                topdelete = { text = "‾" },
                changedelete = { text = "~" },
                untracked = { text = "┆" },
            },
            signcolumn = true,
            numhl = false,
            linehl = false,
            watch_gitdir = {
                follow_files = true,
            },
            current_line_blame = false,
            update_debounce = 100,
        },
    },
    {
        -- 更好的 Git diff 和文件历史视图，与 lazygit 互补。
        "sindrets/diffview.nvim",
        cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {
            enhanced_diff_hl = true,
            view = {
                default = { layout = "diff2_horizontal" },
                file_history = { layout = "diff2_horizontal" },
            },
        },
    },
    {
        -- 在 Neovim 内直接打开 lazygit 浮窗，处理提交、分支和 stash 更高效。
        "kdheepak/lazygit.nvim",
        cmd = {
            "LazyGit",
            "LazyGitConfig",
            "LazyGitCurrentFile",
            "LazyGitFilter",
            "LazyGitFilterCurrentFile",
        },
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        config = function()
            vim.g.lazygit_floating_window_winblend = 0
            vim.g.lazygit_floating_window_scaling_factor = 0.9
            vim.g.lazygit_floating_window_use_plenary = 1
            vim.g.lazygit_floating_window_border_chars = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }
            vim.g.lazygit_use_neovim_remote = 0

            local group = vim.api.nvim_create_augroup("user_lazygit_terminal", { clear = true })

            vim.api.nvim_create_autocmd("FileType", {
                group = group,
                pattern = "lazygit",
                callback = function(args)
                    vim.keymap.set("t", ":q<CR>", function()
                        local job_id = vim.b[args.buf].terminal_job_id
                        if job_id then
                            vim.api.nvim_chan_send(job_id, "q")
                        end
                    end, { buffer = args.buf, silent = true, desc = "退出 LazyGit" })
                end,
            })
        end,
    },
}
