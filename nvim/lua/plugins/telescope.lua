return {
	"nvim-telescope/telescope.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	cmd = "Telescope",
	keys = {
		{ "<leader>fd", "<cmd>Telescope find_files<cr>", desc = "Find files" },
		{ "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
		{ "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
		{ "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help tags" },
	},
	config = function()
		require("telescope").setup({
			defaults = {
				prompt_prefix = "❯ ",
				selection_caret = "➤ ",
				path_display = { "smart" },
				layout_config = {
					width = 0.9,
					height = 0.85,
				},
			},
		})
	end,
}
