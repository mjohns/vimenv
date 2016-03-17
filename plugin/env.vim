set expandtab
set shiftwidth=2
set softtabstop=2
set tabstop=2

set incsearch
set hlsearch
set number
set smartcase
set scrolloff=6
set wildmode=longest:full
set wildmenu
set ic

" code completion
set completeopt=longest,menuone
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

map gl $
map gh ^
map gk [{
map gj ]}

" In visual mode make J/K just j/k so when you do V and don't
" release shift before starting to highlight lines it will
" behave as expected
vmap J j
vmap K k

" Make it so x does not put the deleted char in the default buffer overwriting
" what you previously yanked
noremap x "_x

" Make it so x does not put the deleted char in the default buffer overwriting
" what you previously yanked
noremap x "_x

map <tab> =

" set up the status line to not show full relative path of file and to highlight
" the name for the active buffer
set laststatus=2
set statusline=   " clear the statusline for when vimrc is reloaded
set statusline+=%-3.3n\                      " buffer number
set statusline+=%t\                          " file name
set statusline+=%h%m%r%w                     " flags
set statusline+=[%{strlen(&ft)?&ft:'none'},  " filetype
set statusline+=%{strlen(&fenc)?&fenc:&enc}, " encoding
set statusline+=%{&fileformat}]              " file format
set statusline+=%=                           " right align
set statusline+=%{synIDattr(synID(line('.'),col('.'),1),'name')}\  " highlight
set statusline+=%b,0x%-8B\                   " current char
set statusline+=%-14.(%l,%c%V%)\ %<%P        " offset

let mapleader=","
map <leader>b :FufBuffer<CR>

" Set terminal colors to 256
let &t_Co=256

colorscheme inkpot
" Make active buffer status line more noticable color
hi StatusLine ctermfg=14

" Highlight column 80 for cpp files
hi ColorColumn ctermbg=236
autocmd BufNewFile,BufRead * call SetColorColumnValue()
fun! SetColorColumnValue()
  if (&filetype == 'cpp')
    set colorcolumn=80
  else
    set colorcolumn=5000
  endif
endfun

" hide created files in Explore
let g:netrw_list_hide= '.*\.swp$,.*\.swo$'

" from tpope/unimpaired-vim
" yo: similar to 'o' but opens insert mode with 'paste' and
"     resets to 'nopaste' when exiting insert mode
" yO: same but for 'O'
function! s:setup_paste() abort
  let s:paste = &paste
  let s:mouse = &mouse
  set paste
  set mouse=
  augroup unimpaired_paste
    autocmd!
    autocmd InsertLeave *
          \ if exists('s:paste') |
          \   let &paste = s:paste |
          \   let &mouse = s:mouse |
          \   unlet s:paste |
          \   unlet s:mouse |
          \ endif |
          \ autocmd! unimpaired_paste
  augroup END
endfunction

nnoremap <silent> yo  :call <SID>setup_paste()<CR>o
nnoremap <silent> yO  :call <SID>setup_paste()<CR>O

" Switch between cpp files and corresponding header
function! SwitchSourceHeader()
  let type = expand("%:e")
  if (type == "cc" || type == "cpp")
    find %:t:r.h
  else
    find %:t:r.cc
  endif
endfunction

fun! StripTrailingWhiteSpace()
  let l = line(".")
  let c = col(".")
  %s/\s\+$//e
  call cursor(l, c)
endfun

" Moves the current buffer to the opposite window
function! ShiftBuffer()
    let currWin = winnr()
    let otherWin = 2
    if currWin == 2
      let otherWin = 1
    endif

    let curBuf = bufnr( "%" )
    exe "normal \<C-^>"
    exe otherWin . " wincmd w"
    exe "hide buffer " . curBuf
endfunction

" :messages to debug startup
au FileType * setlocal comments-=:// comments+=f://

" %% will expand to the current directory relative to the base dir
" To create a file in the package of the current file:
" :e %%/SomeFile.java
cabbr <expr> %% expand('%:p:h')

" support GUI mode better
if has('mouse')
  set mouse=a
endif

" ctrl-k to go to next buffer
map <C-k> <C-w>w

map s z
map S s

" Jumping
map sh <C-o>
noremap sl <tab>

" search the file for the current word
map sd *

" display the number of occurences of the currently searched pattern
map sD :%s///gn<CR>

" copy to the os buffer so you can copy and paste things outside of vi
map sy "*y
map sp "*p

map sH g;
map sL g,

" restore mapleader
let mapleader=","
