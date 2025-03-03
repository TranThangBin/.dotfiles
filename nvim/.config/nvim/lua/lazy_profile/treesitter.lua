return {
	"nvim-treesitter/nvim-treesitter",

	dependencies = "nvim-treesitter/nvim-treesitter-textobjects",

	build = function()
		require("nvim-treesitter.install").update({ with_sync = true })()
	end,

	opts = {
		ensure_installed = {
			"javascript",
			"typescript",
			"c",
			"cpp",
			"go",
			"lua",
			"vim",
			"vimdoc",
			"query",
			"markdown",
			"markdown_inline",
		},
		sync_install = false,
		auto_install = true,
		indent = { enable = false },
		highlight = { enable = true },
		incremental_selection = {
			enable = true,
			keymaps = {
				init_selection = "<C-i>",
				node_incremental = "<C-i>",
				node_decremental = "<C-d>",
				scope_incremental = "<C-s>",
			},
		},
		textobjects = {
			select = {
				enable = true,
				lookahead = true,
				keymaps = {
					["aa"] = "@parameter.outer",
					["ia"] = "@parameter.inner",
					["af"] = "@function.outer",
					["if"] = "@function.inner",
					["ac"] = "@class.outer",
					["ic"] = "@class.inner",
				},
			},
			swap = {
				enable = true,
				swap_next = {
					["<leader>sl"] = "@parameter.inner",
				},
				swap_previous = {
					["<leader>sh"] = "@parameter.inner",
				},
			},
			move = {
				enable = true,
				set_jumps = true,
				goto_next = {
					["]f"] = "@function.outer",
					["]c"] = "@class.outer",
					["]a"] = "@parameter.outer",
				},
				goto_previous = {
					["[f"] = "@function.outer",
					["[c"] = "@class.outer",
					["[a"] = "@parameter.outer",
				},
			},
		},
	},

	config = function(_, opts)
		require("nvim-treesitter.configs").setup(opts)
	end,
}
