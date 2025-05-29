require("lspconfig.ui.windows").default_options.border = "rounded"

local lspconfig = require("lspconfig")
local schemastore = require("schemastore")
local ts_builtin = require("telescope.builtin")

local capabilities = vim.tbl_extend(
	"force",
	vim.lsp.protocol.make_client_capabilities(),
	require("cmp_nvim_lsp").default_capabilities()
)

local servers = {
	"ccls",
	"html",
	"cssls",
	"emmet_language_server",
	"tailwindcss",
	"ts_ls",
	"gdscript",
	"gopls",
	"dockerls",
	"docker_compose_language_service",
	"bashls",
	"templ",
	"rust_analyzer",
	"taplo",
	"zls",
	"lua_ls",
	nil_ls = {
		settings = {
			["nil"] = {
				nix = {
					flake = { autoArchive = false },
				},
			},
		},
	},
	ruff = { init_options = { settings = { logLevel = "debug" } } },
	pyright = {
		settings = {
			pyright = { disableOrganizeImports = true },
			python = { analysis = { ignore = { "*" } } },
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
		lspconfig[server].setup({ capabilities = capabilities })
	else
		local server = k
		local opts = v
		opts.capabilities = opts.capabilities or capabilities
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
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "✘",
			[vim.diagnostic.severity.WARN] = "▲",
			[vim.diagnostic.severity.HINT] = "⚑",
			[vim.diagnostic.severity.INFO] = "»",
		},
	},
})

local keys_normal = {
	["gd"] = function()
		ts_builtin.lsp_definitions()
	end,
	["gr"] = function()
		ts_builtin.lsp_references()
	end,
	["<leader>ws"] = function()
		ts_builtin.lsp_workspace_symbols()
	end,
	["<leader>ds"] = function()
		ts_builtin.lsp_document_symbols()
	end,
	["<leader>ca"] = function()
		vim.lsp.buf.code_action()
	end,
	["<leader>rn"] = function()
		vim.lsp.buf.rename()
	end,
	["<C-s>"] = function()
		vim.lsp.buf.signature_help({ border = "rounded" })
	end,
	["K"] = function()
		vim.lsp.buf.hover({ border = "rounded" })
	end,
	["<leader>vd"] = function()
		vim.diagnostic.open_float({ border = "rounded" })
	end,
	["]d"] = function()
		vim.diagnostic.jump({ count = 1, float = true })
	end,
	["[d"] = function()
		vim.diagnostic.jump({ count = -1, float = true })
	end,
	["<leader>f"] = function(bufnr)
		vim.lsp.buf.format({
			bufnr = bufnr,
			async = true,
			filter = function(cl)
				local null_ls_attached = #vim.lsp.get_clients({
					bufnr = bufnr,
					name = "null-ls",
				}) > 0
				return cl.name == "null-ls"
					or (not null_ls_attached and cl.name ~= "null-ls")
			end,
		})
	end,
}

local keys_insert = { ["<C-s>"] = keys_normal["<C-s>"] }

local lsp_group =
	vim.api.nvim_create_augroup("tranquangthang/lsp", { clear = true })

vim.api.nvim_create_autocmd("LspAttach", {
	group = lsp_group,
	callback = function(e)
		for key, exec in pairs(keys_normal) do
			vim.keymap.set("n", key, function()
				exec(e.buf)
			end, { buffer = e.buf })
		end

		for key, exec in pairs(keys_insert) do
			vim.keymap.set("i", key, function()
				exec()
			end, { buffer = e.buf })
		end
	end,
})
