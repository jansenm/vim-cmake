" FILE:         vim-ref-cmake.vim
" AUTHOR:       Michael Jansen <kde@michael-jansen.biz>
" WEBSITE:      http://michael-jansen.biz
" LICENSE:      MIT license                                             {{{2
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

"                                                                       }}}1
" ============================================================================
" BEGIN:                                                                {{{1

" Saving 'cpoptions'                                                    {{{2
let s:save_cpo = &cpo
set cpo&vim

"                                                                       }}}1
" ============================================================================
" LOCAL VARIABLES:                                                      {{{1

let s:cache_initialized = 0                                           " {{{2
" Is the cache already initialized?

let s:cmake_help   = {}                                               " {{{2
" { <type> => { <KEYWORD> => <TYPE> } }

let s:cmake_types  = [ 'module', 'command', 'property', 'variable' ]  " {{{2
" All availables cmake types we can have a list for (see cmake --help)

"                                                                       }}}1
" ============================================================================
" LOCAL FUNCTIONS:                                                      {{{1

function! s:get_names(type)                                           " {{{2
    " Return the list of keyword for a:type. a:type has to be one of
    " s:cmake_type or this function will throw an exception.

    " Verify type
    if index(s:cmake_types, a:type) == -1
        throw 'Unknown cmake type'. a:type
    endif

    " Check if we have the keyword list cached.
    if ! has_key( s:cmake_help, a:type )
        " Ask cmake for the list.
        let output = system( 'cmake --help-'. a:type .'-list' )

        " Fill the cache
        let help = {}
        for ident in split( output, '\n' )
            " TODO: Check if different types are possible or if other
            " informations could be set.
            let help[ ident ] = {
                \ 'word': ident,
                \ 'menu': '[CMAKE]' }
        endfor

        let s:cmake_help[ a:type ] = help
    endif

    " Return the list.
    return s:cmake_help[ a:type ]
endfunction

function! s:get_help_text(type, what)                                 " {{{2
    " Call cmake with the option --help-<a:what> and return the output. a:what
    " is shellescape()d.
    return cmake#cmake_output( '--help-'. a:type .' '. shellescape( a:what ) )
endfunction

"                                                                       }}}1
" ============================================================================
" FUNCTIONS:                                                            {{{1

function! cmake#module_names()                                        " {{{2
    " Get a list of all module names.
    return s:get_names('module')
endfunction

function! cmake#variable_names()                                      " {{{2
    " Get a list of all variable names.
    return s:get_names('variable')
endfunction

function! cmake#command_names()                                       " {{{2
    " Get a list of all commands names.
    return s:get_names('command')
endfunction

function! cmake#property_names()                                      " {{{2
    " Get a list of all property names.
    return s:get_names('property')
endfunction

function! cmake#cmake_output(args)                                    " {{{2
    " Call cmake with a:args and return the output.
    return system( 'cmake '. a:args )
endfunction

function! cmake#complete(str)                                         " {{{2
    " Return potential completions for a:str.
    let rc = []
    for type in s:cmake_types
        call extend(
            rc,
            filter(
                keys(s:get_names(type)),
                'v:val =~? "^\\V" . a:str'))
    endfor
    return sort( rc )
endfunction

function! cmake#find_help_for(identifier)                             " {{{2
    " Search for the help for a:identifier
    for type in s:cmake_types
        if has_key( s:get_names( type ), a:identifier )
            return s:get_help_text( type, a:identifier )
        endif
    endfor
    return "Sorry no help for ".a:identifier
endfunction

function! cmake#all_names()                                           " {{{2
    " Get a list of all names
    let rc = []
    for type in s:cmake_types
        call extend(rc,  keys( s:get_names(type) ) )
    endfor
    return sort( rc )
endfunction

function! cmake#all_names_with_type()                                 " {{{2
    let rc = []
    for type in s:cmake_types
        call extend(rc, values( s:get_names(type) ) )
    endfor
    return rc
endfunction

"                                                                       }}}1
" ============================================================================
" END:                                                                  {{{1

" Restore 'cpoptions'                                                   {{{2
let &cpo = s:save_cpo
unlet s:save_cpo


"                                                                       }}}1
" ============================================================================
" MODELINES:                                                            {{{2
" vim: foldmethod=marker
