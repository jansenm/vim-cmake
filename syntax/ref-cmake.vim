" Vim syntax file
" Language:	Ref CMake file
" Maintainer:	Michael Jansen <kde@michael-jansen.biz>
" Last Change:	2012 Aug 16

"                                                                       }}}1
" ============================================================================
" BEGIN:                                                                {{{1

" Quit when a (custom) syntax file was already loaded                   {{{2
if exists("b:current_syntax")
  finish
endif

" Saving 'cpoptions'                                                    {{{2
let s:save_cpo = &cpo
set cpo&vim

" ============================================================================
" SYNTAX DEFINTION
if has("conceal")
  syn match helpBar		contained "[|`]" conceal
  syn match helpStar		contained "\*" conceal
else
  syn match helpBar		contained "[|`]"
  syn match helpStar		contained "\*"
endif

if has("ebcdic")
  syn match helpHyperTextJump	"\\\@<!|[^"*|]\+|" contains=helpBar
  syn match helpHyperTextEntry	"\*[^"*|]\+\*\s"he=e-1 contains=helpStar
  syn match helpHyperTextEntry	"\*[^"*|]\+\*$" contains=helpStar
else
  syn match helpHyperTextJump	"\\\@<!|[#-)!+-~]\+|" contains=helpBar
  syn match helpHyperTextEntry	"\*[#-)!+-~]\+\*\s"he=e-1 contains=helpStar
  syn match helpHyperTextEntry	"\*[#-)!+-~]\+\*$" contains=helpStar
endif

syn match helpHeadline		"^[-A-Z .][-A-Z0-9 .]*:$"me=e-1
syn match helpSectionDelim	"^===.*===$"
syn match helpSectionDelim	"^---.*--$"


" ============================================================================
" DEFAULT HIGHLIGHTING
hi def link helpBar		Ignore
hi def link helpHyperTextJump	Subtitle
hi def link helpHeadline	Statement
hi def link helpSectionDelim	PreProc


" ============================================================================
" DEFAULT HIGHLIGHTING
let b:current_syntax = "vim-ref"


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
