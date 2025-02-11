return {
	"Issafalcon/lsp-overloads.nvim",

	dependencies = {
		"VonHeikemen/lsp-zero.nvim",
		"nvim-telescope/telescope.nvim",
	},

	opts = {
		ui = {
			border = "rounded",
			height = nil,
			width = nil,
			wrap = true,
			wrap_at = nil,
			max_width = nil,
			max_height = nil,
			close_events = { "CursorMoved", "BufHidden", "InsertLeave" },
			focusable = true,
			focus = false,
			offset_x = 0,
			offset_y = 0,
			floating_window_above_cur_line = false,
			silent = true,
			highlight = {
				italic = true,
				bold = true,
				fg = "#ffffff",
				...,
			},
		},
		keymaps = {
			next_signature = "<C-j>",
			previous_signature = "<C-k>",
			next_parameter = "<C-l>",
			previous_parameter = "<C-h>",
			close_signature = "<M-s>",
		},
		display_automatically = false,
	},

	config = function(self)
		require("lsp-zero").on_attach(function(client, bufnr)
			self:on_attach(client, bufnr)
		end)
	end,

	on_attach = function(self, client, bufnr)
		local builtin = require("telescope.builtin")

		vim.keymap.set("n", "gd", builtin.lsp_definitions, { buffer = bufnr })
		vim.keymap.set("n", "gr", builtin.lsp_references, { buffer = bufnr })

		vim.keymap.set(
			"n",
			"<leader>ws",
			builtin.lsp_workspace_symbols,
			{ buffer = bufnr }
		)
		vim.keymap.set(
			"n",
			"<leader>ds",
			builtin.lsp_document_symbols,
			{ buffer = bufnr }
		)
		vim.keymap.set(
			"n",
			"<leader>ca",
			vim.lsp.buf.code_action,
			{ buffer = bufnr }
		)
		vim.keymap.set(
			"n",
			"<leader>rn",
			vim.lsp.buf.rename,
			{ buffer = bufnr }
		)

		vim.keymap.set("n", "K", function()
			vim.lsp.buf.hover({ border = "rounded" })
		end, { buffer = bufnr })
		vim.keymap.set("n", "<leader>vd", function()
			vim.diagnostic.open_float({ border = "rounded" })
		end, { buffer = bufnr })
		vim.keymap.set("n", "]d", function()
			-- vim.diagnostic.jump({ count = 1, float = true })
			vim.diagnostic.goto_next()
		end, { buffer = bufnr })
		vim.keymap.set("n", "[d", function()
			-- vim.diagnostic.jump({ count = -1, float = true })
			vim.diagnostic.goto_prev()
		end, { buffer = bufnr })

		vim.keymap.set("n", "<leader>f", function()
			vim.lsp.buf.format({
				bufnr = bufnr,
				async = true,
				filter = function(cl)
					return (
						vim.lsp.get_clients({
								bufnr = bufnr,
								name = "null-ls",
							})[1]
							== nil
						and cl.name ~= "null-ls"
					) or cl.name == "null-ls"
				end,
			})
		end, { buffer = bufnr })

		if client.supports_method("signatureHelpProvider") then
			require("lsp-overloads").setup(client, self.opts)
			vim.keymap.set(
				{ "n", "i" },
				"<M-s>",
				"<cmd>LspOverloadsSignature<CR>",
				{ buffer = bufnr }
			)
		end
	end,
}
