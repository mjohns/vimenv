map <leader>i :JavaImport<CR>

" for java constructors: myField -> this.myField = myField;
map <leader>m ciwthis.<esc>pa = <esc>pa;<esc>
" wrap in checkNotNull
map <leader>n ciwcheckNotNull(<esc>pa, "<esc>pa")<esc>
