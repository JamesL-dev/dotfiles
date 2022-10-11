vim.opt.guicursor = ""
-- vim.opt.filetype-plugin-on = true
vim.opt.encoding = "utf-8"

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.smartindent = true
vim.opt.wrap = false

-- Set Leader to space
vim.g.mapleader = ' '

vim.opt.syntax = "on"

-- Key remapping
local keyset = vim.keymap.set
vim.g.localleader = ","
vim.api.nvim_set_keymap("i", "<c-v>", [[copilot#Accept("\<c-v>")]], {
    expr = true,
    silent = true,
    script = true
})

-- Vimtex Config
vim.g.tex_flavor = 'latex'
vim.g.vimtex_view_method = 'zathura'
vim.g.vimtex_view_general_viewer = 'zathura'
vim.g.vimtex_quickfix_mode = 0
vim.g.tex_conceal = 'abdmgs'
vim.g.indentLine_setConceal = 0

-- Ultisnips
vim.g.completion_enable_snippet = 'Ultisnips'
vim.g.Ultisnips = '<tab>'
vim.g.JumpForwardTrigger = '<tab>'
vim.g.JumpBackwardTrigger = '<s-tab>'

-- coc settings
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.updatetime = 300
vim.api.nvim_create_user_command("Format", "call CocAction('format')", {})

vim.g.coc_global_extensions = {
    'coc-java', 'coc-rust-analyzer', 'coc-css', 'coc-vimlsp',
    'coc-tsserver', 'coc-snippets', 'coc-emmet', 'coc-json', 'coc-texlab'
}

function _G.check_back_space()
    local col = vim.fn.col('.') - 1
    return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s')
end

function _G.show_docs()
    local cw = vim.fn.expand('<cword>')
    if vim.fn.index({'vim', 'help'}, vim.bo.filetype) >= 0 then
        vim.api.nvim_command('h ' .. cw)
    elseif vim.api.nvim_eval('coc#rpc#ready()') then
        vim.fn.CocActionAsync('doHover')
    else
        vim.api.nvim_command('!' .. vim.o.keywordprg .. ' ' .. cw)
    end
end

-- auto complete
local opts = {silent = true, noremap = true, expr = true}
vim.api.nvim_set_keymap("i", "<TAB>",
                        'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<TAB>" : coc#refresh()', opts)
vim.api.nvim_set_keymap("i", "<S-TAB>",
                        [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], opts)
vim.api.nvim_set_keymap("i", "<cr>",
                        [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]], opts)
keyset("i", "<c-j>", "<Plug>(coc-snippets-expand-jump)")
keyset("i", "<c-space>", "coc#refresh()", {silent = true, expr = true})

-- scroll through documentation
---@diagnostic disable-next-line: redefined-local
local opts = {silent = true, nowait = true, expr = true}
keyset("n", "<C-f>", 'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-f>"', opts)
keyset("n", "<C-b>", 'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-b>"', opts)
keyset("i", "<C-f>", 'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(1)<cr>" : "<Right>"', opts)
keyset("i", "<C-b>", 'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(0)<cr>" : "<Left>"', opts)
keyset("v", "<C-f>", 'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-f>"', opts)
keyset("v", "<C-b>", 'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-b>"', opts)

-- go to definition and other things
keyset("n", "K", '<CMD>lua _G.show_docs()<CR>', {silent = true})
keyset("n", "<c-k>", "<Plug>(coc-rename)", {silent = true})
keyset("n", "[g", "<Plug>(coc-diagnostic-prev)", {silent = true})
keyset("n", "]g", "<Plug>(coc-diagnostic-next)", {silent = true})
keyset("n", "gd", "<Plug>(coc-definition)", {silent = true})
keyset("n", "gy", "<Plug>(coc-type-definition)", {silent = true})
keyset("n", "gi", "<Plug>(coc-implementation)", {silent = true})
keyset("n", "gr", "<Plug>(coc-references)", {silent = true})

-- code actions and coc stuff
---@diagnostic disable-next-line: redefined-local
local opts = {silent = true, nowait = true}
keyset("n", "<space>a", "<Plug>(coc-codeaction-cursor)", opts)
keyset("x", "<space>a", "<Plug>(coc-codeaction-selected)", opts)
keyset("n", "<space>g", "<Plug>(coc-codelens-action)", opts)
keyset("n", "<space>f", "<Plug>(coc-fix-current)", opts)
keyset("n", "<space>d", ":<C-u>CocList diagnostics<cr>", opts)
keyset("n", "<space>e", ":<C-u>CocList extensions<cr>", opts)
keyset("n", "<space>c", ":<C-u>CocList commands<cr>", opts)
keyset("n", "<space>o", ":<C-u>CocList outline<cr>", opts)
keyset("n", "<space>q", ":<C-u>CocList<cr>", opts)

vim.api.nvim_create_augroup("CocGroup", {})
vim.api.nvim_create_autocmd("FileType", {
    group = "CocGroup",
    pattern = "typescript,json",
    command = "setl formatexpr=CocAction('formatSelected')",
    desc = "Setup formatexpr specified filetype(s)."
})
vim.api.nvim_create_autocmd("User", {
    group = "CocGroup",
    pattern = "CocJumpPlaceholder",
    command = "call CocActionAsync('showSignatureHelp')",
    desc = "Update signature help on jump placeholder"
})
vim.api.nvim_create_autocmd("CursorHold", {
    group = "CocGroup",
    command = "silent call CocActionAsync('highlight')",
    desc = "Highlight symbol under cursor on CursorHold"
})
