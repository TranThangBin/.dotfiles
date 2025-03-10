require("lspconfig.ui.windows").default_options.border = "rounded"

local builtin = require("telescope.builtin")
local lsp_zero = require("lsp-zero")
local lspconfig = require("lspconfig")
local schemastore = require("schemastore")

local servers = {
	"ccls",
	"html",
	"htmx",
	"cssls",
	"tailwindcss",
	"ts_ls",
	"gdscript",
	"gopls",
	"dockerls",
	"docker_compose_language_service",
	"bashls",
	"templ",
	"rust_analyzer",
	"pylsp",
	lua_ls = lsp_zero.nvim_lua_ls(),
	nil_ls = {
		settings = {
			["nil"] = {
				formatting = {
					command = { "nixfmt" },
				},
			},
		},
	},
	jsonls = {
		settings = {
			json = {
				schemas = schemastore.json.schemas(),
				validate = { enable = true },
			},
		},
	},
	yamlls = {
		yaml = {
			schemas = schemastore.yaml.schemas(),
			schemaStore = {
				enable = false,
				url = "",
			},
		},
	},
}

for k, v in pairs(servers) do
	if type(k) == "number" then
		local server = v
		lspconfig[server].setup({})
	else
		local server = k
		local opts = v
		lspconfig[server].setup(opts)
	end
end

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

local keys = {
	["gd"] = builtin.lsp_definitions,
	["gr"] = builtin.lsp_references,
	["<leader>ws"] = builtin.lsp_workspace_symbols,
	["<leader>ds"] = builtin.lsp_document_symbols,
	["<leader>ca"] = vim.lsp.buf.code_action,
	["<leader>rn"] = vim.lsp.buf.rename,
	["K"] = function()
		-- vim.lsp.buf.hover({ border = "rounded" })
		vim.lsp.buf.hover()
	end,
	["<leader>vd"] = function()
		vim.diagnostic.open_float({ border = "rounded" })
	end,
	["]d"] = function()
		-- vim.diagnostic.jump({ count = 1, float = true })
		vim.diagnostic.goto_next()
	end,
	["[d"] = function()
		-- vim.diagnostic.jump({ count = -1, float = true })
		vim.diagnostic.goto_prev()
	end,
	["<leader>f"] = function(bufnr)
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
	end,
}

require("lsp-zero").on_attach(function(client, bufnr)
	for key, exec in pairs(keys) do
		vim.keymap.set("n", key, function()
			exec(bufnr)
		end, { buffer = bufnr })
	end
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
