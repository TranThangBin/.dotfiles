return {
	"jay-babu/mason-null-ls.nvim",

	event = { "BufReadPre", "BufNewFile" },

	dependencies = {
		"williamboman/mason.nvim",
		{
			"nvimtools/none-ls.nvim",
			opts = {
				debug = true,
				border = "rounded",
			},
			config = true,
		},
	},

	opts = function()
		local null_ls = require("null-ls")
		null_ls.register(null_ls.builtins.formatting.gdformat)
		null_ls.register(null_ls.builtins.diagnostics.gdlint)
		return {
			ensure_installed = { "stylua" },
			handlers = {
				templ = function()
					null_ls.register({
						method = null_ls.methods.FORMATTING,
						name = "templfmt",
						filetypes = { "templ" },
						generator = null_ls.formatter({
							command = "templ",
							args = { "fmt" },
							from_stdin = true,
							to_stdin = true,
						}),
					})
				end,
			},
		}
	end,
}
