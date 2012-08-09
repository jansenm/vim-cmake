" FILE:         vim-ref-cmake.vim
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

" Cache already initialized?
let s:cache_initialized = 0
let s:cmake_help   = {}
let s:cmake_types  = [ 'module', 'command', 'property', 'variable' ]

function! s:get_list(type)

    if index(s:cmake_types, a:type) == -1
        throw 'Unknown cmake type'. a:type
    endif

    let output = system( 'cmake --help-'. a:type .'-list' )

    let help = {}
    for ident in split( output, '\n' )
        let help[ ident ] = {
            \ 'word': ident,
            \ 'menu': '[CMAKE]' }
    endfor
    let s:cmake_help[ a:type ] = help
endfunction

function! s:get_help(type, what)
    return cmake#output( '--help-'. a:type .' '. shellescape( a:what ) )
endfunction

function! cmake#find_help(identifier)
    call cmake#initialize()
    for type in s:cmake_types
        if has_key( s:cmake_help[ type ], a:identifier )
            return s:get_help( type, a:identifier )
        endif
    endfor
    return "Sorry no help for ".a:identifier
endfunction

function! cmake#initialize()
    if s:cache_initialized
        return
    endif
    for type in s:cmake_types
        call s:get_list( type )
    endfor
endfunction

function! cmake#modules()
    call cmake#initialize()
    return s:cmake_help['module']
endfunction


function! cmake#variables()
    call cmake#initialize()
    return s:cmake_help['variable']
endfunction

function! cmake#commands()
    call cmake#initialize()
    return s:cmake_help['command']
endfunction

function! cmake#output(args)
    return system( 'cmake '. a:args )
endfunction

function! cmake#properties(what)
    call cmake#initialize()
    return s:cmake_help['property']
endfunction

function! cmake#complete(str)
    call cmake#initialize()
    let rc = []
    for type in s:cmake_types
        call extend( rc, filter(keys(s:cmake_help[type]), 'v:val =~? "^\\V" . a:str'))
    endfor
    return sort( rc )
endfunction

function! cmake#all()
    call cmake#initialize()
    let rc = []
    for type in s:cmake_types
        call extend(rc,  keys( s:cmake_help[type] ) )
    endfor
    return sort( rc )
endfunction

function! cmake#all_with_type()
    call cmake#initialize()
    let rc = []
    for type in s:cmake_types
        call extend(rc, values( s:cmake_help[type] ) )
    endfor
    return rc
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
