-- I jUsT wAnT tO sEaRcH
vim.o.ignorecase = true
-- > They hated Jesus because he told them the truth
-- Gal. 4:16
vim.o.mouse = 'nv'
-- Let me get my glasses
vim.o.cursorline = true
vim.o.cursorlineopt = 'screenline'
vim.o.cursorcolumn = true
-- Wait? How many lines above is the bible quote?
vim.o.number = true
vim.o.relativenumber = true
-- Stop living in the 60's, JSX gets too indented
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = false
-- Fuck the stupid swap files, I'm always in a tmux session
vim.o.swapfile = false
-- Fuck, what was the function definiton just above my cursor
vim.o.scrolloff = 4
vim.o.splitbelow = true
vim.o.splitright = true

vim.g.mapleader = ' '

local keymap = function(tbl)
	-- Some sane default options
	local opts = { noremap = true, silent = true }
	-- Dont want these named fields on the options table
	local mode = tbl['mode']
	tbl['mode'] = nil
	local bufnr = tbl['bufnr']
	tbl['bufnr'] = nil

	for k, v in pairs(tbl) do
		if tonumber(k) == nil then
			opts[k] = v
		end
	end


	if bufnr ~= nil then
		vim.api.nvim_buf_set_keymap(bufnr, mode, tbl[1], tbl[2], opts)
	else
		vim.api.nvim_set_keymap(mode, tbl[1], tbl[2], opts)
	end
end

local nmap = function(tbl)
	tbl['mode'] = 'n'
	keymap(tbl)
end

local vmap = function(tbl)
	tbl['mode'] = 'v'
	keymap(tbl)
end

local imap = function(tbl)
	tbl['mode'] = 'i'
	keymap(tbl)
end

require('packer').startup(function(use)
	-- Recursion!
	use 'wbthomason/packer.nvim'

	-- Flames for the knockoff Copilot
	use 'neovim/nvim-lspconfig'

	-- Knockoff Copilot
	use {
		'hrsh7th/nvim-cmp',
		'hrsh7th/cmp-nvim-lsp',
		'hrsh7th/cmp-buffer',
		'hrsh7th/cmp-cmdline',
		'hrsh7th/cmp-path'
	}

	-- Snip Snip ✂️
	use {
		'L3MON4D3/LuaSnip',
		'saadparwaiz1/cmp_luasnip'
	}

	-- Fuzzy Finding to the moon
	use {
		'nvim-telescope/telescope.nvim',
		requires = {
			'nvim-lua/popup.nvim',
			'nvim-lua/plenary.nvim'
		},
		{ 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
		'nvim-telescope/telescope-file-browser.nvim',
		'~/projects/local/projects.nvim'
	}

	-- Wait, that's illegal
	use {
		'TimUntersberger/neogit',
		requires = {
			'nvim-lua/plenary.nvim'
		}
	}

	-- Neovim and Syntax sitting in a tree K-I-S-S-I-N-G
	use {
		'nvim-treesitter/nvim-treesitter',
		run = ':TSUpdate',
		config = function()
			require'nvim-treesitter.configs'.setup {
				ensure_installed = 'maintained',
				highlight = { enable = true },
				indent = { enable = true }
			}
		end,
	}

	use 'haya14busa/incsearch.vim'
	use 'vimlab/split-term.vim'

	use 'nvim-treesitter/playground'

	-- Something funny about colors
	use 'ap/vim-css-color'

	-- Pretty Pretty
	use {
		'~/projects/local/henna.nvim',
		requires = {
			'tjdevries/colorbuddy.nvim'
		}
	}

	-- Which Key
	use {
		"folke/which-key.nvim",
		config = function()
			require("which-key").setup {
				-- your configuration comes here
				-- or leave it empty to use the default settings
				-- refer to the configuration section below
			}
		end
	}
end)



require('colorbuddy').colorscheme('henna')

require('telescope').load_extension'file_browser'
require('telescope').load_extension'projects'

-- F: Files
-- File Find
nmap{'<leader>ff', ':lua require"telescope.builtin".find_files()<CR>'}
nmap{'<leader>fh', ':lua require"telescope.builtin".find_files({hidden = true})<CR>'}
-- File Git find
nmap{'<leader>fg', ':lua require"telescope.builtin".git_files()<CR>'}
-- File Browser
nmap{'<leader>fb', ':Telescope file_browser path=%:p:h<CR>'}
nmap{'<leader>fd', ':Telescope file_browser path=%:p:h files=false<CR>'}
-- File Private (config)
nmap{'<leader>fp', ':Telescope file_browser path=~/.config/nvim<CR>'}
-- File find String
nmap{'<leader>fs', ':lua require"telescope.builtin".live_grep()<CR>'}

-- P: Projects
-- Project find
nmap{'<leader>pp', ':Telescope projects<CR>'}

-- B: Buffers
nmap{'<leader>bb', ':lua require"telescope.builtin".buffers()<CR>'}
nmap{'<leader>bn', ':bnext<CR>'}
nmap{'<leader>bp', ':bprevious<CR>'}
nmap{'<leader>bd', ':bdelete<CR>'}
nmap{'<leader>bq', ':setl bufhidden=delete | bnext!<CR>'}

-- T: Terminal
nmap{'<leader>to', ':10Term<CR>'}

-- N: Neovim
nmap{'<leader>nr', ':luafile ~/.config/nvim/init.lua<CR>'}
nmap{'<leader>ne', ':edit ~/.config/nvim/init.lua<CR>'}

-- W: Window
nmap{'<leader>wh', '<C-W>h'}
nmap{'<leader>wj', '<C-W>j'}
nmap{'<leader>wk', '<C-W>k'}
nmap{'<leader>wl', '<C-W>l'}
nmap{'<leader>wsv', ':vsplit<CR>'}
nmap{'<leader>wsh', ':split<CR>'}
nmap{'<leader>wq', ':quit<CR>'}

-- G: Git
nmap{'<leader>gg', ':Neogit<CR>'}


-- C: Code
nmap {'<leader>cd', ':lua vim.diagnostic.open_float()<CR>'}
-- C-G: Code Goto
nmap {'<leader>cgp', ':lua vim.diagnostic.goto_prev()<CR>'}
nmap {'<leader>cgn', ':lua vim.diagnostic.goto_next()<CR>'}
-- C-W: Code Workspace
nmap {'<leader>cwt', ':TSHighlightCapturesUnderCursor<CR>'}
nmap {'<leader>cws', ':source<CR>'}
vmap {'<leader>cws', ":'<,'>source<CR>"}

-- highlight yanked text for 200ms using the "Visual" highlight group
vim.cmd[[
augroup highlight_yank
autocmd!
au TextYankPost * silent! lua vim.highlight.on_yank({higroup="Visual", timeout=400})
augroup END
]]

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

vim.cmd[[
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)
set hlsearch
let g:incsearch#auto_nohlsearch = 1
map n  <Plug>(incsearch-nohl-n)
map N  <Plug>(incsearch-nohl-N)
map *  <Plug>(incsearch-nohl-*)
map #  <Plug>(incsearch-nohl-#)
map g* <Plug>(incsearch-nohl-g*)
map g# <Plug>(incsearch-nohl-g#)
]]

vim.api.nvim_create_user_command('W', ':execute ":silent w !sudo tee % > /dev/null" | :edit!', {})

-- LSP Setup

local on_attach = function(client, bufnr)
	print('Attaching: ' .. client.name .. ' to buffer: ' .. tostring(bufnr))

	vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

	-- C: Code
	nmap {'<leader>ca', ':lua vim.lsp.buf.code_action()<CR>', bufnr = bufnr }
	nmap {'<leader>cf', ':lua vim.lsp.buf.formatting()<CR>', bufnr = bufnr }
	nmap {'<leader>ch', ':lua vim.lsp.buf.hover()<CR>', bufnr = bufnr }
	nmap {'<leader>cr', ':lua vim.lsp.buf.rename()<CR>', bufnr = bufnr }

	-- C-G: Code Goto
	nmap {'<leader>cgD', ':lua vim.lsp.buf.declaration()<CR>', bufnr = bufnr }
	nmap {'<leader>cgd', ':lua vim.lsp.buf.definition()<CR>', bufnr = bufnr }
	nmap {'<leader>cgi', ':lua vim.lsp.buf.implementation()<CR>', bufnr = bufnr }
	nmap {'<leader>cgr', ':lua vim.lsp.buf.references()<CR>', bufnr = bufnr }
	nmap {'<leader>cgt', ':lua vim.lsp.buf.type_definition()<CR>', bufnr = bufnr }

	-- C-W: Code Workspace
	nmap {'<leader>cwa', ':lua vim.lsp.buf.add_workspace_folder()<CR>', bufnr = bufnr }
	nmap {'<leader>cwd', ':lua vim.lsp.buf.remove_workspace_folder()<CR>', bufnr = bufnr }
	nmap {'<leader>cwl', ':lua printvim.inspectvim.lsp.buf.list_workspace_folders()<CR>', bufnr = bufnr }
end

-- cmp setup
local cmp = require'cmp'

cmp.setup({
	snippet = {
		expand = function(args)
			require('luasnip').lsp_expand(args.body)
		end,
	},
	mapping = {
		['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
		['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
		['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
		['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
		['<C-e>'] = cmp.mapping({
			i = cmp.mapping.abort(),
			c = cmp.mapping.close(),
		}),
		['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
	},
	sources = cmp.config.sources({
		{ name = 'nvim_lsp' },
		{ name = 'luasnips' },
		{ name = 'buffer' }
	})
})

cmp.setup.filetype('gitcommit', {
	sources = cmp.config.sources({
		{ name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it. 
		}, {
			{ name = 'buffer' },
	})
})

local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

require('lspconfig').rust_analyzer.setup {
	on_attach = on_attach,
	capabilities = capabilities,
	flags = {
		debounce_text_changes = 150,
	}
}

require('lspconfig').sumneko_lua.setup {
	on_attach = on_attach,
	-- capabilities = capabilities,
	flags = {
		debounce_text_changes = 150,
	},
	settings = {
		Lua = {
			runtime = {
				-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
				version = 'LuaJIT',
				-- Setup your lua path
				path = runtime_path,
			},
			diagnostics = {
				-- Get the language server to recognize the `vim` global
				globals = {'vim'},
			},
			workspace = {
				-- Make the server aware of Neovim runtime files
				library = vim.api.nvim_get_runtime_file("", true),
				checkThirdParty = false,
			},
			-- Do not send telemetry data containing a randomized but unique dentifier
			telemetry = {
				enable = false,
			},
		},
	},
}
