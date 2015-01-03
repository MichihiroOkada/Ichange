" Version: 1.0
" Author:  Michihiro Okada <olux.888@gmail.com>
" License: VIM LICENSE

if exists('g:loaded_Ichange')
    finish
endif
let g:loaded_Ichange= 1

let s:save_cpo = &cpo
set cpo&vim

command! -nargs=0 Ichange call Ichange#change_indent(expand("%"))
command! -nargs=1 IchangeSetBefore call Ichange#set_before(<f-args>)
command! -nargs=1 IchangeSetAfter call Ichange#set_after(<f-args>)
command! -nargs=* IchangeSet call Ichange#set(<f-args>)

let &cpo = s:save_cpo
unlet s:save_cpo
