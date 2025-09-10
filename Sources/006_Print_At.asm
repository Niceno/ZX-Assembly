  include "Spectrum_Constants.inc"

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

  ;-----------------
  ; Set custom font
  ;-----------------
  call Set_Custom_Font

  ;--------------------------
  ; Set coordinates to 15, 5
  ;--------------------------
  ld BC, $0F05              ; row and column
  ld HL, asterisk           ; address of the asterisk
  call Print_Character  ; HL & BC are the parameter

  ;---------------------
  ; Color that asterisk
  ;---------------------
  ld A, RED_INK + YELLOW_PAPER  ; color of the string
  ld BC, $0F05                  ; row and column
  ld DE, $0101                  ; length and height
  call Color_Text_Box       ; A, BC & DE are parameters

  ;--------------------------------------------
  ; Set coordinates to 9, 9 and print a string
  ;--------------------------------------------
  ld BC, $0909             ; row and column
  ld DE, $0E01             ; length and height
  call Color_Text_Box  ; A, BC & DE are parameters

  ld BC, $0909             ; row and column
  ld HL, bojan_string
  call Print_String

  ;-------------------------
  ; Color that line of text
  ;-------------------------
  ld A, RED_INK + YELLOW_PAPER  ; color of the string
  ld BC, $0909                  ; row and column
  ld DE, $0E01                  ; length and height
  call Color_Text_Box

  ;-----------------------------
  ; Print the five digit number
  ;-----------------------------
  ld BC, $0D0D                  ; row and column
  ld HL, 9999                   ; set the number
  call Print_16_Bit_Number

  ;-------------------
  ; Color that number
  ;-------------------
  ld A, RED_INK + CYAN_PAPER  ; color of the string
  ld BC, $0D0D                 ; row and column
  ld DE, $0501                 ; length and height
  call Color_Text_Box

  ;----------------
  ; Color a column
  ;----------------
  ld A, WHITE_INK + RED_PAPER
  ld BC, $0818                 ; row and column
  ld DE, $010A                 ; length and height
  call Color_Text_Box

  ;-------------
  ; Color a box
  ;-------------
  ld A, WHITE_INK + BLUE_PAPER
  ld BC, $0A1A                  ; row and column
  ld DE, $0303                  ; length and height
  call Color_Text_Box

  ei  ; <--= (re)enable interrupts if you want to return to OS/BASIC

  ret

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   SUBROUTINES
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  include "Subs/Open_Upper_Screen.asm"
  include "Subs/Set_Custom_Font.asm"
  include "Subs/Color_Text_Box.asm"
  include "Subs/Print_Character.asm"
  include "Subs/Print_String.asm"
  include "Subs/Print_16_Bit_Number.asm"

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   DATA
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  include "Global_Data.inc"

asterisk:     defb "*"
bojan_string: defb "Bojan is cool!", 0
number:       defw  9999         ; defw = define word  <---=

number_16_ascii_storage:  ; leave space for five digits, plus a trailing zero
  defb "00000", 0

;---------------------------------------------
; Custom font will end up at a custom address
;---------------------------------------------
  org MEM_CUSTOM_FONT_START
custom_font:
  include "../Fonts/Bubblegum.inc"

;-------------------------------------------------------------------------------
; Save a snapshot that starts execution at the address marked with Main
;-------------------------------------------------------------------------------
  savesna "bojan.sna", Main
  savebin "bojan.bin", Main, $ - Main
