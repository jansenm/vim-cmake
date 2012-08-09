" FILE:         autoload/neocomplcache/sources/cmake_complete.vim
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


let s:save_cpo = &cpo
set cpo&vim

" The source definition. See `help neocomplcache-sources`
let s:source = {
    \ 'name': 'cmake_complete',
    \ 'kind': 'ftplugin',
    \ 'filetypes': { 'cmake' : 1 }
    \ }

" Initialize the source
function! s:source.initialize()
  " Initialize.
    call neocomplcache#set_completion_length(
        \ 'cmake_complete',
        \ g:neocomplcache_auto_completion_start_length)

  " Set rank.
    call neocomplcache#set_dictionary_helper(
        \ g:neocomplcache_source_rank,
        \ 'cmake_complete', 3)

endfunction

" Complete a word. No idea what it does but it works. :))
function! s:source.get_complete_words(cur_keyword_pos, cur_keyword_str)
    let keyword_list = neocomplcache#keyword_filter(
        \ cmake#all_with_type(),
        \ a:cur_keyword_str)
    return neocomplcache#keyword_filter(
        \ keyword_list,
        \ a:cur_keyword_str)
endfunction

" No idea why it is needed. But without it it does not work.
function! s:source.get_keyword_pos(cur_text)
    let [cur_keyword_pos, cur_keyword_str] = neocomplcache#match_word(a:cur_text)
    return cur_keyword_pos
endfunction"

" Register the source
function! neocomplcache#sources#cmake_complete#define()
    return s:source
endfunction

" Reset
let &cpo = s:save_cpo
unlet s:save_cpo

