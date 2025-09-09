"-----------------------------------
" Tuning the color scheme for sjasm
"-----------------------------------

" Keyords should be Fortran commands
highlight sjasmKeyword ctermfg=Yellow

" Ghost numbers are not desirable, mark them red
highlight sjasmNumber  ctermfg=Red

" Constants are better than ghost numbers, mark them blue ...
" ... they are safer, they are in effect former ghost numbers
highlight sjasmConstant  ctermfg=Blue

" Strings ... they are kind of lame, paint them gray
highlight sjasmString  ctermfg=Gray

" Operators ... I don't know, maybe the same as keywords
highlight sjasmOperator  ctermfg=Yellow

" Just Comment didn't work, sjasmComment did
highlight sjasmComment  ctermfg=Green

" Sjasm commands
highlight sjasmDirective  ctermfg=Magenta
