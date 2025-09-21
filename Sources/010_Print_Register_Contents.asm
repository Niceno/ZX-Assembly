  include "Constants.inc"

;--------------------------------------
; Set the architecture you'll be using
;--------------------------------------
  device zxspectrum48

;-----------------------------------------------
; Memory address at which the program will load
;-----------------------------------------------
  org MEM_PROGRAM_START

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   MAIN SUBROUTINE
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

;===============================================================================
; Main subroutine begins here
;-------------------------------------------------------------------------------
Main:

  ;----------------------------------
  ; Open the channel to upper screen
  ;----------------------------------
  call Open_Upper_Screen

  ;---------------------------------------------
  ; Real life example - see which registers get
  ; clobbered with a call to Print_Character
  ;---------------------------------------------
  call Print_Registers
  push AF
  push BC
  push DE
  push HL
  call Print_Character
  pop HL
  pop DE
  pop BC
  pop AF
  call Print_Registers

; Academic example  ;--------------------------------------------
; Academic example  ; Set registers to some test value and print
; Academic example  ; register contents for the first time
; Academic example  ;--------------------------------------------
; Academic example  ld BC, $F7FE  ; example value
; Academic example  ld DE, $3344  ; example value
; Academic example  ld HL, $ABCD  ; example value
; Academic example
; Academic example  exx
; Academic example  ld BC, $FEF7  ; example value
; Academic example  ld DE, $4433  ; example value
; Academic example  ld HL, $DCBA  ; example value
; Academic example  exx
; Academic example
; Academic example  call Print_Registers
; Academic example
; Academic example  ;--------------------------------------------
; Academic example  ; Set registers to some test value and print
; Academic example  ; register contents for the second time
; Academic example  ;--------------------------------------------
; Academic example  ld BC, $FEF7  ; example value, different on purpose
; Academic example  ld DE, $3344  ; example value
; Academic example  ld HL, $ABCD  ; example value
; Academic example
; Academic example  exx
; Academic example  ld BC, $FEF7  ; example value
; Academic example  ld DE, $5566  ; example value, different on purpose
; Academic example  ld HL, $DCBA  ; example value
; Academic example  exx
; Academic example
; Academic example  call Print_Registers

  ei  ; <--= (re)enable interrupts if you want to return to OS/BASIC

  ret

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   SUBROUTINES
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  include "Subs/Open_Upper_Screen.asm"
  include "Subs/Calculate_Screen_Attribute_Address.asm"
  include "Subs/Color_Line.asm"
  include "Subs/Calculate_Screen_Pixel_Address.asm"
  include "Subs/Print_Character.asm"
  include "Subs/Print_String.asm"
  include "Subs/Udgs/Print_Character.asm"
  include "Subs/Udgs/Merge_Character.asm"
  include "Subs/Udgs/Merge_Line_Sprite.asm"
  include "Subs/Udgs/Merge_Sprite.asm"
  include "Subs/Udgs/Merge_Line_Tile.asm"
  include "Subs/Udgs/Merge_Tile.asm"
  include "Subs/Merge_Grid.asm"
  include "Subs/Print_Registers.asm"

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   DATA
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  include "Global_Data.inc"

;-------------------------------------------------------------------------------
; Save a snapshot that starts execution at the address marked with Main
;-------------------------------------------------------------------------------
  savesna "bojan_010.sna", Main
  savebin "bojan_010.bin", Main, $ - Main
