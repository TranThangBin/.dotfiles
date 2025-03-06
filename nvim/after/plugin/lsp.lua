require("lspconfig.ui.windows").default_options.border = "rounded"

local lsp_zero = require("lsp-zero")
local lspconfig = require("lspconfig")
local schemastore = require("schemastore")

local lua_opts = lsp_zero.nvim_lua_ls()
lspconfig.lua_ls.setup(lua_opts)

lspconfig.nil_ls.setup({
	settings = {
		["nil"] = {
			formatting = {
				command = { "nixfmt" },
			},
		},
	},
})

lspconfig.jsonls.setup({
	settings = {
		json = {
			schemas = schemastore.json.schemas(),
			validate = { enable = true },
		},
	},
})

lspconfig.yamlls.setup({
	yaml = {
		schemas = schemastore.yaml.schemas(),
		schemaStore = {
			enable = false,
			url = "",
		},
	},
})

lspconfig.ccls.setup({})

lspconfig.gdscript.setup(lsp_zero.get_capabilities())

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
})

lsp_zero.set_sign_icons({
	error = "✘",
	warn = "▲",
	hint = "⚑",
	info = "»",
})

require("lsp-zero").on_attach(function(client, bufnr)
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
	vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = bufnr })

	vim.keymap.set("n", "K", function()
		-- vim.lsp.buf.hover({ border = "rounded" })
		vim.lsp.buf.hover()
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
		require("lsp-overloads").setup(client, {
			silent = true,
			display_automatically = false,
			ui = {
				border = "rounded",
				wrap = true,
				close_events = { "CursorMoved", "BufHidden", "InsertLeave" },
				focusable = true,
				focus = false,
				offset_x = 0,
				offset_y = 0,
				floating_window_above_cur_line = false,
				silent = true,
			},
			keymaps = {
				next_signature = "<C-j>",
				previous_signature = "<C-k>",
				next_parameter = "<C-l>",
				previous_parameter = "<C-h>",
				close_signature = "<M-s>",
			},
		})
		vim.keymap.set(
			{ "n", "i" },
			"<M-s>",
			"<cmd>LspOverloadsSignature<CR>",
			{ buffer = bufnr }
		)
	end
end)
