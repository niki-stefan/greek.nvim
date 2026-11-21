local M = { opts = {}, ns_id = nil }

local letters = {
	alpha = { "Α", "α" },
	beta = { "Β", "β" },
	gamma = { "Γ", "γ" },
	delta = { "Δ", "δ" },
	epsilon = { "Ε", "ε" },
	zeta = { "Ζ", "ζ" },
	eta = { "Η", "η" },
	theta = { "Θ", "θ" },
	iota = { "Ι", "ι" },
	kappa = { "Κ", "κ" },
	lambda = { "Λ", "λ" },
	mu = { "Μ", "μ" },
	nu = { "Ν", "ν" },
	xi = { "Ξ", "ξ" },
	omicron = { "Ο", "ο" },
	pi = { "Π", "π" },
	rho = { "Ρ", "ρ" },
	sigma = { "Σ", "σ" },
	tau = { "Τ", "τ" },
	upsilon = { "Υ", "υ" },
	phi = { "Φ", "φ" },
	chi = { "Χ", "χ" },
	psi = { "Ψ", "ψ" },
	omega = { "Ω", "ω" },
}

local shorthands = {
	a = "alpha",
	b = "beta",
	r = "rho",
	p = "pi",
	d = "delta",
	t = "tau",
	w = "omega",
	e = "epsilon",
	i = "iota",
	o = "omicron",
	s = "sigma",
	f = "phi",
	k = "kappa",
	l = "lambda",
	x = "chi",
	n = "upsilon",
	z = "zeta",
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
	-- [TODO]: Instead of concealing each one again, conceal only the ones that changed
	vim.api.nvim_create_autocmd("InsertLeave", {
		pattern = M.opts.files_pattern,
		callback = function(ev)
			M.hide()

			M.conceal()
		end,
	})

	vim.api.nvim_create_autocmd("BufEnter", {
		pattern = M.opts.files_pattern,
		callback = function(ev)
			M.conceal()
		end,
	})
end

function M.conceal()
	-- Note: vim regex requires + to be \+, which i dont really get why...
	local regex = vim.regex("gr\\[\\w\\+\\]")

	-- arguments: buffer (0 means current buffer), start_line, end_line (-1 means the last line), strict_checking
	-- [https://neovim.io/doc/user/api/#nvim_buf_get_lines()]
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, 0)

	for i, line in ipairs(lines) do
		local offset = 1

		while 1 do
			local start_col, end_col = regex:match_str(line:sub(offset))

			if not start_col then
				break
			end

			-- regex:match_str returns the indices based on the subline, not the whole line, so we "convert" them to line indices
			start_col = start_col + offset - 1
			end_col = end_col + offset - 1

			-- Remove gr[ and ], keeping only the letter name
			local letter = line:sub(start_col + 4, end_col - 1)

			if shorthands[letter:lower()] ~= nil then
				local letter_name = shorthands[letter:lower()]

				if letter:match("%u") then
					-- Capitalize first letter
					letter = letter_name:sub(1, 1):upper() .. letter_name:sub(2)
				else
					letter = letter_name
				end
			end

			if letters[letter:lower()] ~= nil then
				-- 1 means it is, 2 means it is not
				local is_uppercase = 2

				-- %u means uppercase letter [https://www.lua.org/pil/20.2.html]
				if letter:sub(1, 1):match("%u") then
					is_uppercase = 1
				end

				local opts = {
					conceal = letters[letter:lower()][is_uppercase],
					end_col = end_col,
					hl_group = M.opts.hl_group,
				}

				-- ipairs(lines) starts i from 1, but nvim_buf_set_extmark wants 0-based indexes
				vim.api.nvim_buf_set_extmark(0, M.ns_id, i - 1, start_col, opts)
			end

			offset = end_col + 1
		end
	end
end

function M.setup(opts)
	opts = opts or {}

	M.opts = {
		files_pattern = opts.files_pattern or "*",
		hl_group = opts.hl_group or "Exception",
	}

	M.ns_id = vim.api.nvim_create_namespace("greek.nvim")

	vim.api.nvim_buf_attach(0, false, {
		on_lines = function(_, _, _, first_line)
			M.conceal()
		end,
	})

	M.init_autocmd()

	vim.api.nvim_create_user_command("HideGreek", M.hide, {})
	vim.api.nvim_create_user_command("ConcealGreek", M.conceal, {})
end

return M
