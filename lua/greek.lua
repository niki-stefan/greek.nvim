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

	M.conceal()
end

function M.init_autocmd()
	vim.api.nvim_create_autocmd("BufEnter", {
		pattern = M.opts.files_pattern,
		callback = function(ev)
			M.conceal()
		end,
	})
end

function M.conceal()
	local buffer = vim.api.nvim_get_current_buf()

	-- Note: vim regex requires + to be \+, which i dont really get why...
	local regex = vim.regex("greek\\[\\w\\+\\]")

	for i = 0, vim.api.nvim_buf_line_count(buffer) - 1 do
		local start_col, end_col = regex:match_line(buffer, i)

		if start_col then
			local opts = {
				conceal = "A",
				end_col = end_col,
			}

			local mark_id = vim.api.nvim_buf_set_extmark(0, M.ns_id, i, start_col, opts)
		end
	end
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
