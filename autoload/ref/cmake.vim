" Save nocompatible
let s:save_cpo = &cpo
set cpo&vim

scriptencoding utf-8


let s:ref_source = { 'name': 'cmake' }

" This reference is available if the cmake executable is available
function! s:ref_source.available()
    return executable('cmake')
endfunction

function! s:ref_source.opened(query)
    let b:vim_ref_cmake = 'list'
endfunction

function! s:ref_source.leave()
    unlet b:vim_ref_cmake
endfunction

function! s:ref_source.get_keyword()
    if b:vim_ref_cmake == 'list'
        return getline('.')
    else
        let isk = &l:iskeyword
        setlocal isk& isk+=:
        let kwd = expand('<cword>')
        let &l:iskeyword = isk
        return kwd
    endif
endfunction

" Get the body for the given query
function! s:ref_source.get_body(query)
    if a:query == "Module Reference"
        return keys( cmake#modules() )
    elseif a:query == "Custom Module Help"
        return cmake#output('--help-custom-modules')
    elseif a:query == "Compatibility Commands"
        return cmake#output('--help-compatcommands')
    elseif a:query == "Documentation"
        return cmake#output('--help-full')
    elseif a:query == "Policies"
        return cmake#output('--help-policies')
    elseif a:query == "Variable Reference"
        return keys( cmake#variables() )
    elseif a:query == "Command Reference"
        return keys( cmake#commands() )
    elseif a:query == "Property Referencee"
        return keys( cmake#properties() )
    elseif a:query == "Reference"
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
