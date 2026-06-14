return {
    {
        -- 顶部标签栏改为 buffer 视图，并对齐 kitty 的 powerline/slanted 风格。
        "nanozuki/tabby.nvim",
        event = "VimEnter",
        init = function()
            vim.o.showtabline = 2
            _G.UserTabbyCloseBuffer = function(bufnr, clicks, button, modifiers)
                if clicks ~= 1 or button ~= "l" or (modifiers ~= nil and modifiers:match("[^ ]")) then
                    return
                end

                require("mini.bufremove").delete(bufnr, false)
            end
        end,
        opts = function()
            local palette = {
                fill = { fg = "#545c7e", bg = "#15161e" },
                active = { fg = "#16161e", bg = "#7aa2f7" },
                inactive = { fg = "#545c7e", bg = "#292e42" },
            }

            local function fallback_buf_name(bufid)
                local name = vim.api.nvim_buf_get_name(bufid)

                if name ~= "" then
                    return vim.fn.fnamemodify(name, ":t")
                end

                return vim.bo[bufid].filetype ~= "" and vim.bo[bufid].filetype or "[No Name]"
            end

            local function modified_mark(buf)
                return buf.is_changed() and " ●" or ""
            end

            local function close_button(bufid)
                return string.format("%%%d@v:lua.UserTabbyCloseBuffer@󰅖%%X", bufid)
            end

            return {
                option = {
                    buf_name = {
                        mode = "tail",
                        name_fallback = fallback_buf_name,
                    },
                },
                line = function(line)
                    local current = vim.api.nvim_get_current_buf()

                    return {
                        line.bufs().foreach(function(buf)
                            local hl = buf.id == current and palette.active or palette.inactive

                            return {
                                line.sep("", hl, palette.fill),
                                " ",
                                buf.name(),
                                modified_mark(buf),
                                " ",
                                { close_button(buf.id), hl = hl },
                                " ",
                                line.sep("", hl, palette.fill),
                                hl = hl,
                            }
                        end),
                        hl = palette.fill,
                    }
                end,
            }
        end,
        config = function(_, opts)
            require("tabby").setup(opts)
        end,
    },
}
