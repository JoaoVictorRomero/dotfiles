vim.g.mapleader = " "
vim.g.maplocalleader = ' '
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.wo.number = true
vim.wo.relativenumber = true
--- vim.o.hlsearch = false
vim.o.mouse = 'a'
vim.o.clipboard = 'unnamedplus'
vim.o.breakindent = true
vim.o.termguicolors = true
vim.o.completeopt = 'menuone,noselect'
vim.api.nvim_set_keymap('n', '<leader>v', ':Ex<CR>', {noremap = true, silent = true})
vim.opt.conceallevel = 1

vim.api.nvim_set_keymap('n', '<CR>', ':noh<CR><CR>', { noremap = true, silent = true })

vim.g.airline_theme = 'luna'


local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)


require("lazy").setup({
  'tpope/vim-sleuth',
  {
    "windwp/nvim-autopairs",
    -- Optional dependency
    dependencies = { 'hrsh7th/nvim-cmp' },
    config = function()
      require("nvim-autopairs").setup {}
      -- If you want to automatically add `(` after selecting a function or method
      local cmp_autopairs = require('nvim-autopairs.completion.cmp')
      local cmp = require('cmp')
      cmp.event:on(
      'confirm_done',
      cmp_autopairs.on_confirm_done()
      )
    end,
  },

  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" }
  },
  { 'matze/vim-move' },
  {
    'echasnovski/mini.surround',
    config = function ()
      require('mini.surround').setup({
        mappings = {
          add = 'gsa', -- Add surrounding in Normal and Visual modes
          delete = 'gsd', -- Delete surrounding
        },
      })
    end
  },

  {
    'numToStr/Comment.nvim',
    lazy = false,
  },

  {import = 'after.plugin'},
}, {})

vim.cmd('colorscheme carbonfox')
require('Comment').setup()

local harpoon = require("harpoon")

-- REQUIRED
harpoon:setup()
-- REQUIRED

vim.keymap.set("n", "<leader>e", function() harpoon:list():append() end)
vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

vim.keymap.set("n", "<M-1>", function() harpoon:list():select(1) end)
vim.keymap.set("n", "<M-2>", function() harpoon:list():select(2) end)
vim.keymap.set("n", "<M-3>", function() harpoon:list():select(3) end)
vim.keymap.set("n", "<M-4>", function() harpoon:list():select(4) end)

local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(client, bufnr)
  -- see :help lsp-zero-keybindings
  -- to learn the available actions
  lsp_zero.default_keymaps({buffer = bufnr})
end)

--- if you want to know more about lsp-zero and mason.nvim
--- read this: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/guides/integrate-with-mason-nvim.md
require('mason').setup({})
require('mason-lspconfig').setup({
  handlers = {
    lsp_zero.default_setup,
  },
})

local cmp = require('cmp')

cmp.setup({
  preselect = 'item',
  completion = {
    completeopt = 'menu,menuone,noinsert'
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  }
})

lsp_zero.on_attach(function(client, bufnr)
  local opts = {buffer = bufnr, remap = false}

  vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
  vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
  vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
  vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
  vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
  vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
  vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
  vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
  vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
  vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
end)


local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})


function ToggleLSP()
    local clients = vim.lsp.get_active_clients()
    if next(clients) == nil then
        vim.cmd('LspStart')
    else
        vim.cmd('LspStop')
    end
end

vim.api.nvim_set_keymap('n', '<leader>l', ':lua ToggleLSP()<CR>', {noremap = true, silent = true})



vim.cmd [[
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif 
]]
