return {
  {
    "ahmedkhalf/project.nvim",
    lazy = false,
    main = "project_nvim",
    opts = {
      detection_methods = { "pattern", "lsp" },
      patterns = {
        ".git", ".hg", "package.json", "pyproject.toml",
        "Cargo.toml", "go.mod", "CMakeLists.txt", "Makefile",
      },
      silent_chdir = true,
      show_hidden = false,
    },
    config = function(_, opts)
      require("project_nvim").setup(opts)
      local ok, telescope = pcall(require, "telescope")
      if ok then telescope.load_extension("projects") end
    end,
  },
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons", "ahmedkhalf/project.nvim" },
    config = function()
      local dashboard = require("alpha.themes.dashboard")

      local function get_recent_projects(limit)
        local ok, pnvim = pcall(require, "project_nvim")
        if not ok then return {} end
        local all = pnvim.get_recent_projects()
        local result = {}
        for i = #all, math.max(#all - limit + 1, 1), -1 do
          result[#result + 1] = all[i]
        end
        return result
      end

      local function open_project(path)
        vim.cmd.cd(vim.fn.fnameescape(path))
        require("telescope.builtin").find_files({ cwd = path, hidden = true,
          prompt_title = vim.fn.fnamemodify(path, ":t") })
      end

      vim.api.nvim_set_hl(0, "AlphaHeader",   { fg = "#3d59a1" })
      vim.api.nvim_set_hl(0, "AlphaButtons",  { fg = "#565f89" })
      vim.api.nvim_set_hl(0, "AlphaShortcut", { fg = "#7aa2f7" })
      vim.api.nvim_set_hl(0, "AlphaFooter",   { fg = "#3b4261" })

      dashboard.section.header.val = { "nvim" }
      dashboard.section.header.opts = { position = "center", hl = "AlphaHeader" }

      dashboard.section.buttons.val = {
        dashboard.button("f", "  find file",    ":Telescope find_files<CR>"),
        dashboard.button("r", "  recent files", ":Telescope oldfiles<CR>"),
        dashboard.button("p", "  projects",     ":Telescope projects<CR>"),
        dashboard.button("q", "  quit",         ":qa<CR>"),
      }
      dashboard.section.buttons.opts.hl          = "AlphaButtons"
      dashboard.section.buttons.opts.hl_shortcut = "AlphaShortcut"

      local recent_projects = get_recent_projects(5)

      _G.alpha_open_project = open_project

      local recent_items = {}
      for i, path in ipairs(recent_projects) do
        local name  = vim.fn.fnamemodify(path, ":t")
        local short = vim.fn.fnamemodify(path, ":~")
        recent_items[#recent_items + 1] = dashboard.button(
          tostring(i),
          string.format("  %-20s %s", name, short),
          string.format(":lua _G.alpha_open_project(%q)<CR>", path)
        )
      end

      dashboard.section.recent_projects = {
        type = "group",
        val  = recent_items,
        opts = { spacing = 0 },
      }

      dashboard.section.footer.val = {}

      local layout = {
        { type = "padding", val = math.floor(vim.o.lines * 0.2) },
        dashboard.section.header,
        { type = "padding", val = 2 },
        dashboard.section.buttons,
      }
      if #recent_projects > 0 then
        layout[#layout + 1] = { type = "padding", val = 1 }
        layout[#layout + 1] = dashboard.section.recent_projects
      end

      dashboard.opts.layout = layout
      require("alpha").setup(dashboard.opts)
    end,
  },
}
