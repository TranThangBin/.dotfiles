vim.diagnostic.config({
    virtual_text = true,
    severity_sort = true,
    float = {
        style = "minimal",
        border = "rounded",
        source = true,
        header = "",
        prefix = "",
    },
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "✘",
            [vim.diagnostic.severity.WARN] = "▲",
            [vim.diagnostic.severity.HINT] = "⚑",
            [vim.diagnostic.severity.INFO] = "»",
        },
    },
})

vim.lsp.enable({
    "bashls",
    "clangd",
    "cssls",
    "docker_language_server",
    "emmet_language_server",
    "emmylua_ls",
    "fish_lsp",
    "gdscript",
    "gopls",
    "html",
    "hyprls",
    "jsonls",
    "nil_ls",
    "pyright",
    "qmlls",
    "roslyn",
    "ruff",
    "rust_analyzer",
    "tailwindcss",
    "taplo",
    "templ",
    "ts_ls",
    "yamlls",
    "zls",
})

local lsp_group = vim.api.nvim_create_augroup("custom/lsp", { clear = true })

vim.api.nvim_create_autocmd("LspAttach", {
    group = lsp_group,
    desc = "Custom: Lsp keymapping",
    callback = function(e)
        local ok, telescope_builtin = pcall(require, "telescope.builtin")

        local set = vim.keymap.set

        local lsp_definitions = vim.lsp.buf.definition
        local lsp_references = vim.lsp.buf.references
        local lsp_workspace_symbols = vim.lsp.buf.workspace_symbol
        local lsp_document_symbols = vim.lsp.buf.document_symbol

        if ok then
            lsp_definitions = telescope_builtin.lsp_definitions
            lsp_references = telescope_builtin.lsp_references
            lsp_workspace_symbols = telescope_builtin.lsp_workspace_symbols
            lsp_document_symbols = telescope_builtin.lsp_document_symbols
        end

        set("n", "gd", function()
            lsp_definitions()
        end, { buffer = e.buf })
        set("n", "grr", function()
            lsp_references()
        end, { buffer = e.buf })
        set("n", "gws", function()
            lsp_workspace_symbols()
        end, { buffer = e.buf })
        set("n", "gO", function()
            lsp_document_symbols()
        end, { buffer = e.buf })
        set({ "n", "i" }, "<C-s>", function()
            vim.lsp.buf.signature_help({ wrap = false })
        end, { buffer = e.buf })
    end,
})
