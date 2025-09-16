  include "Spectrum_Constants.inc"

;--------------------------------------
; Set the architecture you'll be using
;--------------------------------------
  device zxspectrum48

;-----------------------------------------------
; Memory address at which the program will load
;-----------------------------------------------
  org MEM_PROGRAM_START

;===============================================================================
; Main subroutine begins here
;-------------------------------------------------------------------------------
Main:  ; If the adress is that of a subroutine, end it up with  suffix

  ;----------------------------------
  ; Open the channel to upper screen
  ;----------------------------------
  call Open_Upper_Screen

  ;-----------------------
  ;
  ; Print an 8-bit number
  ;
  ;-----------------------
  ld B,  11                 ; row
  ld C,  11                 ; column
  ld HL, $0039              ; number to print
  call Print_08_Bit_Number

  ld A, WHITE_INK + RED_PAPER
  ld B,  11        ; row
  ld C,  11        ; column
  ld E,   3        ; length
  call Color_Line

  ;-----------------------
  ;
  ; Print a 16-bit number
  ;
  ;-----------------------
  ld B,  9                  ; row
  ld C,  9                  ; column
  ld HL, $3039              ; number to print
  call Print_16_Bit_Number

  ld A, WHITE_INK + BLUE_PAPER
  ld B,   9        ; row
  ld C,   9        ; column
  ld E,   5        ; length
  call Color_Line

  ei  ; <--= (re)enable interrupts if you want to return to OS/BASIC

  ret

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   SUBROUTINES
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  include "Subs/Open_Upper_Screen.asm"
  include "Subs/Udgs/Merge_Character.asm"
  include "Subs/Calculate_Screen_Attribute_Address.asm"
  include "Subs/Color_Line.asm"
  include "Subs/Calculate_Screen_Pixel_Address.asm"
  include "Subs/Print_Character.asm"
  include "Subs/Print_String.asm"
  include "Subs/Print_08_Bit_Number.asm"
  include "Subs/Print_16_Bit_Number.asm"

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   DATA
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  include "Global_Data.inc"

number_source:
  defw 12345    ; define word or two bytes, 16 bits, 2^16 = 65536

;-------------------------------------------------------------------------------
; Save a snapshot that starts execution at the address marked with Main
;-------------------------------------------------------------------------------
  savesna "bojan_011.sna", Main
  savebin "bojan_011.bin", Main, $ - Main
