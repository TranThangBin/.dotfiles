local null_ls = require("null-ls")

null_ls.setup({
	debug = true,
	border = "rounded",
	sources = {
		null_ls.builtins.formatting.stylua,
		null_ls.builtins.formatting.gdformat,
		null_ls.builtins.diagnostics.gdlint,
		{
			method = null_ls.methods.FORMATTING,
			name = "templfmt",
			filetypes = { "templ" },
			generator = null_ls.formatter({
				command = "templ",
				args = { "fmt" },
				from_stdin = true,
				to_stdin = true,
			}),
		},
	},
})
