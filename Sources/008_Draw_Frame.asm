;----------------------------------------------------------------------------
; Core constants for ZX Spectrum 48K: memory map, screen/attribute layout,
; colors, keyboard ports/keycodes, ROM char addresses, and project addresses
;----------------------------------------------------------------------------
  include "Include/Constants.inc"

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

  ;----------------------
  ; Set the border color
  ;----------------------
  ld A, MAGENTA_INK              ; load A with desired color
  call Set_Border_Color

  ;--------------
  ; Draw frame 1
  ;--------------
  ld B, 1 : ld C,  1  ; set the upper left corner
  ld D, 5 : ld E,  3  ; set the height and the width
  ld H, 1 : ld L, YELLOW_PAPER + BLUE_INK
  call Draw_Frame

  ;--------------
  ; Draw frame 2
  ;--------------
  ld B, 2 : ld C,  6
  ld D, 3 : ld E,  4
  ld H, 2 : ld L, WHITE_PAPER + RED_INK
  call Draw_Frame

  ;--------------
  ; Draw frame 3
  ;--------------
  ld B, 1 : ld C, 11
  ld D, 3 : ld E,  3
  ld H, 3 : ld L, YELLOW_PAPER + GREEN_INK
  call Draw_Frame

  ;--------------
  ; Draw frame 4
  ;--------------
  ld B, 2 : ld C, 16
  ld D, 4 : ld E,  4
  ld H, 4 : ld L, YELLOW_PAPER + BLACK_INK
  call Draw_Frame


  ei  ; <--= (re)enable interrupts if you want to return to OS/BASIC

  ret

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   SUBROUTINES
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  include "Shared/Set_Border_Color.asm"
  include "Shared/Draw_Frame.asm"

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   DATA
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  include "Include/Global_Data.inc"

;-------------------------------------------------------------------------------
; Save a snapshot that starts execution at the address marked with Main
;-------------------------------------------------------------------------------
  savesna "008_Draw_Frame.sna", Main
  savebin "008_Draw_Frame.bin", Main, $ - Main
