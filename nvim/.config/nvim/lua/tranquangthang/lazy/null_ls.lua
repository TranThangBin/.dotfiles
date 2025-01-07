return {
	"jay-babu/mason-null-ls.nvim",

	event = { "BufReadPre", "BufNewFile" },

	dependencies = {
		"williamboman/mason.nvim",
		{
			"nvimtools/none-ls.nvim",
			opts = function()
				local null_ls = require("null-ls")
				return {
					sources = {
						null_ls.builtins.formatting.gdformat,
						null_ls.builtins.diagnostics.gdlint,
					},
					border = "rounded",
				}
			end,
			config = true,
		},
	},

	opts = function()
		local null_ls = require("null-ls")
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
