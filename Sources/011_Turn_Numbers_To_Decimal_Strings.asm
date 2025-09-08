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
Main_Sub:  ; If the adress is that of a subroutine, end it up with _Sub suffix

  ;----------------------------------
  ; Open the channel to upper screen
  ;----------------------------------
  call Open_Upper_Screen_Sub

  ;-----------------------
  ;
  ; Print a 16-bit number
  ;
  ;-----------------------
  ld BC, $0909                  ; row and column
  ld HL, $3039                  ; number to print
  call Print_16_Bit_Number_Sub

  ld A, WHITE_INK + BLUE_PAPER  ; color of the string
  ld BC, $0909                  ; row and column
  ld DE, $0501                  ; length and height
  call Color_Text_Box_Sub

  ;-----------------------
  ;
  ; Print an 8-bit number
  ;
  ;-----------------------
  ld BC, $0B0B                  ; row and column
  ld HL, $0039                  ; number to print
  call Print_08_Bit_Number_Sub

  ld A, WHITE_INK + RED_PAPER  ; color of the string
  ld BC, $0B0B                 ; row and column
  ld DE, $0301                 ; length and height
  call Color_Text_Box_Sub

  ei  ; <--= (re)enable interrupts if you want to return to OS/BASIC

  ret

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   SUBROUTINES
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  include "Subs/Open_Upper_Screen_Sub.asm"
  include "Subs/Merge_Udgs_Character_Sub.asm"
  include "Subs/Color_Text_Box_Sub.asm"
  include "Subs/Print_Character_Sub.asm"
  include "Subs/Print_String_Sub.asm"
  include "Subs/Print_Null_Terminated_String_Sub.asm"
  include "Subs/Print_08_Bit_Number_Sub.asm"
  include "Subs/Print_16_Bit_Number_Sub.asm"

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   DATA
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  include "Global_Data.inc"

number_source:
  defw 12345    ; define word or two bytes, 16 bits, 2^16 = 65536

;-------------------------------------------------------------------------------
; Save a snapshot that starts execution at the address marked with Main_Sub
;-------------------------------------------------------------------------------
  savesna "bojan.sna", Main_Sub
  savebin "bojan.bin", Main_Sub, $ - Main_Sub
