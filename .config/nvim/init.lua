------------------------------------------------------
-- 			This config is built using              --
-- [NightVim](https://github.com/nyxkrage/NightVim) --
------------------------------------------------------
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
	night.log.info('[LSP][' .. client.name .. '] Attaching to buffer: ' .. bufnr)

	vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

	nmap {'<leader>ca', function() vim.lsp.buf.code_action() end, buffer = bufnr }
	nmap {'<leader>cf', function() vim.lsp.buf.formatting() end, buffer = bufnr }
	nmap {'<leader>ch', function() vim.lsp.buf.hover() end, buffer = bufnr }
	nmap {'<leader>cr', function() vim.lsp.buf.rename() end, buffer = bufnr }

	nmap {'<leader>cgD', function() vim.lsp.buf.declaration() end, buffer = bufnr }
	nmap {'<leader>cgd', function() vim.lsp.buf.definition() end, buffer = bufnr }
	nmap {'<leader>cgi', function() vim.lsp.buf.implementation() end, buffer = bufnr }
	nmap {'<leader>cgr', function() vim.lsp.buf.references() end, buffer = bufnr }
	nmap {'<leader>cgt', function() vim.lsp.buf.type_definition() end, buffer = bufnr }

	nmap {'<leader>cwa', function() vim.lsp.buf.add_workspace_folder() end, buffer = bufnr }
	nmap {'<leader>cwd', function() vim.lsp.buf.remove_workspace_folder() end, buffer = bufnr }
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

local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")
table.insert(runtime_path, vim.env.VIM .. "/sysinit.lua")
night.lsp('sumneko_lua', {
	on_attach = night.on_attach,
	flags = {
		debounce_text_changes = 150,
	},
	settings = {
		Lua = {
			runtime = {
				version = 'LuaJIT',
				path = runtime_path,
			},
			diagnostics = {
				globals = {
					'vim',
					'night'
				},
			},
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
				checkThirdParty = false,
			},
			telemetry = {
				enable = false,
			},
		},
	},
})

local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
lsp('rust_analyzer', {
	on_attach = night.on_attach,
	capabilities = capabilities,
	flags = {
		debounce_text_changes = 150,
	}
})
