require("gitsigns").setup({
	signs = {
		add = { text = "┃" },
		change = { text = "┃" },
		delete = { text = "_" },
		topdelete = { text = "‾" },
		changedelete = { text = "~" },
		untracked = { text = "┆" },
	},
	signcolumn = true,
	numhl = false,
	linehl = false,
	word_diff = false,
	watch_gitdir = {
		follow_files = true,
	},
	auto_attach = true,
	attach_to_untracked = false,
	current_line_blame = false,
	current_line_blame_opts = {
		virt_text = true,
		virt_text_pos = "eol",
		delay = 1000,
		ignore_whitespace = false,
		virt_text_priority = 100,
	},
	current_line_blame_formatter = "<author>, <author_time:%R> - <summary>",
	sign_priority = 6,
	update_debounce = 100,
	status_formatter = nil,
	max_file_length = 40000,
	preview_config = {
		border = "rounded",
		style = "minimal",
		relative = "cursor",
		row = 0,
		col = 1,
	},
	on_attach = function(bufnr)
		local gitsigns = require("gitsigns.actions")

		vim.keymap.set("n", "]g", function()
			if vim.wo.diff then
				vim.cmd.normal({ "]g", bang = true })
			else
				gitsigns.nav_hunk("next")
			end
		end, { buffer = bufnr })

		vim.keymap.set("n", "[g", function()
			if vim.wo.diff then
				vim.cmd.normal({ "[g", bang = true })
			else
				gitsigns.nav_hunk("prev")
			end
		end, { buffer = bufnr })

		vim.keymap.set(
			"n",
			"<leader>hs",
			gitsigns.stage_hunk,
			{ buffer = bufnr }
		)
		vim.keymap.set(
			"n",
			"<leader>hr",
			gitsigns.reset_hunk,
			{ buffer = bufnr }
		)

		vim.keymap.set("x", "<leader>hs", function()
			gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
		end, { buffer = bufnr })

		vim.keymap.set("x", "<leader>hr", function()
			gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
		end, { buffer = bufnr })

		vim.keymap.set(
			"n",
			"<leader>hS",
			gitsigns.stage_buffer,
			{ buffer = bufnr }
		)

		vim.keymap.set(
			"n",
			"<leader>hu",
			gitsigns.undo_stage_hunk,
			{ buffer = bufnr }
		)

		vim.keymap.set(
			"n",
			"<leader>hR",
			gitsigns.reset_buffer,
			{ buffer = bufnr }
		)

		vim.keymap.set(
			"n",
			"<leader>hp",
			gitsigns.preview_hunk,
			{ buffer = bufnr }
		)

		vim.keymap.set("n", "<leader>hb", function()
			gitsigns.blame_line({ full = true })
		end, { buffer = bufnr })

		vim.keymap.set(
			"n",
			"<leader>tb",
			gitsigns.toggle_current_line_blame,
			{ buffer = bufnr }
		)

		vim.keymap.set("n", "<leader>hd", gitsigns.diffthis, { buffer = bufnr })

		vim.keymap.set("n", "<leader>hD", function()
			gitsigns.diffthis("~")
		end, { buffer = bufnr })

		vim.keymap.set(
			"n",
			"<leader>td",
			gitsigns.toggle_deleted,
			{ buffer = bufnr }
		)

		vim.keymap.set(
			{ "o", "x" },
			"ih",
			gitsigns.select_hunk,
			{ buffer = bufnr }
		)
	end,
})
