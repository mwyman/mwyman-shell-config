" Vim syntax file
" Language:	pbxproj
" Maintainer:	manicmaniac
" Updaters:	manicmaniac
" URL:		https://github.com/manicmaniac/vim/
" Changes:	(manicmaniac)first commit
" Last Change:	2013 Dec 05

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
" tuning parameters:
" unlet pbxproj_fold

if !exists("main_syntax")
  if version < 600
    syntax clear
  elseif exists("b:current_syntax")
    finish
  endif
  let main_syntax = 'pbxproj'
endif

let s:cpo_save = &cpo
set cpo&vim

" Drop fold if it set but vim doesn't support it.
if version < 600 && exists("pbxproj_fold")
  unlet pbxproj_fold
endif


syn match   pbxprojFileName         "\S\+\.\w\+" contained
syn match   pbxprojLineComment      "\/\/.*"
			\ contains=@Spell,pbxprojFileName
syn match   pbxprojCommentSkip      "^[ \t]*\*\($\|[ \t]\+\)"
syn region  pbxprojComment	       start="/\*"  end="\*/"
			\ contains=@Spell,pbxprojFileName
syn match   pbxprojReference        "\x\{24\}"
syn match   pbxprojSpecial	       "\\\d\d\d\|\\."
syn region  pbxprojStringD	       start=+"+  skip=+\\\\\|\\"+  end=+"\|$+	contains=pbxprojSpecial,@htmlPreproc
syn region  pbxprojStringS	       start=+'+  skip=+\\\\\|\\'+  end=+'\|$+	contains=pbxprojSpecial,@htmlPreproc

syn match   pbxprojSpecialCharacter "'\\.'"
syn match   pbxprojNumber	       "-\=\<\d\+L\=\>\|0[xX][0-9a-fA-F]\+\>"
syn region  pbxprojRegexpString     start=+/[^/*]+me=e-1 skip=+\\\\\|\\/+ end=+/[gi]\{0,2\}\s*$+ end=+/[gi]\{0,2\}\s*[;.,)\]}]+me=e-1 contains=@htmlPreproc oneline

syn keyword pbxprojBoolean		true false
syn keyword pbxprojNull		null undefined

if exists("pbxproj_fold")
    syn match	pbxprojFunction	"\<function\>"
    syn region	pbxprojFunctionFold	start="\<function\>.*[^};]$" end="^\z1}.*$" transparent fold keepend

    syn sync match pbxprojSync	grouphere pbxprojFunctionFold "\<function\>"
    syn sync match pbxprojSync	grouphere NONE "^}"

    setlocal foldmethod=syntax
    setlocal foldtext=getline(v:foldstart)
else
    syn keyword pbxprojFunction	function
    syn match	pbxprojBraces	   "[{}\[\]]"
    syn match	pbxprojParens	   "[()]"
endif

syn sync fromstart
syn sync maxlines=100

if main_syntax == "pbxproj"
  syn sync ccomment pbxprojComment
endif

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_pbxproj_syn_inits")
  if version < 508
    let did_pbxproj_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif
  HiLink pbxprojComment		Comment
  HiLink pbxprojLineComment		Comment
  HiLink pbxprojReference	Comment
  HiLink pbxprojFileName		Identifier
  HiLink pbxprojSpecial		Special
  HiLink pbxprojStringS		String
  HiLink pbxprojStringD		String
  HiLink pbxprojCharacter		Character
  HiLink pbxprojSpecialCharacter	pbxprojSpecial
  HiLink pbxprojNumber		pbxprojValue
  HiLink pbxprojFunction		Function
  HiLink pbxprojBraces		Function
  HiLink pbxprojError		Error
  HiLink javaScrParenError		pbxprojError
  HiLink pbxprojNull			Keyword
  HiLink pbxprojBoolean		Boolean
  HiLink pbxprojRegexpString		String

  HiLink pbxprojDebug		Debug
  HiLink pbxprojConstant		Label

  delcommand HiLink
endif

let b:current_syntax = "pbxproj"
if main_syntax == 'pbxproj'
  unlet main_syntax
endif
let &cpo = s:cpo_save
unlet s:cpo_save

" vim: ts=8
