return {
	{
		"goolord/alpha-nvim",
		event = "VimEnter",
		config = function()
			local alpha = require("alpha")
			local dashboard = require("alpha.themes.dashboard")
			local headers = require("headers")

			-- ring iterator state
			local idx = 0
			local total = #headers

			local function next_header()
				idx = (idx % total) + 1
				return headers[idx]
			end

			-- initial header
			dashboard.section.header.val = next_header()
			dashboard.section.header.opts.hl = "AlphaHeader"
			dashboard.section.buttons.val = {}
			dashboard.section.footer.val = "MOMO AYASE"

			alpha.setup(dashboard.opts)

			-- alpha buffer keymap
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "alpha",
				callback = function(ev)
					vim.keymap.set("n", "<leader>ah", function()
						dashboard.section.header.val = next_header()
						vim.cmd("Alpha")
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

					dashboard.section.header.val = next_header()
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
