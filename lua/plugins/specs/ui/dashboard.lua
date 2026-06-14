return {
    {
        "ahmedkhalf/project.nvim",
        lazy = false,
        main = "project_nvim",
        opts = {
            detection_methods = { "pattern", "lsp" },
            patterns = {
                ".git",
                ".hg",
                "CMakeLists.txt",
                "Makefile",
                "package.json",
                "pyproject.toml",
                "Cargo.toml",
                "go.mod",
            },
            silent_chdir = true,
            show_hidden = false,
        },
        config = function(_, opts)
            require("project_nvim").setup(opts)
            local ok, telescope = pcall(require, "telescope")
            if ok then
                telescope.load_extension("projects")
            end
        end,
    },
}
