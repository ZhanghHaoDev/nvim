local _lsp_progress = "" -- LspProgress 事件写入，lsp_status() 读取

return {
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        opts = function()
            local c = {
                bg = "#1a1b26",
                surface = "#24283b",
                overlay = "#292e42",
                text = "#c0caf5",
                subtle = "#a9b1d6",
                muted = "#565f89",
                dark = "#1a1b26",
                blue = "#7aa2f7",
                cyan = "#7dcfff",
                green = "#9ece6a",
                purple = "#bb9af7",
                orange = "#ff9e64",
                red = "#f7768e",
                yellow = "#e0af68",
            }

            local mode_info = {
                n = { "󰋜", "NORMAL", c.blue },
                i = { "󰏫", "INSERT", c.green },
                v = { "󰒅", "VISUAL", c.purple },
                V = { "󰒅", "V-LINE", c.purple },
                s = { "󰒆", "SELECT", c.purple },
                S = { "󰒆", "S-LINE", c.purple },
                R = { "󰛔", "REPLACE", c.red },
                c = { "󰘳", "COMMAND", c.yellow },
                t = { "󰆍", "TERM", c.cyan },
                r = { "󰘳", "PROMPT", c.yellow },
                ["!"] = { "󰆍", "SHELL", c.cyan },
                ["r?"] = { "󰘳", "CONFIRM", c.yellow },
            }
            for _, alias in ipairs({ "no", "nt", "niI", "niR", "niV" }) do
                mode_info[alias] = mode_info.n
            end
            for _, alias in ipairs({ "ic", "ix" }) do
                mode_info[alias] = mode_info.i
            end
            for _, alias in ipairs({ "vs" }) do
                mode_info[alias] = mode_info.v
            end
            for _, alias in ipairs({ "Vs" }) do
                mode_info[alias] = mode_info.V
            end
            for _, alias in ipairs({ "Rc", "Rv", "Rvx", "Rvc", "Rx" }) do
                mode_info[alias] = mode_info.R
            end
            for _, alias in ipairs({ "cv", "ce" }) do
                mode_info[alias] = mode_info.c
            end
            for _, alias in ipairs({ "rm" }) do
                mode_info[alias] = mode_info.r
            end
            mode_info["\22"] = { "󰒅", "V-BLOCK", c.purple }
            mode_info["\22s"] = mode_info["\22"]
            mode_info["\19"] = { "󰒆", "S-BLOCK", c.purple }

            local function get_mode()
                return mode_info[vim.api.nvim_get_mode().mode] or { "󰋜", "NORMAL", c.blue }
            end
            local function mode_label()
                local m = get_mode()
                return m[1] .. "  " .. m[2]
            end
            local function mode_color()
                local m = get_mode()
                return { fg = c.dark, bg = m[3], gui = "bold" }
            end

            -- LSP 客户端名称或索引进度（诊断已独立到 diagnostics 组件）。
            local function lsp_status()
                local clients = vim.lsp.get_clients({ bufnr = 0 })
                if #clients == 0 then
                    return "󱏖 offline"
                end

                if _lsp_progress ~= "" then
                    return "󰒋 " .. _lsp_progress
                end

                local names = {}
                for _, cl in ipairs(clients) do
                    if cl.name ~= "null-ls" and cl.name ~= "copilot" then
                        names[#names + 1] = cl.name
                    end
                end
                table.sort(names)
                if #names == 0 then
                    return ""
                end
                return "󰒋 " .. (#names == 1 and names[1] or names[1] .. " +" .. (#names - 1))
            end

            -- 缩进模式：空格显示宽度，Tab 显示 tabstop。
            local function indent_info()
                return vim.bo.expandtab and ("󱁐 " .. vim.bo.shiftwidth) or ("⇥ " .. vim.bo.tabstop)
            end

            local b_hl = { fg = c.text, bg = "#1f2335" }
            local c_hl = { fg = c.subtle, bg = c.surface }

            local theme = {
                normal = { a = { fg = c.dark, bg = c.blue, gui = "bold" }, b = b_hl, c = c_hl },
                insert = { a = { fg = c.dark, bg = c.green, gui = "bold" }, b = b_hl, c = c_hl },
                visual = { a = { fg = c.dark, bg = c.purple, gui = "bold" }, b = b_hl, c = c_hl },
                replace = { a = { fg = c.dark, bg = c.red, gui = "bold" }, b = b_hl, c = c_hl },
                command = { a = { fg = c.dark, bg = c.yellow, gui = "bold" }, b = b_hl, c = c_hl },
                terminal = { a = { fg = c.dark, bg = c.cyan, gui = "bold" }, b = b_hl, c = c_hl },
                inactive = {
                    a = { fg = c.muted, bg = c.surface },
                    b = { fg = c.muted, bg = c.surface },
                    c = { fg = c.muted, bg = c.bg },
                },
            }

            return {
                options = {
                    theme = theme,
                    globalstatus = true,
                    component_separators = { left = "│", right = "│" },
                    section_separators = { left = "", right = "" },
                    refresh = { statusline = 120, tabline = 1000, winbar = 1000 },
                },
                sections = {
                    lualine_a = {
                        { mode_label, color = mode_color, padding = { left = 1, right = 1 } },
                    },
                    lualine_b = {
                        {
                            "branch",
                            icon = "",
                            color = { fg = c.orange, gui = "bold" },
                            padding = { left = 1, right = 0 },
                        },
                        {
                            "diff",
                            symbols = { added = "  ", modified = "  ", removed = "  " },
                            padding = { left = 1, right = 1 },
                        },
                    },
                    lualine_c = {},
                    lualine_x = {
                        -- 诊断：每个级别独立着色。
                        {
                            "diagnostics",
                            sources = { "nvim_lsp" },
                            symbols = { error = " ", warn = " ", hint = "󰌶 ", info = " " },
                            diagnostics_color = {
                                error = { fg = c.red },
                                warn = { fg = c.yellow },
                                info = { fg = c.cyan },
                                hint = { fg = c.green },
                            },
                            padding = { left = 1, right = 1 },
                        },
                        -- LSP 客户端 / 索引进度。
                        {
                            lsp_status,
                            color = function()
                                return #vim.lsp.get_clients({ bufnr = 0 }) > 0 and { fg = c.cyan } or { fg = c.muted }
                            end,
                            padding = { left = 1, right = 2 },
                        },
                    },
                    lualine_y = {
                        {
                            function()
                                return string.format("  %d : %-2d", vim.fn.line("."), vim.fn.col("."))
                            end,
                            padding = { left = 1, right = 0 },
                        },
                        {
                            "progress",
                            fmt = function(s)
                                if s == "Top" then
                                    return "󰞙 TOP"
                                elseif s == "Bot" then
                                    return "󰞛 BOT"
                                else
                                    return "󰔽 " .. s
                                end
                            end,
                            padding = { left = 1, right = 1 },
                        },
                    },
                    -- z：文件类型 → 缩进 → 编码（从"是什么"到"如何存储"）。
                    lualine_z = {
                        {
                            "filetype",
                            colored = true,
                            icon_only = false,
                            fmt = function(ft)
                                return ft ~= "" and ft or "text"
                            end,
                            padding = { left = 1, right = 0 },
                        },
                        { indent_info, padding = { left = 1, right = 0 } },
                        { "encoding", padding = { left = 1, right = 1 } },
                    },
                },
                inactive_sections = {
                    lualine_a = {},
                    lualine_b = {},
                    lualine_c = {},
                    lualine_x = {},
                    lualine_y = {},
                    lualine_z = { { "filetype", padding = { left = 1, right = 1 } } },
                },
                extensions = {
                    {
                        filetypes = { "neo-tree" },
                        sections = {
                            lualine_a = {
                                { mode_label, color = mode_color, padding = { left = 1, right = 1 } },
                            },
                            lualine_c = {
                                {
                                    function()
                                        return "󰉖  " .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
                                    end,
                                    padding = { left = 2 },
                                },
                            },
                        },
                    },
                },
            }
        end,
        config = function(_, opts)
            vim.api.nvim_create_autocmd("LspProgress", {
                group = vim.api.nvim_create_augroup("user_lualine_lsp_progress", { clear = true }),
                callback = function(args)
                    local value = args.data and args.data.params and args.data.params.value
                    if value then
                        if value.kind == "end" then
                            _lsp_progress = ""
                        else
                            local msg = value.title or ""
                            if value.message and value.message ~= "" then
                                msg = msg ~= "" and (msg .. " " .. value.message) or value.message
                            end
                            if value.percentage then
                                msg = string.format("%d%% %s", math.floor(value.percentage), msg)
                            end
                            _lsp_progress = msg
                        end
                    end
                    local ok, lualine = pcall(require, "lualine")
                    if ok then
                        lualine.refresh({ place = { "statusline" } })
                    end
                end,
            })
            require("lualine").setup(opts)
        end,
    },
}
