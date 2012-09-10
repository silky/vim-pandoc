" Vim syntax for pandocs extended markdown format: http://johnmacfarlane.net/pandoc/README.html#pandocs-markdown
"
" Language:	        Pandoc Extended Markdown (superset of Markdown)
" Author:           Noon Silk <noonsilk@gmail.com>
" Maintainer:       David Sanson <dsanson@gmail.com>
" Maintainer:       Felipe Morales <hel.sheep@gmail.com>
" OriginalAuthor:   Jeremy Schultz <taozhyn@gmail.com>
" Version:          5.0 (by Noon Silk)
" Remarks:          I've removed a lot of uneccessary bits from this, and cleaned up some minor
"                   bugs.

if version < 600
	syntax clear
elseif exists("b:current_syntax")
	finish
endif

syntax case match
syntax spell toplevel
syn sync linebreaks=1


" Embedded Syntax Handlers:
" -------------------------
"
" HTML style for any tag section.

syn include @HTML syntax/html.vim
syn match pandocHTML /<[/a-zA-Z][^>]\+>/ contains=@HTML


" TeX for the macros and inline math.
"
" Unset current_syntax so the 2nd include will work
unlet b:current_syntax
syn include @LATEX syntax/tex.vim
" Single TeX command
syn match pandocLatex /\\\w\S/ contains=@LATEX
" Inline Math
syn match pandocLatex /\$.\{-}\$/ contains=@LATEX
syn match pandocTitleBlock /\%^\(%.*\n\)\{1,3}$/ skipnl


let b:current_syntax = "pandoc"


" Headers:
" --------

syn match pandocAtxHeader /^\s*#\{1,6}.*\n/ contains=pandocEmphasis
syn match pandocSetexHeader /^.\+\n[=]\+$/
syn match pandocSetexHeader /^.\+\n[-]\+$/


" Blockquotes:
" ------------

syn match pandocBlockQuote /^>.*\n\(.*\n\@<!\n\)*/ skipnl


" Comments:
" --------

syn region pandocCommentSection start=/<!--/ end=/-->/


" Code Blocks:
" ------------

syn region pandocCodeBlock  start=/\(\(\d\|\a\|*\).*\n\)\@<!\(^\(\s\{4,}\|\t\+\)\).*\n/ end=/.\(\n^\s*\n\)\@=/


" Delimited Code Blocks:
" ----------------------

syn region pandocDelimitedCodeBlock start=/^\z(\~\{3,}\~*\)\( {.\+}\)*/ end=/\z1\~*/ skipnl contains=pandocDelimitedCodeBlockLanguage
syn match pandocDelimitedCodeBlockLanguage /{.\+}/ contained containedin=pandocDelimitedCodeBlock
syn match pandocCodePre /<pre>.\{-}<\/pre>/ skipnl
syn match pandocCodePre /<code>.\{-}<\/code>/ skipnl


" Links:
" ------

syn region pandocLinkArea start=/\[.\{-}\]\@<=\(:\|(\|\[\)/ skip=/\(\]\(\[\|(\)\|\]: \)/ end=/\(\(\]\|)\)\|\(^\s*\n\|\%^\)\)/ contains=pandocLinkText,pandocLinkURL,pandocLinkTitle,pandocAutomaticLink,pandocPCite
syn match pandocLinkText /\[\@<=.\{-}\]\@=/ containedin=pandocLinkArea contained contains=@Spell
syn match pandocLinkURL /https\{0,1}:.\{-}\()\|\s\|\n\)\@=/ containedin=pandocLinkArea contained
syn match pandocAutomaticLink /<\(https\{0,1}.\{-}\|.\{-}@.\{-}\..\{-}\)>/
syn match pandocLinkTextRef /\(\]\(\[\|(\)\)\@<=.\{-}\(\]\|)\)\@=/ containedin=pandocLinkText contained
syn match pandocLinkTitle /".\{-}"/ contained containedin=pandocLinkArea contains=@Spell


" Definitions:
" ------------

syn match pandocDefinitionBlock /^.*\n\(^\s*\n\)*\s\{0,2}[:~]\(\s\{1,3}\|\t\).*\n\(\(^\s\{4,}\|^\t\).*\n\)*/ skipnl contains=pandocDefinitionBlockTerm,pandocDefinitionBlockMark,pandocLinkArea,pandocEmphasis,pandocStrong,pandocNoFormatted,pandocStrikeout,pandocSubscript,pandocSuperscript,@Spell
syn match pandocDefinitionBlockTerm /^.*\n\(^\s*\n\)*\(\s*[:~]\)\@=/ contained containedin=pandocDefinitionBlock contains=pandocNoFormatted,pandocEmphasis
syn match pandocDefinitionBlockMark /^\s*[:~]/ contained containedin=pandocDefinitionBlock


" Footnotes:
" ----------

syn match pandocFootnoteID /\[\^[^\]]\+\]/ nextgroup=pandocFootnoteDef
"   Inline footnotes
syn region pandocFootnoteDef matchgroup=pandocFootnoteID start=/\^\[/ end=/\]/ contains=pandocLinkArea,pandocLatex,pandocPCite,@Spell skipnl
syn region pandocFootnoteBlock start=/\[\^.\{-}\]:\s*\n*/ end=/^\n^\s\@!/ contains=pandocLinkArea,pandocLatex,pandocPCite,pandocStrong,pandocEmphasis,pandocNoFormatted,pandocSuperscript,pandocSubscript,pandocStrikeout,@Spell skipnl
syn match pandocFootnoteID /\[\^.\{-}\]/ contained containedin=pandocFootnoteBlock


" Citations:
" ----------

" parenthetical citations
syn match pandocPCite /\[-\{0,1}@.\{-}\]/ skipnl contains=pandocEmphasis,pandocStrong,pandocLatex,@Spell
" in-text citations without location
syn match pandocPCite /@\w*/ 
" in-text citations with location
syn match pandocPCite /@\w*\s\[.\{-}\]/ 


" Strikeout:
" ----------

syn match pandocStrikeout /\~\~[^\~ ]\([^\~]\|\~ \)*\~\~/ contains=@Spell 


" List Items:
" -----------

syn match pandocListItem /^\s*\([*+-]\|\((*\d\+[.)]\+\)\|\((*\l[.)]\+\)\)\s\+/he=e-1 nextgroup=pandocPara
syn match pandocListItem /^\s*(*\u[.)]\+\s\{2,}/he=e-1 nextgroup=pandocPara
syn match pandocListItem /^\s*(*[#][.)]\+\s\{1,}/he=e-1 nextgroup=pandocPara
syn match pandocListItem /^\s*(*@.\{-}[.)]\+\s\{1,}/he=e-1 nextgroup=pandocPara


" Horizontal Rules:
" -----------------

" 3 or more * on a line
syn match pandocHRule /\s\{0,3}\(-\s*\)\{3,}\n/
" 3 or more - on a line
syn match pandocHRule /\s\{0,3}\(\*\s*\)\{3,}\n/


" Link Everything Up

hi link pandocTitleBlock    PreProc
hi link pandocAtxHeader     Title
hi link pandocSetexHeader   Title

hi link pandocBlockQuote                    Comment
hi link pandocCodeBlock                     String
hi link pandocDelimitedCodeBlock            String
hi link pandocDelimitedCodeBlockLanguage    Comment
hi link pandocCodePre                       String

hi link pandocCommentSection Comment

hi link pandocListItem  Operator

hi link pandocLinkArea		    Type
hi link pandocLinkText		    Type
hi link pandocLinkURL	        Underlined
hi link pandocLinkTextRef       Underlined
hi link pandocLinkTitle         Identifier
hi link pandocAutomaticLink     Underlined

hi link pandocDefinitionBlockTerm   Identifier
hi link pandocDefinitionBlockMark   Operator

hi link pandocFootnoteID		Type
hi link pandocFootnoteDef		Comment
hi link pandocFootnoteBlock     Comment

hi link pandocPCite     Label

hi link pandocHRule     Underlined

hi pandocEmphasis   gui=italic  cterm=italic
hi pandocStrong     gui=bold    cterm=bold

hi link pandocNoFormatted   String
hi link pandocSubscript     Special
hi link pandocSuperscript   Special
hi link pandocStrikeout     Special
