if exists('did_vim_ref_cmake') || version < 700
    finish
endif
let did_vim_ref_cmake = 1


if !exists('g:vim_ref_cmake_map_keys')
    let g:vim_ref_cmake_map_keys = 1
endif

if g:vim_ref_cmake_map_keys
    autocmd FileType cmake nnoremap <silent> <buffer> K :call ref#ref( "cmake ". expand("<cword>"))<CR>
endif


