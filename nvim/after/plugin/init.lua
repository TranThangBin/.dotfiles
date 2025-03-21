require("netrw").setup()
require("nvim-autopairs").setup()
require("nvim-surround").setup()

vim.keymap.set("n", "<leader>u", "<cmd>UndotreeToggle<CR>")

require("oil").setup({ default_file_explorer = false })
vim.keymap.set("n", "<leader>-", "<cmd>Oil<CR>")

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

require("plainline").setup()
