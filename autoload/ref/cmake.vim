" FILE:         autoload/ref/cmake.vim
" AUTHOR:       Michael Jansen <kde@michael-jansen.biz>
" WEBSITE:      http://michael-jansen.biz
" LICENSE:      MIT license  {{{
"     Copyright (C) 2012 Michael Jansen
"
"     Permission is hereby granted, free of charge, to any person obtaining
"     a copy of this software and associated documentation files (the
"     "Software"), to deal in the Software without restriction, including
"     without limitation the rights to use, copy, modify, merge, publish,
"     distribute, sublicense, and/or sell copies of the Software, and to
"     permit persons to whom the Software is furnished to do so, subject to
"     the following conditions:
"
"     The above copyright notice and this permission notice shall be included
"     in all copies or substantial portions of the Software.
"
"     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
"     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
"     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
"     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
"     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
"     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
"     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
" }}}

" Save nocompatible
let s:save_cpo = &cpo
set cpo&vim

let s:ref_source = { 'name': 'cmake' }

" This reference is available if the cmake executable is available
function! s:ref_source.available()
    return executable('cmake')
endfunction

function! s:ref_source.leave()
    unlet! b:vim_ref_cmake
endfunction

function! s:ref_source.get_keyword()
    if exists( "b:vim_ref_cmake"  ) && b:vim_ref_cmake == 'entry'
        let kwd = expand('<cword>')
        return kwd
    else
        echo getline('.')
        return getline('.')
    endif
endfunction

function! s:ref_source.complete(query)
    return cmake#complete(a:query)
endfunction

" Get the body for the given query
function! s:ref_source.get_body(query)
    let b:vim_ref_cmake = 'list'
    if a:query == "Module Reference"
        return sort( keys( cmake#modules() ) )
    elseif a:query == "Custom Module Help"
        return cmake#output('--help-custom-modules')
    elseif a:query == "Compatibility Commands"
        return cmake#output('--help-compatcommands')
    elseif a:query == "Documentation"
        return cmake#output('--help-full')
    elseif a:query == "Policies"
        return cmake#output('--help-policies')
    elseif a:query == "Variable Reference"
        return sort( keys( cmake#variables() ) )
    elseif a:query == "Command Reference"
        return sort( keys( cmake#commands() ) )
    elseif a:query == "Property Referencee"
        return sort( keys( cmake#properties() ) )
    elseif a:query == "Full Reference"
        return cmake#all()
    elseif a:query != ""
        let b:vim_ref_cmake = 'entry'
        return cmake#find_help( a:query )
    endif
    return [
        \ "Documentation",
        \ "Custom Module Help",
        \ "Policies",
        \ "Full Reference",
        \ "Module Reference",
        \ "Command Reference",
        \ "Variable Reference",
        \ "Property Reference",
        \ "Compatibility Commands" ]
endfunction

function! ref#cmake#define()
    return s:ref_source
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
