" I had to comment line 54 in /usr/share/vim/vim82/autoload/dist/ft.vim in order
" to over-ride the default detection of assembly language

" Remove any existing autocmd for asm files
autocmd! BufNewFile,BufRead *.asm
autocmd! BufNewFile,BufRead *.inc

" Set our custom filetype
autocmd BufNewFile,BufRead *.asm setf sjasm
autocmd BufNewFile,BufRead *.inc setf sjasm

