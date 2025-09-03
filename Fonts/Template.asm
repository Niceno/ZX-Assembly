  include "../Sources/Spectrum_Constants.inc"

;--------------------------------------
; Set the architecture you'll be using
;--------------------------------------
  device zxspectrum48

;-----------------------------------------------
; Memory address at which the program will load
;-----------------------------------------------
  org MEM_CUSTOM_FONT_START

; [Name of the font] font
Custom_Font:
  ...
  ...
  96 lines come here, looking more or less like this:
  ...
  defb $7e,$4e,$0e,$3c,$0e,$4e,$7e,$00 ; 3
  defb $fc,$9c,$9c,$9c,$9c,$fe,$1c,$00 ; 4
  defb $7e,$4e,$40,$7e,$0e,$4e,$7e,$00 ; 5
  defb $7e,$4e,$40,$7e,$4e,$4e,$7e,$00 ; 6
  ...
  ...

;-------------------------------------------------------------------------------
; Save a snapshot that starts execution at the address marked with Custom_Font
;-------------------------------------------------------------------------------
  savebin "custom_font.bin", Custom_Font, $ - Custom_Font
