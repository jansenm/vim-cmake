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
" HELPER FUNCTIONS:                                                     {{{1

"                                                                       }}}1
" ============================================================================
" VIM-REF SOURCE OBJECT:                                                {{{1

" The source definition. See `help ref-sources`                         {{{2
let s:ref_source = { 'name': 'cmake' }

function! s:ref_source.available()                                    " {{{2
    " This source is available if cmake is available
    return executable('cmake')
endfunction

function! s:ref_source.leave()                                        " {{{2
    " The source is left.
    unlet! b:vim_ref_cmake
endfunction

function! s:ref_source.get_keyword()                                  " {{{2
    " Return the current keyword.
    "   -> The complete line if we are in list mode (the default)
    "   -> The word under the cursor in entry mode
    if exists( "b:vim_ref_cmake"  ) && b:vim_ref_cmake == 'entry'
        let kwd = expand('<cword>')
        return kwd
    else
        echo getline('.')
        return getline('.')
    endif
endfunction

function! s:ref_source.complete(query)                                " {{{2
    " VIM-REF requests a completion for string a:query.
    return cmake#complete(a:query)
endfunction

function! s:ref_source.get_body(query)                                " {{{2
    " VIM-REF requests a new page for a:query.
    let b:vim_ref_cmake = 'list'
    "
    if a:query == "Module Reference"
        return sort( keys( cmake#module_names() ) )
    elseif a:query == "Custom Module Help"
        return cmake#cmake_output('--help-custom-modules')
    elseif a:query == "Compatibility Commands"
        return cmake#cmake_output('--help-compatcommands')
    elseif a:query == "Documentation"
        return cmake#cmake_output('--help-full')
    elseif a:query == "Policies"
        return cmake#cmake_output('--help-policies')
    elseif a:query == "Variable Reference"
        return sort( keys( cmake#variable_names() ) )
    elseif a:query == "Command Reference"
        return sort( keys( cmake#command_names() ) )
    elseif a:query == "Property Referencee"
        return sort( keys( cmake#property_names() ) )
    elseif a:query == "Full Reference"
        return cmake#all_names()
    elseif a:query != ""
        let b:vim_ref_cmake = 'entry'
        return cmake#find_help_for( a:query )
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
