-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'
  use 'folke/tokyonight.nvim'
--  use {'github/copilot.vim', branch = 'release' }
  use 'lervag/vimtex'
  use 'tpope/vim-surround'
  use 'jiangmiao/auto-pairs'
  use '/SirVer/ultisnips'
  use 'KeitaNakamura/tex-conceal.vim'
  use 'neovim/nvim-lspconfig'
  use 'nvim-lua/completion-nvim'
  use 'honza/vim-snippets'
  use {'neoclide/coc.nvim', branch = 'release', run = ':CocUpdate'}
  use 'rafcamlet/coc-nvim-lua'


end)
