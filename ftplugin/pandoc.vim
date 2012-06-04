"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ftplugin/pandoc.vim
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" # Do not add two spaces at end of punctuation when joining lines
"
setlocal nojoinspaces

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" # Use pandoc to tidy up text
"
" If you use this on your entire file, it will wipe out title blocks.
" To preserve title blocks, use :MarkdownTidy instead. (If you use
" :MarkdownTidy on a portion of your file, it will insert unwanted title
" blocks...)
"
setlocal equalprg=pandoc\ -t\ markdown\ --reference-links

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" HTML style comments
"
setlocal commentstring=<!--%s-->
setlocal comments=s:<!--,m:\ \ \ \ ,e:-->

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" # Folding sections with ATX style headers.
"
if !exists("g:pandoc_no_folding") || !g:pandoc_no_folding
	setlocal foldexpr=pandoc#MarkdownLevel()
	setlocal foldmethod=expr
endif


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" # Autocomplete citationkeys using function
"
call pandoc#Pandoc_Find_Bibfile()

let s:completion_type = ""
setlocal omnifunc=pandoc#Pandoc_Complete

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" # Supertab support
"
if exists("g:SuperTabDefaultCompletionType")
	call SuperTabSetDefaultCompletionType("context")

	if exists('g:SuperTabCompletionContexts')
		let b:SuperTabCompletionContexts =
		\ ['pandoc#PandocContext'] + g:SuperTabCompletionContexts
	endif
"
" disable supertab completions after bullets and numbered list
" items (since one commonly types something like `+<tab>` to
" create a list.)
"
let b:SuperTabNoCompleteAfter = ['\s', '^\s*\(-\|\*\|+\|>\|:\)', '^\s*(\=\d\+\(\.\=\|)\=\)']
endif
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" # Commands that call Pandoc
"
" ## Tidying Commands
"
" Markdown tidy with hard wraps
" (Note: this will insert an empty title block if no title block 
" is present; it will wipe out any latex macro definitions)

command! -buffer MarkdownTidyWrap %!pandoc -t markdown -s

" Markdown tidy without hard wraps
" (Note: this will insert an empty title block if no title block 
" is present; it will wipe out any latex macro definitions)

command! -buffer MarkdownTidy %!pandoc -t markdown --no-wrap -s
