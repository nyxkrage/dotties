local plugins, lsp, color, prequire, nmap, vmap = night.prelude{'plugins', 'lsp', 'color', 'prequire', 'nmap', 'vmap' }

vim.o.swapfile = false

plugins(function(use)
	use {
		'~/projects/local/projects.nvim'
	}

	use {
		'TimUntersberger/neogit',
		requires = 'nvim-lua/plenary.nvim'
	}

	use 'vimlab/split-term.vim'

	use 'ap/vim-css-color'

	use {
		'~/projects/local/henna.nvim',
	}

	use {
		'petertriho/cmp-git',
		requires = 'nvim-lua/plenary.nvim'
	}
end)



color'henna'

local telescope = prequire'telescope'
if telescope then
	telescope.load_extension'projects'

	nmap{'<leader>ff', function() require'telescope.builtin'.find_files() end}
	nmap{'<leader>fh', function() require'telescope.builtin'.find_files{hidden = true} end}
	nmap{'<leader>fg', function() require'telescope.builtin'.git_files() end}
	nmap{'<leader>fb', function() telescope.extensions.file_browser.file_browser() end}
	nmap{'<leader>fp', function() require'telescope.builtin'.find_files{search_dirs = '~/.config/nvim/'} end}
	nmap{'<leader>fs', function() require'telescope.builtin'.live_grep() end}

	nmap{'<leader>pp', function() telescope.extensions.projects.projects() end}

	nmap{'<leader>bb', function() require'telescope.builtin'.buffers() end}
end

local neogit = prequire'neogit'
if neogit then
	nmap{'<leader>gg', function() neogit.open() end}
end

nmap{'<leader>bn', '<CMD>bnext<CR>'}
nmap{'<leader>bp', '<CMD>bprevious<CR>'}
nmap{'<leader>bd', '<CMD>bdelete<CR>'}
nmap{'<leader>bq', '<CMD>Bquit<CR>'}
nmap{'<leader>to', '<CMD>10Term<CR>'}
nmap{'<leader>nr', '<CMD>luafile ~/.config/nvim/init.lua<CR>'}
nmap{'<leader>ne', '<CMD>edit ~/.config/nvim/init.lua<CR>'}

nmap {'<leader>cd', function() vim.diagnostic.open_float() end}
nmap {'<leader>cgp', function() vim.diagnostic.goto_prev() end}
nmap {'<leader>cgn', function() vim.diagnostic.goto_next() end}

nmap {'<leader>cwt', ':TSHighlightCapturesUnderCursor<CR>'}
nmap {'<leader>cws', '<CMD>source<CR>'}
vmap {'<leader>cws', "<CMD>'<,'>source<CR>"}
vim.cmd[[
augroup neovim_terminal
autocmd!
" Enter Terminal-mode (insert) automatically
autocmd TermOpen * startinsert
" Disables number lines on terminal buffers
autocmd TermOpen * :setlocal nonumber norelativenumber
" allows you to use Ctrl-c on terminal window
autocmd TermOpen * tmap <buffer> <Esc> <C-\><C-n>
autocmd TermClose * if !get(b:, 'term_error') | setl bufhidden=delete | bnext! | endif
augroup END
]]
night.on_attach = function(client, bufnr)
	night.log.info('[LSP] Attaching: ' .. client.name .. ' to buffer: ' .. bufnr)

	vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

	nmap {'<leader>ca', function() vim.lsp.buf.code_action() end, bufnr = bufnr }
	nmap {'<leader>cf', function() vim.lsp.buf.formatting() end, bufnr = bufnr }
	nmap {'<leader>ch', function() vim.lsp.buf.hover() end, bufnr = bufnr }
	nmap {'<leader>cr', function() vim.lsp.buf.rename() end, bufnr = bufnr }

	nmap {'<leader>cgD', function() vim.lsp.buf.declaration() end, bufnr = bufnr }
	nmap {'<leader>cgd', function() vim.lsp.buf.definition() end, bufnr = bufnr }
	nmap {'<leader>cgi', function() vim.lsp.buf.implementation() end, bufnr = bufnr }
	nmap {'<leader>cgr', function() vim.lsp.buf.references() end, bufnr = bufnr }
	nmap {'<leader>cgt', function() vim.lsp.buf.type_definition() end, bufnr = bufnr }

	nmap {'<leader>cwa', function() vim.lsp.buf.add_workspace_folder() end, bufnr = bufnr }
	nmap {'<leader>cwd', function() vim.lsp.buf.remove_workspace_folder() end, bufnr = bufnr }
end

local cmp = prequire'cmp'
if cmp then
	cmp.setup.filetype('gitcommit', {
		sources = cmp.config.sources({
			{ name = 'cmp_git' },
			}, {
				{ name = 'buffer' },
		})
	})
end

local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
lsp('rust_analyzer', {
	on_attach = night.on_attach,
	capabilities = capabilities,
	flags = {
		debounce_text_changes = 150,
	}
})
