;===============================================================================
; Print_Udgs_Tile_Line
;-------------------------------------------------------------------------------
; Purpose:
; - Prints a sequence of repetitive UDG characters at prescribed row and
;   column, with a given length, by directly addressing screen's pixel memory
;
; Parameters
; - HL: address of the character
; - BC: row and column
; - E:  length of the line
;
; Clobbers:
; - probably just about all registers
;
; Notes:
; - This sub belongs to the group of four sisters:
;   > Merge_Udgs_Sprite_Line  (like this but chars are merged and non-repetive)
;   > Merge_Udgs_Tile_Line    (like this but chars are merged)
;   > Print_Udgs_Sprite_Line  (like this but chars are non-repetitive)
;   > Print_Udgs_Tile_Line    (this one)
;-------------------------------------------------------------------------------
Print_Udgs_Tile_Line:

  push DE ; save the length

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

  pop BC  ; this used to be DE, E held the length

  ;-----------------------------------------
  ; Copy the glyph definition to the screen
  ;-----------------------------------------
.loop        ; loop through columns (length)
    push DE  ; store character defintion
    push HL  ; store screen address
    ld A, (DE) : ld(HL), A : inc H : inc DE
    ld A, (DE) : ld(HL), A : inc H : inc DE
    ld A, (DE) : ld(HL), A : inc H : inc DE
    ld A, (DE) : ld(HL), A : inc H : inc DE
    ld A, (DE) : ld(HL), A : inc H : inc DE
    ld A, (DE) : ld(HL), A : inc H : inc DE
    ld A, (DE) : ld(HL), A : inc H : inc DE
    ld A, (DE) : ld(HL), A : inc H : inc DE
    pop HL      ; restore screen address
    pop DE      ; go back to character's definition

    inc HL      ; move to the next column on the screen
    dec C       ; decrease the length counter
  jr nz, .loop  ; if desired length not reached, repeat the loop

  ex DE, HL  ; return the character addresss to HL

  ret

