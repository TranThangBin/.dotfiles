require("telescope").setup({
	defaults = {
		mappings = {
			n = { q = require("telescope.actions").close },
		},
	},
	extensions = {
		fzf = {
			fuzzy = true,
			override_generic_sorter = true,
			override_file_sorter = true,
			case_mode = "smart_case",
		},
	},
})

require("telescope").load_extension("fzf")

local builtin = require("telescope.builtin")

local keys = {
	["<leader>tf"] = builtin.find_files,
	["<leader>tg"] = builtin.git_files,
	["<leader>tk"] = builtin.keymaps,
	["<leader>bf"] = builtin.buffers,
	["<leader>lg"] = builtin.live_grep,
	["<leader>of"] = builtin.oldfiles,
	["<leader>rs"] = builtin.resume,
}

for key, exec in pairs(keys) do
	vim.keymap.set("n", key, exec)
end
