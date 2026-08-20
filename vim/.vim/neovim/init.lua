---------
--THEME--
---------

vim.cmd("colorscheme noggyscheme")

--------------
--TREESITTER--
--------------

vim.opt.rtp:prepend("plugins/nvim_treesitter/nvim-treesitter/lua/nvim-treesitter.lua")
require 'nvim-treesitter.install'.prefer_git = false
require 'nvim-treesitter.install'.compilers = { "clang" }
require 'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all" (the listed parsers MUST always be installed)
  ensure_installed = { "c", "cpp", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline" },
  --ensure_installed = { "c", "cpp" },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,

  -- List of parsers to ignore installing (or "all")
  ignore_install = { "javascript" },

  ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
  -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

  highlight = {
    enable = true,

    -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
    -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
    -- the name of the parser)
    -- list of language that will be disabled
    disable = { "rust" },
    -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
    disable = function(lang, buf)
        local max_filesize = 100 * 1024 -- 100 KB
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
            return true
        end
    end,

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}




-------------
--LSPCONFIG--
-------------

require 'lspconfig'.clangd.setup({
  cmd = {'clangd', '--background-index', '--clang-tidy', '--log=verbose'},
  init_options = {
    fallbackFlags = { '-std=c++20' },
  },
})
vim.diagnostic.config({
  signs = false,
  underline = true,
  update_in_insert = false,
  virtual_text = false,
  severity_sort = true,
})

-- UNSURE IF THIS IS NEEDED OR WANTED
-- Set up lspconfig.
--local capabilities = require('cmp_nvim_lsp').default_capabilities()
--require('lspconfig')['clang'].setup { capabilities = capabilities }




-------
--cmp--
-------

--- This contains settings for ALL cmp related settings
--- Currently cmp plugins in use:
--- * nvim-cmp:     Completion engine for neovim
--- * cmp-buffer:   nvim-cmp for buffer words
--- * cmp-cmdline:  nvim-cmp for vim's cmdline
--- * cmp-nvim-lsp: nvim-cmp for neovim's built-in language server client
--- * cmp-path:     nvim-cmp for filesystem paths
--- * cmp-vsnip:    nvim-cmp for vim-vsnip

require'cmp'.setup { sources = { { name = 'nvim_lsp' } } }
require'cmp'.setup { sources = { { name = 'vsnip' } } }

-- Set up nvim-cmp.
local cmp = require'cmp'

cmp.setup({
    snippet = {
        -- REQUIRED - you must specify a snippet engine
        expand = function(args)
            vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
            -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
            -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
            -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
            -- vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)

            -- For `mini.snippets` users:
            -- local insert = MiniSnippets.config.expand.insert or MiniSnippets.default_insert
            -- insert({ body = args.body }) -- Insert at cursor
            -- cmp.resubscribe({ "TextChangedI", "TextChangedP" })
            -- require("cmp.config").set_onetime({ sources = {} })
        end,
    },
    window = {
        completion = cmp.config.window.bordered(),
        --documentation = {max_height = 10},
        --documentation = cmp.config.window.bordered(),
    },
    --mapping = cmp.mapping.preset.insert({
    --    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    --    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    --    ['<C-Space>'] = cmp.mapping.complete(),
    --    --['<Tab>'] = cmp.mapping.complete(),
    --    ['<C-e>'] = cmp.mapping.abort(),
    --    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    --}),
    mapping = {
        -- add 'c' to make it work in cmdline
        ['<C-j>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 's', 'c' }),
        -- or this form
        ['<C-k>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 's', 'c' }),
        -- also, inside a closure, you can't use `cmp.mapping` helper, instead, use cmp function directly
        ['<C-c>'] = function(fallback)
            cmp.abort() -- instead of cmp.mapping.abort()
            fallback()
        end,
    },
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'vsnip' }, -- For vsnip users.
        -- { name = 'luasnip' }, -- For luasnip users.
        -- { name = 'ultisnips' }, -- For ultisnips users.
        -- { name = 'snippy' }, -- For snippy users.
    }, {
        { name = 'buffer' },
    })
})

-- To use git you need to install the plugin petertriho/cmp-git and uncomment lines below
-- Set configuration for specific filetype.
--[[ cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
        { name = 'git' },
    }, {
        { name = 'buffer' },
    })
})
require("cmp_git").setup() ]]--

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' }
    }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'path' }
    }, {
        { name = 'cmdline' }
    }),
    matching = { disallow_symbol_nonprefix_matching = false }
})
