" Vim-Plug configuration ======================================================

let g:plug_shallow=0

function! CondPlugin(cond, ...)
    " Allows for conditional use of plugins
    " e.g. Plug 'benekastah/neomake', Cond(has('nvim'), { 'on': 'Neomake' })
    let opts = get(a:000, 0, {})
    return a:cond ? opts : extend(opts, { 'on': [], 'for': [] })
endfunction

" Plugins List
call plug#begin('~/.local/share/nvim/plugged')

  " UI related
  Plug 'chriskempson/base16-vim'
  Plug 'scrooloose/nerdtree'
  Plug 'ctrlpvim/ctrlp.vim'
  Plug 'machakann/vim-highlightedyank'
  Plug 'itchyny/lightline.vim'
  Plug 'taohexxx/lightline-buffer'

  " colorschemes
  Plug 'phanviet/vim-monokai-pro'
  Plug 'patstockwell/vim-monokai-tasty'
  Plug 'nerdypepper/vim-colors-plain', { 'branch': 'duotone' }
  Plug 'challenger-deep-theme/vim', { 'as': 'challenger-deep' }

  "tmux
  Plug 'christoomey/vim-tmux-navigator'

  " repl
  Plug 'Vigemus/iron.nvim'

  " Better Visual Guide
  Plug 'Yggdroot/indentLine'

  " Autocomplete
  Plug 'neoclide/coc.nvim', { 'branch': 'release' }
  Plug 'SirVer/ultisnips'

  " Devicon glyphs for Nerdtree
  Plug 'ryanoasis/vim-devicons'

  " YAML support
  Plug 'stephpy/vim-yaml'

  " Testing
  Plug 'vim-test/vim-test'

  " Writing
  Plug 'vimwiki/vimwiki'
  Plug 'lervag/vimtex'

  call plug#end()

set encoding=UTF-8

filetype plugin indent on

"####################################################################
"##################### General vim settings #########################
"####################################################################

" Orientation
set cursorline
set ruler
set colorcolumn=80

"set termguicolors
set number
set relativenumber
set hidden
set mouse=a
set noshowmode
set noshowmatch
set nolazyredraw

" Turn off backup
set nobackup
set noswapfile
set nowritebackup

" Search configuration
set ignorecase                    " ignore case when searching
set smartcase                     " turn on smartcase

" Tab and Indent configuration
filetype plugin indent on
set expandtab
set sw=4
set tabstop=4
set shiftwidth=4
set softtabstop=4
set autoindent
set smartindent
set wrap

" colorscheme
set background=dark
colorscheme challenger_deep 
"highlight clear LineNr
"highlight clear SignColumn

" leader key
nnoremap <SPACE> <Nop>
let mapleader=" "
nmap <leader>q :q<CR>
nmap <leader>w :w<CR>
nmap <leader>x :x<CR>

" NERDTree configs
map <C-n> :NERDTreeToggle<CR>
nnoremap <Leader>pt :NERDTreeToggle<Enter>
nnoremap <silent> <Leader>pv :NERDTreeToggle<CR>
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'

" UltiSnips
let g:UltiSnipsSnippetDirectories=['/home/christovis/.ultisnips/']

" Lightline
let g:lightline = {
      \ 'colorscheme': 'challenger_deep',
      \ }

" .rasi syntax
au BufNewFile,BufRead /*.rasi setf css

" Control vim window splits with Alt + Arrow
map <leader>k  :wincmd k<CR>
map <leader>j  :wincmd j<CR>
map <leader>h  :wincmd h<CR>
map <leader>l  :wincmd l<CR>

" Vim tabs
" Go to tab by number
noremap <leader>1 1gt
noremap <leader>2 2gt
noremap <leader>3 3gt
noremap <leader>4 4gt
noremap <leader>5 5gt
noremap <leader>6 6gt
noremap <leader>7 7gt
noremap <leader>8 8gt
noremap <leader>9 9gt
noremap <leader>0 :tablast<cr>

" Clipboard management
" Copy to system clipboard
vnoremap  <leader>y  "+y
vnoremap  <leader>Y  "+yg$
nnoremap  <leader>y  "+y
nnoremap  <leader>yy  "+yy

" Paste from system clipboard
nnoremap <leader>p :set paste<CR> "+p :set nopaste<CR>
nnoremap <leader>P :set paste<CR> "+P :set nopaste<CR>
vnoremap <leader>p :set paste<CR> "+p :set nopaste<CR>
vnoremap <leader>P :set paste<CR> "+P :set nopaste<CR>

" Spellchecking Configuration
set spell
set spelllang=en_gb

" UI configuration
syntax on
syntax enable

" True Color Support if it's avaiable in terminal
if has("termguicolors")
    set termguicolors
endif


"####################################################################
"######################### Python settings ##########################
"####################################################################
" Black
nmap <leader>b :Black<CR>
" test mappings
nmap <silent> <leader>tn :TestNearest<CR>
nmap <silent> <leader>tf :TestFile<CR>
nmap <silent> <leader>ts :TestSuite<CR>
nmap <silent> <leader>tl :TestLast<CR>
nmap <silent> <leader>tv :TestVisit<CR>
let test#strategy = "vimux"

"####################################################################
"########################### coc settings ###########################
"####################################################################
" TextEdit might fail if hidden is not set.

"disable in julia
autocmd BufNew,BufEnter *.jl execute "silent! CocDisable"
autocmd BufLeave *.jl execute "silent! CocEnable"

" Give more space for displaying messages.
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  imap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current line.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Introduce function text object
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

" Use <TAB> for selections ranges.
" NOTE: Requires 'textDocument/selectionRange' support from the language server.
" coc-tsserver, coc-python are the examples of servers that support it.
nmap <silent> <TAB> <Plug>(coc-range-select)
xmap <silent> <TAB> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings using CoCList:
" Show all diagnostics.
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>
