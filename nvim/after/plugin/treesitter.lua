require("nvim-treesitter.configs").setup({
	modules = {},
	ensure_installed = {},
	ignore_install = {},
	sync_install = false,
	auto_install = false,
	indent = { enable = false },
	highlight = {
		enable = true,
		disable = function(_, buf)
			local max_filesize = 100 * 1024 -- 100 KB
			local ok, stats =
				pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
			if ok and stats and stats.size > max_filesize then
				vim.notify(
					"File larger than 100KB treesitter disabled for performance",
					vim.log.levels.WARN,
					{ title = "Treesitter" }
				)
				return true
			end
		end,
	},
	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = "<Tab>",
			node_incremental = "<Tab>",
			node_decremental = "<S-Tab>",
			scope_incremental = "<C-Space>",
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
})

require("nvim-ts-autotag").setup()

require("treesitter-context").setup({ enable = false })
vim.keymap.set("n", "<leader>ct", "<cmd>TSContextToggle<CR>")
