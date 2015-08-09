" Version: 1.1
" Author:  Michihiro Okada <olux.888@gmail.com>
" License: VIM LICENSE

let s:save_cpo = &cpo
set cpo&vim

if !exists('g:Ichange#enable')
    let g:Ichange#enable = 1
endif

if !exists('g:Ichange#before_indent')
    let g:Ichange#before_indent = 0
endif

if !exists('g:Ichange#after_indent')
    let g:Ichange#after_indent = 0
endif

function! s:replace(file, start, end)
    let s:lineno = a:start
    let s:line = getline(s:lineno) 

    "while strlen(s:line) > 0
    while 1
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

        let s:indent_count = (s:spacecount / g:Ichange#before_indent) + 
                           \ (s:spacecount % g:Ichange#before_indent)
        "echo s:indent_count

        " create after string
        let s:after_string = ""
        let s:i = 0
        while s:i < ( s:indent_count * g:Ichange#after_indent )
            let s:after_string = s:after_string . " "
            let s:i += 1
        endwhile

        let s:newline = substitute(getline(s:lineno), "^" . s:before_string , s:after_string, "e")
        "echo s:newline
        call setline(s:lineno, s:newline)

        let s:lineno += 1
        let s:line = getline(s:lineno) 

        if a:end > 0
            if s:lineno > a:end
                break
            endif
        endif
    endwhile
endfunction

"function! Ichange#change_indent(file) range
"    if ((g:Ichange#before_indent == 0) || (g:Ichange#after_indent == 0))
"        echo "Please set BEFORE indent and AFTER indent."
"    else
"        if g:Ichange#enable
"            call s:replace(a:file, 1, 0)
"        endif
"    endif
"endfunction

function! Ichange#change_indent(file, start, end) range
    if ((g:Ichange#before_indent == 0) || (g:Ichange#after_indent == 0))
        echo "Please set BEFORE indent and AFTER indent."
    else
        if g:Ichange#enable
            call s:replace(a:file, a:start, a:end)
        endif
    endif
endfunction

function! Ichange#set(before,after)
    let g:Ichange#before_indent = a:before
    let g:Ichange#after_indent = a:after
endfunction

function! Ichange#set_before(before)
    let g:Ichange#before_indent = a:before
endfunction

function! Ichange#set_after(after)
    let g:Ichange#after_indent = a:after
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

