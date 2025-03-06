local extensions = require("harpoon.extensions")
require("harpoon"):extend(extensions.builtins.navigate_with_number())
require("harpoon"):extend(extensions.builtins.highlight_current_file())

local ui = require("harpoon").ui
local list = require("harpoon"):list()

local keys = {
	{
		"<leader>a",
		function()
			list:add()
		end,
	},

	{
		"<leader>m",
		function()
			ui:toggle_quick_menu(list)
		end,
	},

	{
		"<C-l>",
		function()
			list:next()
		end,
	},

	{
		"<C-h>",
		function()
			list:prev()
		end,
	},
}

for _, key in pairs(keys) do
	vim.keymap.set("n", key[1], key[2])
end
