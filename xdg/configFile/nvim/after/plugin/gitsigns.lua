local gitsigns_actions = require("gitsigns.actions")

local keys = {
	["<leader>hs"] = gitsigns_actions.stage_hunk,
	["<leader>hr"] = gitsigns_actions.reset_hunk,
	["<leader>hS"] = gitsigns_actions.stage_buffer,
	["<leader>hR"] = gitsigns_actions.reset_buffer,
	["<leader>hp"] = gitsigns_actions.preview_hunk,
	["<leader>tb"] = gitsigns_actions.toggle_current_line_blame,
	["<leader>td"] = gitsigns_actions.preview_hunk_inline,
	["<leader>hd"] = gitsigns_actions.diffthis,
	["<leader>hD"] = function()
		gitsigns_actions.diffthis("~")
	end,
	["<leader>hb"] = function()
		gitsigns_actions.blame_line({ full = true })
	end,
	["]g"] = function()
		if vim.wo.diff then
			vim.cmd.normal({ "]g", bang = true })
		else
			gitsigns_actions.nav_hunk("next")
		end
	end,
	["[g"] = function()
		if vim.wo.diff then
			vim.cmd.normal({ "[g", bang = true })
		else
			gitsigns_actions.nav_hunk("prev")
		end
	end,
}

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
		for key, exec in pairs(keys) do
			vim.keymap.set("n", key, exec, { buffer = bufnr })
		end

		vim.keymap.set("x", "<leader>hs", function()
			gitsigns_actions.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
		end, { buffer = bufnr })

		vim.keymap.set("x", "<leader>hr", function()
			gitsigns_actions.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
		end, { buffer = bufnr })

		vim.keymap.set(
			{ "o", "x" },
			"ih",
			gitsigns_actions.select_hunk,
			{ buffer = bufnr }
		)
	end,
})
