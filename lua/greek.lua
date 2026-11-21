local M = {
	opts = {},
	ns_id = nil,
}

function M.hide()
	if M.ns_id ~= nil then
		vim.api.nvim_buf_clear_namespace(0, M.ns_id, 0, -1)
	end
end

function M.show()
	if M.ns_id ~= nil then
		vim.api.nvim_buf_clear_namespace(0, M.ns_id, 0, -1)
	end
end

function M.init_autocmd()
	vim.api.nvim_create_autocmd("InsertEnter", {
		pattern = M.opts.files_pattern,
		callback = function(ev)
			M.hide()
		end,
	})

	vim.api.nvim_create_autocmd("InsertLeave", {
		pattern = M.opts.files_pattern,
		callback = function(ev)
			M.conceal()
		end,
	})

	vim.api.nvim_create_autocmd("BufEnter", {
		pattern = M.opts.files_pattern,
		callback = function(ev)
			M.show()
		end,
	})
end

function M.conceal()
	print("Concealing...")
end

function M.setup(opts)
	opts = opts or {}

	M.opts = {
		files_pattern = opts.files_pattern or "*",
	}

	M.ns_id = vim.api.nvim_create_namespace("greek.nvim")

	M.init_autocmd()

	vim.api.nvim_create_user_command("HideGreek", M.hide, {})
	vim.api.nvim_create_user_command("ConcealGreek", M.conceal, {})
end

return M
