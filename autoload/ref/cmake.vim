" FILE:         autoload/ref/cmake.vim
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
" INIT:                                                                 {{{1

" Saving 'cpoptions'                                                    {{{2
let s:save_cpo = &cpo
set cpo&vim

"                                                                       }}}1
" ============================================================================
" LOCAL VARIABLES:                                                      {{{1

" The landing page                                                      {{{2
let s:cmake_landing_page = [
\ "MAIN DOCUMENTATION:",
\ "|Documentation|             The complete cmake documentation.",
\ "|ccmake-documentation|      The complete ccmake documentation.",
\ "",
\ "ADDITIONAL DOCUMENTATION:",
\ "|Custom-Modules|            Custom module documentation.",
\ "|Policies|                  Policy documentation.",
\ "|Compatibility-Commands|    Compatibility Commands.",
\ "",
\ "REFERENCES:",
\ "|Reference-Full|            List of all names.",
\ "|Reference-Commands|        List of all command names.",
\ "|Reference-Variables|       List of all variable names.",
\ "|Reference-Modules|         List of all module names.",
\ "|Reference-Properties|      List of all property names.",
\ ]

" Page: Main Index                                                      {{{3
let s:cmake_help_index = {
    \ 'Documentation': {
    \           'func': "s:cmake_index_full_documentation",
    \           'type': "man" },
    \ 'ccmake-documentation': {
    \           'func': "s:page_ccmake",
    \           'type': "man" },
    \ 'Custom-Modules': {
    \           'func': "s:cmake_index_custom_modules",
    \           'type': "man" },
    \ 'Policies': {
    \           'func': "s:cmake_index_policies",
    \           'type': "man" },
    \ 'Reference-Commands': {
    \           'func': "s:cmake_index_commands",
    \           'type': "index" },
    \ 'Reference-Modules': {
    \           'func': "s:cmake_index_modules",
    \           'type': "index" },
    \ 'Reference-Properties': {
    \           'func': "s:cmake_index_properties",
    \           'type': "index" },
    \ 'Reference-Variables': {
    \           'func': "s:cmake_index_variables",
    \           'type': "index" },
    \ 'Reference-Full': {
    \           'func': "s:cmake_index_all",
    \           'type': "index" },
    \ 'Compatibility-Commands': {
    \           'func': "s:cmake_index_compatibility",
    \           'type': "man" }
    \ }

"                                                                       }}}1
" ============================================================================
" HELPER FUNCTIONS:                                                     {{{1

" Page: ccmake Documentation                                            {{{2
function! s:page_ccmake(query)
    if index( ref#available_source_names(), 'man' ) > -1
        return ref#available_sources('man').get_body('ccmake')
    else
        return cmake#ccmake_output('--help-full')
    end
endfunction

" Page: Compatibility Commands                                          {{{2
function! s:cmake_index_compatibility(query)
    if index( ref#available_source_names(), 'man' ) > -1
        return ref#available_sources('man').get_body('cmakecompat')
    else
        return cmake#cmake_output('--help-compatcommands')
    end
endfunction

" Page: Custom Modules.                                                 {{{2
function! s:cmake_index_custom_modules(query)
    return cmake#cmake_output('--help-custom-modules')
endfunction

" Page: Full Documentation                                              {{{2
function! s:cmake_index_full_documentation(query)
    if index( ref#available_source_names(), 'man' ) > -1
        return ref#available_sources('man').get_body('cmake')
    else
        return cmake#cmake_output('--help-full')
    end
endfunction

" Page: Policies                                                        {{{2
function! s:cmake_index_policies(query)
    if index( ref#available_source_names(), 'man' ) > -1
        return ref#available_sources('man').get_body('cmakepolicies')
    else
        return cmake#cmake_output('--help-policies')
    end
endfunction

" List: All Names                                                       {{{2
function! s:cmake_index_all(query)
    return cmake#all_names()
endfunction

" List: Command Names                                                   {{{2
function! s:cmake_index_commands(query)
    return sort( keys( cmake#command_names() ) )
endfunction

" List: Module Names                                                    {{{2
function! s:cmake_index_modules(query)
    return sort( keys( cmake#module_names() ) )
endfunction

" List: Property Names                                                  {{{2
function! s:cmake_index_properties(query)
    return sort( keys( cmake#property_names() ) )
endfunction

" List: Variable Names                                                  {{{2
function! s:cmake_index_variables(query)
    return sort( keys( cmake#variable_names() ) )
endfunction

"                                                                       }}}1
" ============================================================================
" VIM-REF SOURCE OBJECT:                                                {{{1

" The source definition. See `help ref-sources`                         {{{2
let s:ref_source = { 'name': 'cmake' }

function! s:ref_source.available()                                    " {{{2
    " This source is available if cmake is available
    return cmake#available()
endfunction

function! s:ref_source.opened(query)                                  " {{{2
    " The source is left.

    " Set the correct buffer type
    if a:query == ""
        let b:vim_cmake_page_type = 'main_index'
    elseif has_key( s:cmake_help_index, a:query )
        let b:vim_cmake_page_type = s:cmake_help_index[ a:query ].type
    else
        if match( getline(1), 'Error:' ) > -1
            echo getline(1)
            echo match( getline(1), 'n', 'Error:' )
            let b:vim_cmake_page_type = 'main_index'
        else
            let b:vim_cmake_page_type = 'text'
        endif
    endif

    " Make sure the correct syntax file is used.
    if b:vim_cmake_page_type == 'man'
        if index( ref#available_source_names(), 'man' ) > -1
            return ref#available_sources('man').opened('cmake')
        end
    else
        if exists('b:current_syntax') && b:current_syntax !=# 'ref-cmake'
            syntax clear
            runtime! syntax/ref-cmake.vim
        endif
    end
endfunction

function! s:ref_source.leave()                                        " {{{2
    " The source is left.
    unlet b:vim_cmake_page_type
endfunction

function! s:ref_source.get_keyword()                                  " {{{2
    " Return the current keyword.

    if b:vim_cmake_page_type == 'main_index'
        let matches = matchlist( getline('.'), '^ *|\(.*\)|.*', 'n' )
        if ! empty(matches)
            return matches[1]
        endif
        return
    end

    if b:vim_cmake_page_type == 'index'
        return getline('.')
    end

    return expand('<cWORD>')
endfunction

function! s:ref_source.complete(query)                                " {{{2
    " VIM-REF requests a completion for string a:query.
    return cmake#complete(a:query)
endfunction

function! s:ref_source.get_body(query)                                " {{{2
    " VIM-REF requests a new page for a:query.

    " Check if the landing page is required
    if a:query == ""
        return s:cmake_landing_page
    end

    " Check what is currently shown
    if has_key( s:cmake_help_index, a:query )
        return function( s:cmake_help_index[ a:query ].func )(a:query)
    endif

    let rc = cmake#find_help_for( a:query )

    if empty(rc)
        return extend(
            \ [ "Error: No help for ". a:query, ""],
            \ s:cmake_landing_page )
    endif

    return rc

endfunction


"                                                                       }}}1
" ============================================================================
" HOOK INTO VIM-REF:                                                    {{{1

" Tell VIM-REF a source from filetype cmake is in town.                 {{{2
call ref#register_detection('cmake', 'cmake')

function! ref#cmake#define()                                          " {{{2
    " VIM-REF requests our source object.
    return s:ref_source
endfunction


"                                                                       }}}1
" ============================================================================
" CLEANUP:                                                              {{{1

" Restore 'cpoptions'                                                   {{{2
let &cpo = s:save_cpo
unlet s:save_cpo


"                                                                       }}}1
" ============================================================================
" MODELINES:                                                            {{{2
" vim: foldmethod=marker
