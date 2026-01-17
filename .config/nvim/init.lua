local opt = vim.opt
opt.number = true
opt.relativenumber = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.smartindent = true
opt.termguicolors = true
opt.cursorline = true
opt.mouse = 'a'
opt.ignorecase = true
opt.smartcase = true

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
  { "nvim-tree/nvim-tree.lua", dependencies = { "nvim-tree/nvim-web-devicons" } },
  { "nvim-lualine/lualine.nvim", dependencies = { "nvim-tree/nvim-web-devicons" } },
  { "akinsho/bufferline.nvim", version = "*", dependencies = "nvim-tree/nvim-web-devicons" },
  { "windwp/nvim-autopairs", event = "InsertEnter" },
  { "numToStr/Comment.nvim" },
  { "neovim/nvim-lspconfig" },
  { "williamboman/mason.nvim" },
  { "williamboman/mason-lspconfig.nvim" },
  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-buffer" },
  { "hrsh7th/cmp-path" },
  { "L3MON4D3/LuaSnip" },
  { "saadparwaiz1/cmp_luasnip" },
  { "stevearc/conform.nvim" },
})

vim.cmd.colorscheme "catppuccin-mocha"

require("nvim-autopairs").setup({})
require("Comment").setup()
require("nvim-tree").setup()
require("lualine").setup({ options = { theme = "catppuccin" } })
require("bufferline").setup({})

require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = { "pyright", "ts_ls" }
})

local cmp = require('cmp')
cmp.setup({
  snippet = { expand = function(args) require('luasnip').lsp_expand(args.body) end },
  mapping = cmp.mapping.preset.insert({
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  }, {
    { name = 'buffer' },
    { name = 'path' },
  })
})

local capabilities = require('cmp_nvim_lsp').default_capabilities()

vim.lsp.config('pyright', { capabilities = capabilities })
vim.lsp.enable('pyright')

vim.lsp.config('ts_ls', { capabilities = capabilities })
vim.lsp.enable('ts_ls')

require("conform").setup({
  formatters_by_ft = {
    python = { "isort", "black" },
    javascript = { "prettierd", "prettier" },
  },
  format_on_save = { timeout_ms = 500, lsp_fallback = true },
})

vim.keymap.set('n', '<C-n>', ':NvimTreeToggle<CR>')
vim.keymap.set('n', '<leader>f', function() require("conform").format() end)
vim.keymap.set('n', 'L', ':BufferLineCycleNext<CR>')
vim.keymap.set('n', 'H', ':BufferLineCyclePrev<CR>')
