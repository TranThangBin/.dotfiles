local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"--branch=stable",
		lazyrepo,
		lazypath,
	})
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	spec = {
		"tpope/vim-obsession",
		"neovim/nvim-lspconfig",
		"b0o/schemastore.nvim",
		"folke/lazydev.nvim",
		"Bilal2453/luvit-meta",
		"mbbill/undotree",
		"habamax/vim-godot",
		"windwp/nvim-autopairs",
		"windwp/nvim-ts-autotag",
		"kylechui/nvim-surround",
		"tpope/vim-fugitive",
		"j-hui/fidget.nvim",
		"lewis6991/gitsigns.nvim",
		"folke/trouble.nvim",
		"folke/zen-mode.nvim",
		"ThePrimeagen/vim-be-good",
		"nvimtools/none-ls.nvim",
		"nvim-treesitter/nvim-treesitter-textobjects",
		"nvim-treesitter/nvim-treesitter-context",
		"uga-rosa/ccc.nvim",
		"laytan/cloak.nvim",
		"tpope/vim-dadbod",
		"kristijanhusak/vim-dadbod-completion",
		"kristijanhusak/vim-dadbod-ui",
		"onsails/lspkind.nvim",
		"ray-x/lsp_signature.nvim",
		"eduardo-antunes/plainline",
		"roobert/tailwindcss-colorizer-cmp.nvim",
		"folke/tokyonight.nvim",
		{ "catppuccin/nvim", name = "catppuccin" },
		{ "rose-pine/neovim", name = "rose-pine" },
		{
			"ThePrimeagen/harpoon",
			dependencies = { "nvim-lua/plenary.nvim" },
		},
		{
			"prichrd/netrw.nvim",
			dependencies = { "nvim-tree/nvim-web-devicons" },
		},
		{
			"stevearc/oil.nvim",
			dependencies = { "nvim-tree/nvim-web-devicons" },
		},
		{
			"folke/todo-comments.nvim",
			dependencies = { "nvim-lua/plenary.nvim" },
		},
		{
			"m4xshen/hardtime.nvim",
			dependencies = { "MunifTanjim/nui.nvim" },
		},
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		{
			"nvim-telescope/telescope.nvim",
			dependencies = {
				"nvim-lua/plenary.nvim",
				"nvim-telescope/telescope-fzf-native.nvim",
			},
		},
		{
			"hrsh7th/nvim-cmp",
			dependencies = {
				"hrsh7th/cmp-nvim-lsp",
				"hrsh7th/cmp-buffer",
				"hrsh7th/cmp-path",
				"hrsh7th/cmp-cmdline",
				"saadparwaiz1/cmp_luasnip",
				"rafamadriz/friendly-snippets",
				{
					"L3MON4D3/LuaSnip",
					build = "make install_jsregexp",
				},
			},
		},
	},
	install = { colorscheme = { "habamax" } },
	checker = { enabled = true },
})
