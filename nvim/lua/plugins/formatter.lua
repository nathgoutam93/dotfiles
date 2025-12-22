return {
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		config = function()
			require("conform").setup({
				formatters_by_ft = {
					lua = { "stylua" },
					javascript = { "prettier" },
					typescript = { "prettier" },
					json = { "prettier" },
					html = { "prettier" },
					css = { "prettier" },
					sh = { "shfmt" },
					php = { "php_cs_fixer" },
				},

				formatters = {

					php_cs_fixer = {
						command = "php-cs-fixer",
						args = {
							"fix",
							"$FILENAME",
							"--quiet",
						},
						stdin = false,
					},
				},

				format_on_save = {
					timeout_ms = 500,
					lsp_fallback = true,
				},
			})
		end,
	},

	{
		"zapling/mason-conform.nvim",
		dependencies = {
			"williamboman/mason.nvim",
			"stevearc/conform.nvim",
		},
		config = function()
			require("mason-conform").setup({
				ensure_installed = {
					"stylua",
					"prettier",
					"shfmt",
					"php_cs_fixer",
				},
			})
		end,
	},
}
