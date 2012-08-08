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

