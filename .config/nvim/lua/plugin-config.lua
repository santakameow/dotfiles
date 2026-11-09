require("oil").setup {
    default_file_explorer = true,
    columns = {
        "permissions",
        "size",
        "mtime",
        "icon",
    },

    view_options = {
        show_hidden = true,
    },

    lsp_file_methods = {
        enabled = true,
        autosave_changes = true,
        timeout_ms = 1000,
    },
}

require("neogit").setup()

require("blink.cmp").setup {
    keymap = { preset = "default" },
    fuzzy = { implementation = "prefer_rust" },
    sources = { default = { "lsp", "path", "snippets", "buffer" } },
    completion = { documentation = { auto_show = true } },
}


require("which-key").setup {
    delay = 0,
    icons = { mappings = vim.g.have_nerd_font },
    -- Document existing key chains
    spec = {
        { '<leader>f', group = 'Find' },
        { '<leader>g', group = 'Git' },
        { '<leader>l', group = 'LSP and diagnostics' },
        { 'gr',        group = 'LSP Actions', mode = { 'n' } },
    },
}

require("todo-comments").setup {}

require("mini.icons").setup()
MiniIcons.mock_nvim_web_devicons()

require("mini.statusline").setup { use_icons = true }

require("mini.diff").setup()

require("mini.pairs").setup()

-- setup fff
require("fff").setup {
    lazy_sync = true,
    prompt = '$ ',
    prompt_vim_mode = true,
    enable_home_dir_scanning = false,

}

require("transparent").setup {}

vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("UserTreesitter", { clear = true }),
    callback = function(event)
        -- Files without an installed parser keep their regular syntax highlighting.
        pcall(vim.treesitter.start, event.buf)
    end,
})

vim.cmd.colorscheme "rose-pine-moon"

