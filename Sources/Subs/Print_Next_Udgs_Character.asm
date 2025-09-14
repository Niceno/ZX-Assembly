;===============================================================================
; Print_Next_Udgs_Character
;-------------------------------------------------------------------------------
; Purpose:
; - Prints a single user defined character by directly addressing screen memory
;
; Parameters (passed via registers)
; - HL: address of the character
; - DE: already holds the screen addresss
;
; Clobbers:
; - probably just about all registers
;-------------------------------------------------------------------------------
Print_Next_Udgs_Character:

  ; Swap screen address with glyph address
  ; After this call, HL will hold the screen address and DE the glyph address
  ex DE, HL  ; store the character/sprite address in DE

  inc  HL  ; next column, inc L should do too
  push HL  ; store HL for the next call

  ;-----------------------------------------
  ; Copy the glyph definition to the screen
  ;-----------------------------------------
  ld A, (DE) : ld(HL), A : inc H : inc DE
  ld A, (DE) : ld(HL), A : inc H : inc DE
  ld A, (DE) : ld(HL), A : inc H : inc DE
  ld A, (DE) : ld(HL), A : inc H : inc DE
  ld A, (DE) : ld(HL), A : inc H : inc DE
  ld A, (DE) : ld(HL), A : inc H : inc DE
  ld A, (DE) : ld(HL), A : inc H : inc DE
  ld A, (DE) : ld(HL), A : inc H : inc DE

  pop DE  ; DE will store the screen address for the next call

  ret

