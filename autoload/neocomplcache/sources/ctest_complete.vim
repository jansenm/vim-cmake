" FILE:         autoload/neocomplcache/sources/ctest_complete.vim
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
" NEOCOMPLCACHE-SOURCE OBJECT:                                          {{{1

" The source definition. See `help neocomplcache-sources`               {{{2
let s:source = {
    \ 'name': 'ctest_complete',
    \ 'kind': 'ftplugin',
    \ 'filetypes': { 'cmake' : 1 }
    \ }

function! s:source.initialize()                                       " {{{2
    " NEOCOMPLCACHE asks us to prepare for work
    call neocomplcache#set_completion_length(
        \ 'ctest_complete',
        \ g:neocomplcache_auto_completion_start_length)

  " Set rank.
    call neocomplcache#set_dictionary_helper(
        \ g:neocomplcache_source_rank,
        \ 'ctest_complete', 3)

endfunction

function! s:source.get_complete_words(cur_keyword_pos, cur_keyword_str) " {{{2
    " NEOCOMPLCACHE requests a word completion.

    " Complete a word. No idea what it does but it works. :))
    let keyword_list = neocomplcache#keyword_filter(
        \ ctest#all_names_with_type(),
        \ a:cur_keyword_str)
    return neocomplcache#keyword_filter(
        \ keyword_list,
        \ a:cur_keyword_str)

endfunction

function! s:source.get_keyword_pos(cur_text)                          " {{{2
    " No idea why it is needed. But without it it does not work.
    let [cur_keyword_pos, cur_keyword_str] = neocomplcache#match_word(a:cur_text)
    return cur_keyword_pos
endfunction"

"                                                                       }}}1
" ============================================================================
" HOOK INTO NEOCOMPLCACHE:                                              {{{1

function! neocomplcache#sources#ctest_complete#define()
    " NEOCOMPLCACHE requests out source objects.
    return s:source
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
