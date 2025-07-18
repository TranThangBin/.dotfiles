local extensions = require("harpoon.extensions")
local harpoon = require("harpoon")
harpoon:extend(extensions.builtins.navigate_with_number())
harpoon:extend(extensions.builtins.highlight_current_file())

local ui = harpoon.ui
local list = harpoon:list()

local keys = {
	["<leader>a"] = function()
		list:add()
	end,
	["<leader>m"] = function()
		ui:toggle_quick_menu(list)
	end,
	["<C-l>"] = function()
		list:next()
	end,
	["<C-h>"] = function()
		list:prev()
	end,
}

for key, exec in pairs(keys) do
	vim.keymap.set("n", key, exec)
end

for i = 1, 9 do
	vim.keymap.set("n", "<leader>" .. i, function()
		list:select(i)
	end)
end
