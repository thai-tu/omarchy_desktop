return {
    {
        "bjarneo/aether.nvim",
        name = "aether",
        priority = 1000,
        opts = {
            disable_italics = false,
            colors = {
                -- Monotone shades (base00-base07)
                base00 = "#0B151C", -- Default background
                base01 = "#6c8ba1", -- Lighter background (status bars)
                base02 = "#0B151C", -- Selection background
                base03 = "#6c8ba1", -- Comments, invisibles
                base04 = "#CDA59D", -- Dark foreground
                base05 = "#eddcd9", -- Default foreground
                base06 = "#eddcd9", -- Light foreground
                base07 = "#CDA59D", -- Light background

                -- Accent colors (base08-base0F)
                base08 = "#CB7B83", -- Variables, errors, red
                base09 = "#e7bbbf", -- Integers, constants, orange
                base0A = "#c4838d", -- Classes, types, yellow
                base0B = "#66C6A9", -- Strings, green
                base0C = "#93dbe1", -- Support, regex, cyan
                base0D = "#97a0bf", -- Functions, keywords, blue
                base0E = "#bea5c0", -- Keywords, storage, magenta
                base0F = "#e3c0c5", -- Deprecated, brown/yellow
            },
        },
        config = function(_, opts)
            require("aether").setup(opts)
            vim.cmd.colorscheme("aether")

            -- Enable hot reload
            require("aether.hotreload").setup()
        end,
    },
    {
        "LazyVim/LazyVim",
        opts = {
            colorscheme = "aether",
        },
    },
}
