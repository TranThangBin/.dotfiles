require("lazydev").setup({
    debug = false,
    runtime = vim.env.VIMRUNTIME,
    library = { path = "${3rd}/luv/library", words = { "vim%.uv" } },
    integrations = { lspconfig = true, cmp = true, coq = false },
    enabled = function(root_dir)
        return (vim.g.lazydev_enabled == nil or vim.g.lazydev_enabled)
            and not vim.uv.fs_stat(root_dir .. "/.luarc.json")
    end,
})
