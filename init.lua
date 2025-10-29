-- Globals
vim.g.mapleader = " ";
local neovim_config = "~/.config/nvim/init.lua";

-- Options
vim.o.number = true;
vim.o.relativenumber = true;
vim.o.wrap = false;
vim.o.winborder = "rounded";
vim.o.smartindent = true;
vim.o.mouse = ""

-- Keymaps
local map = vim.keymap.set
map("n", "<leader>o", ":update<CR>:source<CR>");         -- Source current lua file
map("n", "<leader>lf", vim.lsp.buf.format);              -- Format current buffer
map("n", "<leader>e", ":Explore<CR>");                   -- Navigation
map("n", "<C-9>", "<C-]>")                               -- Re-map tag key binding to work on nordic keyboard layout
map("n", "<leader>nc", ":e " .. neovim_config .. "<CR>") -- Edit neovim config
map("", "<up>", "<nop>", { noremap = true })             -- Disable arrow keys
map("", "<down>", "<nop>", { noremap = true })           -- Disable arrow keys
map("", "<left>", "<nop>", { noremap = true })           -- Disable arrow keys
map("", "<right>", "<nop>", { noremap = true })          -- Disable arrow keys
map("i", "<up>", "<nop>", { noremap = true })            -- Disable arrow keys
map("i", "<down>", "<nop>", { noremap = true })          -- Disable arrow keys
map("i", "<left>", "<nop>", { noremap = true })          -- Disable arrow keys
map("i", "<right>", "<nop>", { noremap = true })         -- Disable arrow keys

-- Packages
vim.pack.add({
  { src = "https://github.com/neovim/nvim-lspconfig" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
  { src = "https://github.com/nvim-telescope/telescope.nvim" },
  { src = "https://github.com/nvim-lua/plenary.nvim" },
  { src = "https://github.com/Mofiqul/dracula.nvim" },
})

-- Appearance
require "dracula".setup({
  colors = {
    bg = "#000000",
  }
})
vim.cmd(":colorscheme dracula")
vim.cmd(":highlight statusline guibg=none")

-- Language Configuration
vim.lsp.enable({ "lua_ls", "clangd", "pylsp", "puppet" })
vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true)
      }
    }
  }
})
vim.lsp.config("puppet", {})
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
    if client then
      if client:supports_method('textDocument/completion') then
        vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
      end
    end
    if not client:supports_method('textDocument/willSaveWaitUntil') and client:supports_method('textDocument/formatting') then
      vim.api.nvim_create_autocmd('BufWritePre', {
        group = vim.api.nvim_create_augroup('my.lsp', { clear = false }),
        buffer = args.buf,
        callback = function()
          vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 1000 })
        end,
      })
    end
  end,
})
vim.cmd("set completeopt+=noselect") -- Remove selection of first option

-- Treesitter
require "nvim-treesitter.configs".setup({
  ensure_installed = { "lua" },
  highlight = { enable = true },
  indent = { enable = true },
  auto_install = true,
  modules = {},
  sync_install = true,
  ignore_install = {},
})

-- Telescope
local telescope_builtin = require "telescope.builtin"
require('telescope').setup({
  defaults = {
    layout_config = {
      width = { padding = 0 },
      height = { padding = 0 },
    },
  },
})
map('n', '<leader>ff', telescope_builtin.find_files) -- Telescope find files
map('n', '<leader>fg', telescope_builtin.live_grep)  -- Telescope live grep
map('n', '<leader>fb', telescope_builtin.buffers)    -- Telescope buffers
map('n', '<leader>fh', telescope_builtin.help_tags)  -- Telescope help tags
