vim.pack.add {
    "https://github.com/stevearc/oil.nvim", -- file manager

    "https://github.com/neovim/nvim-lspconfig",

    { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },

    -- theme
    { src = "https://github.com/rose-pine/neovim",                name = "rose-pine", },
    "https://github.com/xiyaowong/transparent.nvim",

    -- git
    "https://github.com/NeogitOrg/neogit",
    "https://github.com/esmuellert/codediff.nvim",

    "https://github.com/nvim-lua/plenary.nvim", -- required by Neogit

    -- good
    "https://github.com/nvim-mini/mini.nvim",

    -- Completion
    "https://github.com/saghen/blink.lib",
    "https://github.com/saghen/blink.cmp",

    -- can help
    "https://github.com/folke/which-key.nvim",
    "https://github.com/folke/todo-comments.nvim",

    "https://github.com/dmtrKovalenko/fff",
}

-- idk why i really need this but its recommended by fff
vim.api.nvim_create_autocmd('PackChanged', {
    callback = function(ev)
        local name, kind = ev.data.spec.name, ev.data.kind
        if name == 'fff' and (kind == 'install' or kind == 'update') then
            if not ev.data.active then vim.cmd.packadd('fff') end
            require('fff.download').download_or_build_binary()
        end
    end,
})
