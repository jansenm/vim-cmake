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
" }}}
"
" See docs/vim-ref-cmake.txt for help or type :help RefCMake


"                                                                       }}}1
" ============================================================================
" BEGIN:                                                                {{{1

" Load once                                                             {{{2
if exists('loaded_vim_ref_cmake') || version < 700
    finish
endif
let loaded_vim_ref_cmake = 1

" Saving 'cpoptions'                                                    {{{2
let s:save_cpo = &cpo
set cpo&vim

"                                                                       }}}1
" ============================================================================
" CONFIGURATION:                                                        {{{1

" No configuration needed. The functionality is provided b
"       - vim-ref       (https://github.com/thinca/vim-ref)
"       - neocomplcache (https://github.com/Shougo/neocomplcache)
"       - unite.vim     (https://github.com/Shougo/unite.vim (via vim-ref))


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