return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local on_attach = function(_, bufnr)
				local opts = { buffer = bufnr, silent = true }

				vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
				vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
				vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
				vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
				vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
				vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
				vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
			end

			local capabilities = vim.lsp.protocol.make_client_capabilities()

			-- lua lsp server
			vim.lsp.config("lua_ls", {
				on_attach = on_attach,
				capabilities = capabilities,
			})
			vim.lsp.enable("lua_ls")

			--php lsp
			vim.lsp.config("intelephense", {
				cmd = { "intelephense", "--stdio" },
				on_attach = on_attach,
				capabilities = capabilities,
			})
			vim.lsp.enable("intelephense")

			-- tsserver lsp
			vim.lsp.config("tsserver", {
				cmd = { "typescript-language-server", "--stdio" },
				on_attach = on_attach,
				capabilities = capabilities,
			})
			vim.lsp.enable("tsserver")
		end,
	},
}
