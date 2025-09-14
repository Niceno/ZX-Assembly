;===============================================================================
; Print_Udgs_Character
;-------------------------------------------------------------------------------
; Purpose:
; - Prints a single user defined character by directly addressing screen memory
;
; Parameters (passed via registers)
; - HL: address of the character
; - BC: row and column
;
; Clobbers:
; - probably just about all registers
;
; Notes:
; - This sub has a sister, called Merge_Udgs_Character, which merges the UDG
;   with what is already on the screen.
; - These two sisters should differ by one line of code only.
;-------------------------------------------------------------------------------
Print_Udgs_Character:

  ex DE, HL  ; store the character/sprite address in DE

  ;--------------------------
  ; Calculate screen address
  ;--------------------------
  ld A, B        ; B holds the row
  and %00000111  ; keep only three lower bits ...
  add A, A       ; ... and multiply with 32 ...
  add A, A       ; ... since there are 32 ...
  add A, A       ; ... columns on Speccy's ...
  add A, A       ; ... screen.
  add A, A       ; five additions is multiplying with 32
  ld L, A        ; store the result in lower part of the HL pair

  ; Now take care of the Speccy's screen sectioning in thirds, 2nd section
  ; starts at the offset of 2048, third section at the offset of 4096
  ld   A, B       ; load row into A
  and  %00011000  ; Delete bits 0..2 and keep 3..4.  Thus if row is bigger than
                  ; 7, A will hold bit 3 which is 2048 when in H.  If the row
                  ; is bigger than 15, A will hold bit 4, which is 4096 in H
                  ; Since there are only 24 rows (from 0 to 23), row number
                  ; will never hold both bits 3 and 4 (16+8=24)
  or   $40        ; add 16384 (MEM_SCREEN_PIXELS = $4000) to HL
  ld   H, A

  ; Add column
  ld  B,  0
  add HL, BC  ; HL = (row, col) byte  add HL, BC

  ; Store the screen address for the next call
  push HL

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

