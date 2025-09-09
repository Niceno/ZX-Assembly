"------------------------------------------------------------
" Colorscheme file or syntax highlighting customization file
"
" Available colors on most terminals:
" - Black, DarkGray, Gray, LightGray, White
" - Red, LightRed, DarkRed
" - Green, LightGreen, DarkGreen
" - Yellow, LightYellow, DarkYellow (often Brown)
" - Blue, LightBlue, DarkBlue
" - Magenta, LightMagenta, DarkMagenta (often Purple)
" - Cyan, LightCyan, DarkCyan
"   (You can also use numbers: ctermfg=1 to ctermfg=15
"   (usually 8 basic + 8 bright))
"
" Available text attributes:
" - bold - Bold text
" - italic - Italic text (may not work in all terminals)
" - underline - <u>Underlined text</u>
" - reverse - Reverse video (inverse colors)
" - standout - Extra highlighting
" - Multiple attributes: cterm=bold,underline
"------------------------------------------------------------

" I am trying to follow the order in the syntax/sjasm.vim file
" Keyords should be Fortran commands
highlight sjasmInstruction ctermfg=DarkYellow

" Sjasm-specific commands
highlight sjasmDirective  ctermfg=Magenta

" Strings ... they are kind of lame, paint them gray
highlight sjasmString  ctermfg=DarkGray

" Operators ... I don't know, maybe the same as keywords
highlight sjasmRegister  ctermfg=Green

" Ghost numbers are not desirable, mark them red
highlight sjasmNumber  ctermfg=Red  cterm=bold

" Constants are better than ghost numbers, mark them blue ...
" ... they are safer, they are in effect former ghost numbers
highlight sjasmConstant  ctermfg=Blue

" Just Comment didn't work, sjasmComment did
highlight sjasmComment  ctermfg=DarkCyan
