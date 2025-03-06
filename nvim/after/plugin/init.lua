require("netrw").setup()
require("nvim-autopairs").setup()
require("nvim-surround").setup()

require("oil").setup({ default_file_explorer = false })
vim.keymap.set("n", "<leader>-", "<cmd>Oil<CR>")

local fugitive_keys = {
	{ "<leader>gs", "<cmd>Git<CR>" },
	{ "gh", "<cmd>diffget //2<CR>" },
	{ "gl", "<cmd>diffget //3<CR>" },
}
for _, key in pairs(fugitive_keys) do
	vim.keymap.set("n", key[1], key[2])
end

local jump = require("todo-comments.jump")
local todo_keys = {
	{ "<leader>ttf", "<cmd>TodoTelescope<CR>" },
	{ "<leader>txx", "<cmd>TodoTrouble<CR>" },
	{ "]t", jump.next },
	{ "[t", jump.prev },
}
for _, key in pairs(todo_keys) do
	vim.keymap.set("n", key[1], key[2])
end
