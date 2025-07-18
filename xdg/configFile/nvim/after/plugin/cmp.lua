local cmp = require("cmp")
local lspkind = require("lspkind")
local luasnip = require("luasnip")
local tailwind_colorizer_cmp = require("tailwindcss-colorizer-cmp")

require("luasnip.loaders.from_vscode").lazy_load()
tailwind_colorizer_cmp.setup({ color_square_width = 2 })

vim.opt.completeopt = { "menu", "menuone", "noselect" }

local kind_formatter = lspkind.cmp_format({})

cmp.setup({
	preselect = "item",
	formatting = {
		fields = { "abbr", "kind", "menu" },
		expandable_indicator = true,
		format = function(entry, vim_item)
			vim_item = kind_formatter(entry, vim_item)
			return tailwind_colorizer_cmp.formatter(entry, vim_item)
		end,
	},

	mapping = cmp.mapping.preset.insert({
		["<CR>"] = cmp.mapping.confirm({ select = false }),
		["<Tab>"] = cmp.mapping.confirm({ select = false }),

		["<C-n>"] = cmp.mapping(function()
			if cmp.visible() then
				cmp.abort()
			else
				cmp.complete()
			end
		end),

		["<C-j>"] = cmp.mapping.select_next_item(),
		["<C-k>"] = cmp.mapping.select_prev_item(),

		["<C-w>"] = cmp.mapping(function()
			luasnip.jump(1)
		end, { "i", "s" }),
		["<C-b>"] = cmp.mapping(function()
			luasnip.jump(-1)
		end, { "i", "s" }),

		["<C-u>"] = cmp.mapping.scroll_docs(-5),
		["<C-d>"] = cmp.mapping.scroll_docs(5),
	}),

	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},

	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},

	completion = {
		completeopt = "menu,menuone,noinsert",
	},

	sources = cmp.config.sources({
		{ name = "path" },
		{ name = "nvim_lsp" },
		{ name = "lazydev" },
		{ name = "luasnip" },
	}, {
		{ name = "buffer" },
	}),
})

cmp.setup.filetype("sql", {
	sources = {
		{ name = "vim-dadbob-completion" },
		{ name = "buffer" },
	},
})

cmp.setup.cmdline("/", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = "buffer" },
	},
})

cmp.setup.cmdline(":", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = "path" },
		{ name = "cmdline" },
	}),
})
