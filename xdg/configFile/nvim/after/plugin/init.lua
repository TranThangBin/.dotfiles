require("netrw").setup()
require("nvim-autopairs").setup()
require("nvim-surround").setup()
require("plainline").setup()

vim.keymap.set("n", "<leader>u", "<cmd>UndotreeToggle<CR>")

require("oil").setup({ default_file_explorer = false })
vim.keymap.set("n", "<leader>-", function()
	local file_pattern = vim.fn.escape(vim.fn.expand("%:t"), [[\/.*~]])
	vim.cmd.Oil()
	vim.fn.search(file_pattern)
end)

local fugitive_keys = {
	["<leader>gs"] = "<cmd>Git<CR>",
	["gh"] = "<cmd>diffget //2<CR>",
	["gl"] = "<cmd>diffget //3<CR>",
}
for key, exec in pairs(fugitive_keys) do
	vim.keymap.set("n", key, exec)
end

require("todo-comments").setup()
local jump = require("todo-comments.jump")
local todo_keys = {
	["<leader>ttf"] = "<cmd>TodoTelescope<CR>",
	["<leader>txx"] = "<cmd>TodoTrouble<CR>",
	["]t"] = jump.next,
	["[t"] = jump.prev,
}
for key, exec in pairs(todo_keys) do
	vim.keymap.set("n", key, exec)
end

require("cloak").setup()

require("colorizer").setup({
	filetypes = {
		"html",
		"css",
		"javascript",
		"typescript",
		cmp_menu = { always_update = true },
		cmp_docs = { always_update = true },
	},
	user_default_options = {
		names = false,
		rgb_fn = true,
		hsl_fn = true,
		css = true,
		css_fn = true,
		tailwind = "both",
		tailwind_opts = {
			update_names = true,
		},
	},
})

require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		gdscript = { "gdformat" },
		html = { "prettierd" },
		css = { "prettierd" },
		javascript = { "prettierd" },
		typescript = { "prettierd" },
		bash = { "shfmt" },
		nix = { "nixfmt" },
		templ = { "templ" },
		cs = { "csharpier" },
	},
})

require("hardtime").setup({
	callback = function(text)
		require("fidget").notify(text, vim.log.levels.WARN, {
			group = "Hardtime",
			ttl = require("hardtime.config").config.timeout / 1000,
		})
	end,
})
