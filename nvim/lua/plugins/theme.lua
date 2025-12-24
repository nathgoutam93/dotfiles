return {
	{
		"goolord/alpha-nvim",
		event = "VimEnter",
		dependencies = {
			"nhattVim/alpha-ascii.nvim",
			opts = {
				header = "random",
				use_default = false,
				user_path = vim.fn.stdpath("config") .. "/ascii",
			},
		},
		config = function()
			local alpha = require("alpha")
			local dashboard = require("alpha.themes.dashboard")

			dashboard.section.buttons.val = {
				dashboard.button("SPC f d", "  Find File  ", ":Telescope find_files<CR>"),
				dashboard.button("SPC f o", "  Recent File  ", ":Telescope oldfiles<CR>"),
				dashboard.button("SPC f w", "  Find Word  ", ":Telescope live_grep theme=ivy<CR>"),
				dashboard.button("SPC a h", "  Change header image", ":AlphaAsciiNext<CR>"),
			}

			alpha.setup(dashboard.opts)

			-- alpha buffer keymap
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "alpha",
				callback = function(ev)
					vim.keymap.set("n", "<leader>ah", function()
						vim.cmd("AlphaAsciiNext")
					end, { buffer = ev.buf })
				end,
			})

			-- reopen Alpha after :bd
			vim.api.nvim_create_autocmd("BufEnter", {
				callback = function()
					if vim.bo.filetype == "alpha" then
						return
					end

					local buf = vim.api.nvim_get_current_buf()
					if vim.api.nvim_buf_get_name(buf) ~= "" then
						return
					end
					if vim.bo[buf].buftype ~= "" then
						return
					end

					vim.cmd("Alpha")
				end,
			})
		end,
	},
	{
		"olimorris/onedarkpro.nvim",
		priority = 1000, -- Ensure it loads first
		config = function()
			vim.cmd("colorscheme onedark_dark")
		end,
	},
}
