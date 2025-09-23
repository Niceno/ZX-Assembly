;===============================================================================
; Merge_Udgs_Character
;-------------------------------------------------------------------------------
; Purpose:
; - Merges a single user defined character by directly addressing screen memory
;
; Parameters (passed via registers)
; - HL: address of the character
; - BC: row and column
;
; Calls
; - Calculate_Screen_Pixel_Address
;
; Clobbers:
; - probably just about all registers
;
; Notes:
; - This sub has a sister, called Print_Udgs_Character, which prints the UDG
;   over-writing what's already on the screen.
; - These two sisters should differ by one line of code only.
;-------------------------------------------------------------------------------
Merge_Udgs_Character:

  ex DE, HL  ; store the character/sprite address in DE

  ;--------------------------
  ; Calculate screen address
  ;--------------------------
  call Calculate_Screen_Pixel_Address

  ;-----------------------------------------
  ; Copy the glyph definition to the screen
  ;-----------------------------------------
  ld A, (DE) : or(HL) : ld(HL), A : inc H : inc DE
  ld A, (DE) : or(HL) : ld(HL), A : inc H : inc DE
  ld A, (DE) : or(HL) : ld(HL), A : inc H : inc DE
  ld A, (DE) : or(HL) : ld(HL), A : inc H : inc DE
  ld A, (DE) : or(HL) : ld(HL), A : inc H : inc DE
  ld A, (DE) : or(HL) : ld(HL), A : inc H : inc DE
  ld A, (DE) : or(HL) : ld(HL), A : inc H : inc DE
  ld A, (DE) : or(HL) : ld(HL), A : inc H : inc DE

  ;? ex DE, HL  ; return the character addresss to HL

  ret

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   SHARED SUBROUTINES
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  include "Shared/Calculate_Screen_Pixel_Address.asm"

