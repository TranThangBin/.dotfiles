require("rose-pine").setup({
	enable = {},
	highlight_groups = {},
	groups = {},
	palette = {},
	styles = { transparency = true },
	before_highlight = function() end,
	variant = "auto",
	dark_variant = "moon",
	dim_inactive_windows = false,
	extend_background_behind_borders = true,
})

require("tokyonight").setup({
	styles = {
		comments = { italic = false },
		keywords = { italic = false },
	},
})

require("catppuccin").setup({ transparent_background = true })

if math.random(0, 5) ~= 0 then
	vim.cmd.colorscheme("rose-pine-moon")
else
	vim.cmd.colorscheme("catppuccin-mocha")
end
