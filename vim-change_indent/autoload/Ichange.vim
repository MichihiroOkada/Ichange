" Version: 1.0
" Author:  Michihiro Okada <olux.888@gmail.com>
" License: VIM LICENSE

let s:save_cpo = &cpo
set cpo&vim

let s:before_indent = 0
let s:after_indent  = 0

if !exists('g:Ichange#enable')
    let g:Ichange#enable = 1
endif

function! s:replace(file)
    let s:lineno = 1
    for s:line in readfile(a:file)
        let s:i = 0
        let s:len = strlen(s:line)
        let s:spacecount = 0
        let s:before_string = ""

        " create before string and count indent space
        while s:i < s:len 
            if s:line[s:i] == ' '
                let s:spacecount += 1
                let s:before_string = s:before_string . " "
            else
                break
            endif
            let s:i += 1 
        endwhile

        let s:indent_count = (s:spacecount / s:before_indent) + 
                           \ (s:spacecount % s:before_indent)
        "echo s:indent_count

        " create after string
        let s:after_string = ""
        let s:i = 0
        while s:i < ( s:indent_count * s:after_indent )
            let s:after_string = s:after_string . " "
            let s:i += 1
        endwhile

        let s:newline = substitute(getline(s:lineno), s:before_string , s:after_string, "e")
        "echo s:newline
        call setline(s:lineno, s:newline)

        let s:lineno += 1
    endfor
endfunction

function! Ichange#change_indent(file)
    if ((s:before_indent == 0) || (s:after_indent == 0))
        echo "Please set BEFORE indent and AFTER indent."
    else
        if g:Ichange#enable
            call s:replace(a:file)
        endif
    endif
endfunction

function! Ichange#set(before,after)
    let s:before_indent = a:before
    let s:after_indent = a:after
endfunction

function! Ichange#set_before(before)
    let s:before_indent = a:before
endfunction

function! Ichange#set_after(after)
    let s:after_indent = a:after
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

