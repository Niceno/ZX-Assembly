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
Main_Sub:

  ;----------------------------------
  ; Open the channel to upper screen
  ;----------------------------------
  call Open_Upper_Screen_Sub

  ;------------------------------
  ; Specify the beginning of UDG
  ;------------------------------
  ld hl, udgs                         ; user defined graphics (UDGs)
  ld (MEM_USER_DEFINED_GRAPHICS), hl  ; set up UDG system variable.

  ;---------------------------------------
  ; Address of the null-terminated string
  ;---------------------------------------
  ld HL, bojan_string  ; address where the string is stored
  ld BC, $0606         ; row and column

  ; Real life example - see which registers get
  ; clobbered with a call to Print_Character_Sub
  call Print_Registers_Sub
  push AF
  push BC
  push DE
  push HL
  call Print_Character_Sub
  pop HL
  pop DE
  pop BC
  pop AF
  call Print_Registers_Sub

; Academic example  ;--------------------------------------------
; Academic example  ; Set registers to some test value and print
; Academic example  ; register contents for the first time
; Academic example  ;--------------------------------------------
; Academic example  ld BC, $F7FE  ; example value
; Academic example  ld DE, $3344  ; example value
; Academic example  ld HL, $ABCD  ; example value
; Academic example
; Academic example  call Print_Registers_Sub
; Academic example
; Academic example  ;--------------------------------------------
; Academic example  ; Set registers to some test value and print
; Academic example  ; register contents for the second time
; Academic example  ;--------------------------------------------
; Academic example  ld BC, $FEF7  ; example value
; Academic example  ld DE, $3344  ; example value
; Academic example  ld HL, $ABCD  ; example value
; Academic example
; Academic example  call Print_Registers_Sub

  ei  ; <--= (re)enable interrupts if you want to return to OS/BASIC

  ret

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   SUBROUTINES
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  include "Subs/Open_Upper_Screen_Sub.asm"
  include "Subs/Print_Character_Sub.asm"
  include "Subs/Print_Udgs_Character_Sub.asm"
  include "Subs/Merge_Udgs_Character_Sub.asm"
  include "Subs/Set_Text_Coords_Sub.asm"
  include "Subs/Color_Text_Box_Sub.asm"
  include "Subs/Print_Null_Terminated_String_Sub.asm"
  include "Subs/Print_Registers_Sub.asm"

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   DATA
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  include "Global_Data.inc"

;---------------------------------
; Null-terminated string to print
;---------------------------------
bojan_string: defb "Bojan is cool!", 0

;-------------------------------------------------------------------------------
; Save a snapshot that starts execution at the address marked with Main_Sub
;-------------------------------------------------------------------------------
  savesna "bojan.sna", Main_Sub
  savebin "bojan.bin", Main_Sub, $ - Main_Sub
