nmap <leader>i :call FindImports(expand("<cword>"))<CR>
function! FindImports(name)
  call histadd("cmd", "FindImports " . a:name)
  call RunCmd("find_imports " . a:name)
  if !&modifiable
    map <buffer> <Enter> Yqggjpsh
  endif
endfunction
command! -nargs=1 FindImports :call FindImports("<args>")

" for java constructors: myField -> this.myField = myField;
map <leader>m ciwthis.<esc>pa = <esc>pa;<esc>
" wrap in checkNotNull
map <leader>n ciwcheckNotNull(<esc>pa, "<esc>pa")<esc>
