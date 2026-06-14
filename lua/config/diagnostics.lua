-- 统一配置 LSP 诊断的显示方式。
vim.diagnostic.config({
    virtual_text = {
        spacing = 2,
        prefix = "●",
        source = "if_many",
    },
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "E ",
            [vim.diagnostic.severity.WARN] = "W ",
            [vim.diagnostic.severity.HINT] = "H ",
            [vim.diagnostic.severity.INFO] = "I ",
        },
    },
    underline = true, -- 由下方 hl 覆盖为 undercurl
    update_in_insert = false,
    severity_sort = true,
    float = {
        border = "rounded",
        source = "if_many",
    },
})

vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", { undercurl = true, sp = "#f7768e" })
vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn", { undercurl = true, sp = "#e0af68" })
vim.api.nvim_set_hl(0, "DiagnosticUnderlineInfo", { undercurl = true, sp = "#7dcfff" })
vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint", { undercurl = true, sp = "#9ece6a" })
