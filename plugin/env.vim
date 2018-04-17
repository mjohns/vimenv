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

set background=light
colorscheme solarized

highlight ExtraWhitespace ctermbg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

" Make vim take up whole terminal
set t_ut=

"colorscheme inkpot
"hi StatusLine ctermfg=14

" Highlight column 80 for cpp files
hi ColorColumn ctermbg=7
autocmd BufNewFile,BufRead * call SetColorColumnValue()
fun! SetColorColumnValue()
  if (&filetype == 'cpp')
    set colorcolumn=80
  elif (&filetype == 'java')
    set colorcolumn=100
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

" Expands a window to be full screen if not expanded. Otherwise
" returns windows to previous sizes.
function! ExpandWindow()
  let large_size=1998123
  let all_windows=range(1,winnr('$'))
  let curr_win=winnr()

  if exists("w:WindowIsExpanded") && w:WindowIsExpanded
    for i in all_windows
      exe i . " wincmd w"
      exe "vertical resize " . w:WidthToRestore
      let w:WindowIsExpanded=0
    endfor
    exe curr_win . " wincmd w"
  else
    for i in all_windows
      exe i . " wincmd w"
      let w:WidthToRestore=winwidth(0)
      let w:WindowIsExpanded=0
    endfor
    exe curr_win . " wincmd w"
    exe "vertical resize " . 4000
    let w:WindowIsExpanded=1
  endif
endfunction
noremap <C-h> :call ExpandWindow()<CR>

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
map <A-k> <C-w>w

map s z
map S s

" Jumping
map sh <C-o>
noremap sl <tab>


" display the number of occurences of the currently searched pattern
map sD :%s///gn<CR>

" copy to the os buffer so you can copy and paste things outside of vi
map sy "*y
map sp "*p

map sH g;
map sL g,

" switch back to the previously loaded file
map zb <C-^>

" restore mapleader
let mapleader=","

augroup Binary
  au!
  au BufReadPre  *.glb,*.bin,*.BIN,*.exe,*.o,*.obj,*.OBJ,*.rom,*.ROM let &bin=1
  au BufReadPost *.glb,*.bin,*.BIN,*.exe,*.o,*.obj,*.OBJ,*.rom,*.ROM if &bin | %!xxd -g1
  au BufReadPost *.glb,*.bin,*.BIN,*.exe,*.o,*.obj,*.OBJ,*.rom,*.ROM set ft=xxd | endif
  au BufWritePre *.glb,*.bin,*.BIN,*.exe,*.o,*.obj,*.OBJ,*.rom,*.ROM if &bin | %!xxd -r
  au BufWritePre *.glb,*.bin,*.BIN,*.exe,*.o,*.obj,*.OBJ,*.rom,*.ROM endif
  au BufWritePost *.glb,*.bin,*.BIN,*.exe,*.o,*.obj,*.OBJ,*.rom,*.ROM if &bin | %!xxd -g1
  au BufWritePost *.glb,*.bin,*.BIN,*.exe,*.o,*.obj,*.OBJ,*.rom,*.ROM set nomod | endif
augroup END

function! RunCmdSimple(name)
  edit temporary_buffer
  setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap
  setlocal modifiable
  map <buffer> <Enter> gF
  map <buffer> q <C-^>
  map <buffer> :q q
  exe "silent r!" . a:name
  etlocal nomodifiable
endfunction
