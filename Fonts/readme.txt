OK, this seems to be something I was crawing for:

https://damieng.com/typography/zx-origins/

Just click there and marvel the selection of fonts.

Once you find a font you are interested in, you can click on it.
For the sake of the argument, let's assume you clicked on:

https://damieng.com/typography/zx-origins/computing-60s/

Among other thing, it allows you download the font.  In this case, it is:

https://dl.damieng.com/fonts/zx-origins/Computing%2060s.zip

Which gives you a myriad of formats.  Since I am already familiar with .asm
file format, that's the one I am going to extract.  Say, I extracted it to file:

Fonts/Computing_60s.asm

But, it can't be compiled "just the way you extract it".  There are a few issues
with it.  First of all, you need a header and a footer which, in sjasmplus look
more or less like this:

Header:

;--------------------------------------
; Set the architecture you'll be using
;--------------------------------------
  device zxspectrum48

  ... data, data and more data

Footer:

;-------------------------------------------------------------------------------
; Save a snapshot that starts execution at the address marked with Custom_Font
;-------------------------------------------------------------------------------
  savebin "custom_font.bin", Custom_Font, $ - Custom_Font

But that's not all, the data has to be altered too.  You see, by default, the
.asm files comes with hexadecimal numbers denoted with an "&".  But that is
wrong, for sjasmplus it should be "$".  So, you should change that too.  In the
end, the file looks like:

  include "../Sources/Spectrum_Constants.inc"

;--------------------------------------
; Set the architecture you'll be using
;--------------------------------------
  device zxspectrum48

;-----------------------------------------------
; Memory address at which the program will load
;-----------------------------------------------
  org 64000  ; $FA00

; Computing 60s font
Custom_Font:
  defb $00,$00,$00,$00,$00,$00,$00,$00 ;··
  defb $38,$38,$38,$38,$10,$00,$38,$00 ; !
  ...
  ...
  92 lines are omitted
  ...
  ...
  defb $76,$7e,$6e,$00,$00,$00,$00,$00 ; ~
  defb $ff,$c1,$dd,$d9,$dd,$c1,$ff,$00 ; ©

;-------------------------------------------------------------------------------
; Save a snapshot that starts execution at the address marked with Custom_Font
;-------------------------------------------------------------------------------
  savebin "custom_font.bin", Custom_Font, $ - Custom_Font

OK, with this file in place, it can be compiled.  I compiled it with:

sjasmplus[.exe] Computing_60s.asm

which created the file:

custom_font.bin

The file should be 768 bytes long.

From the fuse emulator, you read that file at address 64000 and from the BASIC
prompt you type:

POKE 23607,249

To revert to original, type:

POKE 23607, 60

Here, 23607 ($5C37) is part of the ROM_CHARS variables, actually the higher byte
of the address where the custom font is stored.  Number 249 ($F9) is not a
random number either, it is used in "formula": (X + 1) * 256, to find the custom
font.  In this case, with X = 249, the address of the custom font is:

(249 + 1) * 256 = 64000

Works.  The original would be:

(60 + 1) * 256 = 15616, exactly MEM_FONT_START in Sources/Spectrum_Constants.inc


