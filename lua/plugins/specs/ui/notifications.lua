return {
    {
        "rcarriga/nvim-notify",
        event = "VeryLazy",
        opts = {
            background_colour = "#1a1b26",
            fps = 60,
            on_open = function(win)
                vim.wo[win].winblend = 18
            end,
            render = "wrapped-compact",
            stages = "fade_in_slide_out",
            timeout = 2500,
            top_down = false,
        },
        config = function(_, opts)
            local notify = require("notify")
            notify.setup(opts)
            vim.notify = notify
        end,
    },
}
