" Name Of File: UnMtchBracket.vim
"  Description: Vim Plugin to capture those unmatched brackets while
"               you are still in insert mode.
"   Maintainer: Naveen Chandra R (ncr at iitbombay dot org)
"  Last Change: Tuesday, July 23, 2002
"      Install 
"      Details: Normally, this file should reside in the plugins
"               directory and be automatically sourced. If not, you must
"               manually source this file using ':so UnMtchBracket.vim'.
"  Description: This script highlights any unmatched '(' or '{' and
"               warns the user if an extra ')' or '}' is typed.
"          Bug: Any editing(ie: deleting or inserting) before any 
"               highlighted unmatched bracket would lead to highlighting
"               at wrong place.
"               	To get rid of this unwanted highlighting, a useful
"               mapping would be
"                   noremap! <Esc> <Esc>:match NONE<CR>
"               Put the above mapping in your .vimrc                
" ----------------------------------------------------------------------

" Start of Script
" ---------------
" Exit if this plugin is already loaded.
if exists("loaded_hiunbrkt") || &cp
	finish
endif
let loaded_hiunbrkt=1

" Mappings
" --------
inoremap ( (<Esc>:silent call HiCursor()<CR>a
inoremap ) )<Esc>:call MatchedBracket("(")<CR>a
inoremap { {<Esc>:silent call HiCursor()<CR>a
inoremap } }<Esc>:call MatchedBracket("{")<CR>a

"noremap! <Esc> <Esc>:match NONE<CR>


" Functions
" ---------
function! HiCursor()
    exe 'match Error /\%'.line('.').'l\%'.col('.').'c/'
endfunction

function! MatchedBracket(bkt)
    let s:editline = line('.')
    let s:editcol = virtcol('.')
    norm! %
    let s:curline = line('.')
    let s:curcol = virtcol('.')
	if(s:editline == s:curline && s:editcol == s:curcol)
		echohl ErrorMsg
		echon "UnMatched ".a:bkt
		echohl None
		return
	endif
    exe 'match Normal /\%'.s:curline.'l\%'.s:curcol.'c/'
	if s:GotoUnMtchBrkt(a:bkt)
		call HiCursor()
	else
		exe "normal! ".s:editline."G".s:editcol."|"
		if a:bkt == "("
			if s:GotoUnMtchBrkt("{")
				call HiCursor()
			endif
		else
			if s:GotoUnMtchBrkt("(")
				call HiCursor()
			endif
		endif
	endif
	exe "normal! ".s:editline."G".s:editcol."|"
endfunction

function! s:GotoUnMtchBrkt(bkt)
	let s:curline = line('.')
	let s:curcol = virtcol('.')
	exe "normal! [".a:bkt
	let s:prevline = line('.')
	let s:prevcol = virtcol('.')
    if(s:curcol != s:prevcol || s:curline != s:prevline) 
		norm! %
		if(s:prevcol == virtcol('.') && s:prevline == line('.'))
			return 1
		else
			norm! %
			return s:GotoUnMtchBrkt(a:bkt)
		endif
	endif
	return 0
endfunction

" End of Script
