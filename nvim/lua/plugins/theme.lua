return {
	{
		"goolord/alpha-nvim",
		event = "VimEnter",
		dependencies = {
			"nhattVim/alpha-ascii.nvim",
			opts = { header = "random" },
		},
		config = function()
			local alpha = require("alpha")
			local dashboard = require("alpha.themes.dashboard")

			dashboard.section.buttons.val = {}

			vim.api.nvim_create_autocmd("User", {
				once = true,
				pattern = "LazyVimStarted",
				callback = function()
					local stats = require("lazy").stats()
					local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
					dashboard.section.footer.val = {
						" ",
						" Loaded " .. stats.loaded .. "/" .. stats.count .. " plugins  in " .. ms .. " ms ",
					}
					pcall(vim.cmd.AlphaRedraw)
				end,
			})

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

					vim.cmd("Alpha")
				end,
			})
		end,
	},
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		config = function()
			require("catppuccin").setup({
				flavour = "auto", -- latte, frappe, macchiato, mocha
				background = { -- :h background
					light = "latte",
					dark = "mocha",
				},
				transparent_background = false, -- disables setting the background color.
				float = {
					transparent = false, -- enable transparent floating windows
					solid = false, -- use solid styling for floating windows, see |winborder|
				},
				show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
				term_colors = false, -- sets terminal colors (e.g. `g:terminal_color_0`)
				dim_inactive = {
					enabled = false, -- dims the background color of inactive window
					shade = "dark",
					percentage = 0.15, -- percentage of the shade to apply to the inactive window
				},
				no_italic = false, -- Force no italic
				no_bold = false, -- Force no bold
				no_underline = false, -- Force no underline
				styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
					comments = { "italic" }, -- Change the style of comments
					conditionals = { "italic" },
					loops = {},
					functions = {},
					keywords = {},
					strings = {},
					variables = {},
					numbers = {},
					booleans = {},
					properties = {},
					types = {},
					operators = {},
					-- miscs = {}, -- Uncomment to turn off hard-coded styles
				},
				lsp_styles = { -- Handles the style of specific lsp hl groups (see `:h lsp-highlight`).
					virtual_text = {
						errors = { "italic" },
						hints = { "italic" },
						warnings = { "italic" },
						information = { "italic" },
						ok = { "italic" },
					},
					underlines = {
						errors = { "underline" },
						hints = { "underline" },
						warnings = { "underline" },
						information = { "underline" },
						ok = { "underline" },
					},
					inlay_hints = {
						background = true,
					},
				},
				color_overrides = {},
				custom_highlights = {},
				default_integrations = true,
				auto_integrations = false,
				integrations = {
					cmp = true,
					gitsigns = true,
					nvimtree = true,
					treesitter = true,
					lualine = true,
					notify = false,
					mini = {
						enabled = true,
						indentscope_color = "",
					},
					-- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
				},
			})

			-- setup must be called before loading
			vim.cmd.colorscheme("catppuccin")
		end,
	},
}
