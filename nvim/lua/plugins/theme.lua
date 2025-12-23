return {
	{
		"goolord/alpha-nvim",
		event = "VimEnter",
		config = function()
			local alpha = require("alpha")
			local dashboard = require("alpha.themes.dashboard")

			local headers = require("headers")
			math.randomseed(os.time())
			local header = headers[math.random(#headers)]

			dashboard.section.header.val = header
			dashboard.section.header.opts.hl = "AlphaHeader"
			dashboard.section.buttons.val = {}
			dashboard.section.footer.val = "MOMO AYASE"
			alpha.setup(dashboard.opts)

			vim.api.nvim_create_autocmd("BufEnter", {
				callback = function()
					local buf = vim.api.nvim_get_current_buf()

					if vim.api.nvim_buf_get_name(buf) ~= "" then
						return
					end

					if vim.bo[buf].buftype ~= "" then
						return
					end

					if vim.api.nvim_buf_line_count(buf) ~= 1 then
						return
					end

					if vim.api.nvim_buf_get_lines(buf, 0, 1, false)[1] ~= "" then
						return
					end

					dashboard.section.header.val = headers[math.random(#headers)]
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
