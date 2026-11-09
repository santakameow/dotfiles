vim.lsp.config("*", {
    capabilities = require("blink.cmp").get_lsp_capabilities(),
})

vim.lsp.config("lua_ls", {
    on_init = function(client)
        local root = client.root_dir
        -- Respect project-specific Lua settings outside this Neovim config.
        if root and root ~= vim.fn.stdpath("config")
            and (vim.uv.fs_stat(root .. "/.luarc.json") or vim.uv.fs_stat(root .. "/.luarc.jsonc")) then
            return
        end

        client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua or {}, {
            runtime = { version = "LuaJIT", path = { "lua/?.lua", "lua/?/init.lua" } },
            diagnostics = { globals = { "vim", "MiniIcons" } },
            workspace = {
                checkThirdParty = false,
                -- Loading the entire runtimepath is expensive and indexes unrelated plugins.
                library = { vim.env.VIMRUNTIME },
            },
        })
    end,
    settings = { Lua = { completion = { callSnippet = "Replace" } } },
})

vim.lsp.config("nixd", {
    settings = { nixd = { formatting = { command = { "nixfmt" } } } },
})

vim.lsp.enable {
    "lua_ls",
    "gopls",
    "clangd",
    "rust_analyzer",
    "ty", -- Python completion, navigation, and type checking
    "ruff", -- Python linting and formatting
    "nixd",
    "vls",
}

-- Use the same formatter selection for manual formatting and format-on-save.
local function format(bufnr, async)
    vim.lsp.buf.format {
        bufnr = bufnr,
        async = async,
        timeout_ms = 3000,
        filter = function(client)
            return client.name ~= "ty"
        end,
    }
end

vim.api.nvim_create_autocmd("BufWritePre", {
    group = vim.api.nvim_create_augroup("UserFormatOnSave", { clear = true }),
    callback = function(event)
        if vim.bo[event.buf].buftype ~= "" then
            return
        end
        for _, client in ipairs(vim.lsp.get_clients { bufnr = event.buf }) do
            if client.name ~= "ty" and client:supports_method("textDocument/formatting", event.buf) then
                format(event.buf, false)
                return
            end
        end
    end,
})

vim.diagnostic.config {
    severity_sort = true,
    float = { border = "rounded", source = true },
    underline = true,
    signs = true,
    virtual_text = { spacing = 2, source = "if_many" },
    update_in_insert = false,
}

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspKeymaps", { clear = true }),
    callback = function(event)
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client.name == "ruff" then
            -- Let ty provide Python hover information.
            client.server_capabilities.hoverProvider = false
        end

        local function map(key, action, desc)
            vim.keymap.set("n", key, action, { buffer = event.buf, desc = desc })
        end
        map("gd", vim.lsp.buf.definition, "Go to definition")
        map("grr", vim.lsp.buf.references, "LSP references")
        map("gri", vim.lsp.buf.implementation, "LSP implementation")
        map("K", vim.lsp.buf.hover, "LSP hover")
        map("<leader>rn", vim.lsp.buf.rename, "LSP rename")
        map("<leader>ca", vim.lsp.buf.code_action, "LSP code action")
        map("<leader>lf", function() format(event.buf, true) end, "LSP format")
    end,
})

vim.keymap.set("n", "<leader>ld", vim.diagnostic.open_float, { desc = "Line diagnostics" })
vim.keymap.set("n", "<leader>ll", vim.diagnostic.setloclist, { desc = "Diagnostics list" })
