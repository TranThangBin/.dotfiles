local opts = {}

opts.progress = {
	poll_rate = 0,
	suppress_on_insert = false,
	ignore_done_already = false,
	ignore_empty_message = false,
	ignore = {},
	lsp = {
		progress_ringbuf_size = 0,
		log_handler = false,
	},
	display = {
		render_limit = 16,
		done_ttl = 3,
		done_icon = "✔ ",
		done_style = "Constant",
		progress_ttl = math.huge,
		progress_icon = { pattern = "dots", period = 1 },
		progress_style = "WarningMsg",
		group_style = "Title",
		icon_style = "Question",
		priority = 30,
		skip_history = true,
		format_message = require("fidget.progress.display").default_format_message,
		overrides = { rust_analyzer = { name = "rust-analyzer" } },
		format_annote = function(msg)
			return msg.title
		end,
		format_group_name = function(group)
			return tostring(group)
		end,
	},
	clear_on_detach = function(client_id)
		local client = vim.lsp.get_client_by_id(client_id)
		return client and client.name or nil
	end,
	notification_group = function(msg)
		return msg.lsp_client.name
	end,
}

opts.notification = {
	poll_rate = 10,
	filter = vim.log.levels.INFO,
	history_size = 128,
	override_vim_notify = false,
	configs = {
		default = require("fidget.notification").default_config,
	},
	window = {
		normal_hl = "Comment",
		winblend = 0,
		border = "rounded",
		zindex = 45,
		max_width = 0,
		max_height = 0,
		x_padding = 1,
		y_padding = 1,
		align = "top",
		relative = "editor",
	},
	view = {
		stack_upwards = true,
		icon_separator = " ",
		group_separator = "---",
		group_separator_hl = "Comment",
		render_message = function(msg, cnt)
			return cnt == 1 and msg or string.format("(%dx) %s", cnt, msg)
		end,
	},
	redirect = function(msg, level, redirect_opts)
		if redirect_opts and redirect_opts.on_open then
			return require("fidget.integration.nvim-notify").delegate(
				msg,
				level,
				redirect_opts
			)
		end
	end,
}

opts.integration = {
	["nvim-tree"] = { enable = false },
	["xcodebuild-nvim"] = { enable = false },
}

opts.logger = {
	level = vim.log.levels.WARN,
	max_size = 10000,
	float_precision = 0.01,
	path = string.format("%s/fidget.nvim.log", vim.fn.stdpath("cache")),
}

require("fidget").setup(opts)
