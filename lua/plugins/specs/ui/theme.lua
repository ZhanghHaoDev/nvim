return {
  {
    -- 主题插件。
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("tokyonight").setup({
        style = "night",
        transparent = false,
        terminal_colors = true,
        on_colors = function(colors)
          colors.git = {
            add = "#3bd671",
            change = "#4ea1ff",
            delete = "#ff5f6d",
          }

          colors.diff = {
            add = "#16382b",
            delete = "#3f1d25",
            change = "#162c4a",
            text = "#275d9a",
          }
        end,
        on_highlights = function(highlights, colors)
          highlights.GitSignsAdd = { fg = colors.git.add, bg = colors.bg }
          highlights.GitSignsChange = { fg = colors.git.change, bg = colors.bg }
          highlights.GitSignsDelete = { fg = colors.git.delete, bg = colors.bg }
          highlights.GitSignsTopdelete = { fg = colors.git.delete, bg = colors.bg }
          highlights.GitSignsChangedelete = { fg = colors.git.change, bg = colors.bg }

          highlights.DiffAdd = { bg = colors.diff.add }
          highlights.DiffChange = { bg = colors.diff.change }
          highlights.DiffDelete = { bg = colors.diff.delete }
          highlights.DiffText = { bg = colors.diff.text }
          highlights.Visual = { fg = colors.fg, bg = "#33467c", bold = true }
          highlights.Search = { bg = "#1e3a5c", sp = "#7aa2f7", underdotted = true }
          highlights.CurSearch = { bg = "#2d4f80", sp = "#ff9e64", bold = true, underline = true }
          highlights.IncSearch = { bg = "#2a2a4a", sp = "#c6a0f6", underdotted = true }
          highlights.IlluminatedWordText = { bg = "#2d3f73", bold = true }
          highlights.IlluminatedWordRead = { bg = "#2f4f67", bold = true }
          highlights.IlluminatedWordWrite = { bg = "#5a345f", bold = true }
          highlights.MatchParen = { fg = colors.bg, bg = colors.orange, bold = true }
          highlights.ColorColumn = { bg = "#1e2030" }
        end,
        styles = {
          comments = { italic = false },
          keywords = { italic = false },
          sidebars = "dark",
          floats = "dark",
        },
      })

      vim.cmd.colorscheme("tokyonight")
    end,
  },
}
