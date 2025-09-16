;===============================================================================
; Merge_Udgs_Line_Sprite
;-------------------------------------------------------------------------------
; Purpose:
; - Merges a sequence of non-repetitive UDG characters at prescribed row and
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
;   > Merge_Udgs_Line_Sprite  (this one)
;   > Merge_Udgs_Line_Tile    (like this but chars are repetitive)
;   > Print_Udgs_Line_Sprite  (like this but chars are printed)
;   > Print_Udgs_Line_Tile    (like this but chars are printed & repetitive)
;-------------------------------------------------------------------------------
Merge_Udgs_Line_Sprite:

  push DE ; save the length

  ex DE, HL  ; store the character/sprite address in DE

  ;--------------------------
  ; Calculate screen address
  ;--------------------------
  call Calculate_Screen_Pixel_Address

  pop BC  ; this used to be DE, E held the length which is now in C

  ;-----------------------------------------
  ; Copy the glyph definition to the screen
  ;-----------------------------------------
.loop        ; loop through columns (length)
    push HL  ; store screen address
    ld A, (DE) : or(HL) : ld(HL), A : inc H : inc DE
    ld A, (DE) : or(HL) : ld(HL), A : inc H : inc DE
    ld A, (DE) : or(HL) : ld(HL), A : inc H : inc DE
    ld A, (DE) : or(HL) : ld(HL), A : inc H : inc DE
    ld A, (DE) : or(HL) : ld(HL), A : inc H : inc DE
    ld A, (DE) : or(HL) : ld(HL), A : inc H : inc DE
    ld A, (DE) : or(HL) : ld(HL), A : inc H : inc DE
    ld A, (DE) : or(HL) : ld(HL), A : inc H : inc DE
    pop HL      ; restore screen address

    inc HL      ; move to the next column on the screen
    dec C       ; decrease the length counter
  jr nz, .loop  ; if desired length not reached, repeat the loop

  ex DE, HL  ; return the character addresss to HL

  ret

