require("rose-pine").setup({
    variant = "auto",
    dark_variant = "moon",
    dim_inactive_windows = false,
    extend_background_behind_borders = true,

    styles = {
        bold = true,
        italic = false,
        transparency = true,
    },

    groups = {
        border = "muted",
        link = "iris",
        panel = "surface",

        error = "love",
        hint = "iris",
        info = "foam",
        warn = "gold",

        git_add = "foam",
        git_change = "rose",
        git_delete = "love",
        git_dirty = "rose",
        git_ignore = "muted",
        git_merge = "iris",
        git_rename = "pine",
        git_stage = "iris",
        git_text = "rose",
        git_untracked = "subtle",

        headings = "subtle",
    },
})

require("tokyonight").setup({
    variant = "auto",
    dark_variant = "moon",
    dim_inactive_windows = false,
    extend_background_behind_borders = true,

    styles = {
        bold = true,
        italic = false,
        transparency = true,
    },

    groups = {
        border = "muted",
        link = "iris",
        panel = "surface",

        error = "love",
        hint = "iris",
        info = "foam",
        warn = "gold",

        git_add = "foam",
        git_change = "rose",
        git_delete = "love",
        git_dirty = "rose",
        git_ignore = "muted",
        git_merge = "iris",
        git_rename = "pine",
        git_stage = "iris",
        git_text = "rose",
        git_untracked = "subtle",

        headings = "subtle",
    },
});

if math.random(0, 5) ~= 0 then
    vim.cmd("colorscheme rose-pine")
else
    vim.cmd("colorscheme tokyonight")
end
