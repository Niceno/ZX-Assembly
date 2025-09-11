;===============================================================================
; Merge_Udgs_Sprite
;-------------------------------------------------------------------------------
; Purpose:
; - Merges a tile, defined by upper left and lower right corners, filled up
;   with and array of UDGs character, making it effectivelly a sprite.
;
; Parameters (passed via registers)
; - BC: starting row (B) and column (C) - upper left corner
; - DE: ending (and inclusive) row (D) and column (E) - lower right corner
; - HL: address of the UDG array of characters to be printed
;
; Clobbers:
; - AF, BC, DE, HL ... but should be double checked
;-------------------------------------------------------------------------------
Merge_Udgs_Sprite:

  ;---------------------------------------
  ;
  ; Outer loop; through rows, from B to D
  ;
  ;---------------------------------------
.outer_loop:
  push BC

    ;------------------------------------------
    ;
    ; Inner loop; through columns, from C to E
    ;
    ;------------------------------------------
.inner_loop:

      ;--------------------------------------------------------------
      ; Body (of the called sub), here B holds the row, C the column
      ;--------------------------------------------------------------
      push BC  ; BC is the input, row and column for Merge_Udgs_Character
      push DE
      push HL
      call Merge_Udgs_Character  ; this clobbers B
      pop HL
      pop DE
      pop BC
      ;--------------------------------------------------------------
      ; Body (of the called sub), here B holds the row, C the column
      ;--------------------------------------------------------------

      inc HL  ; move to the next character definition
      inc HL  ; each character ...
      inc HL  ; ... of course ...
      inc HL  ; ... is defined ...
      inc HL  ; ... with eight ...
      inc HL  ; ... bytes
      inc HL
      inc HL

      inc C  ; move to the next column
      ld A, C
      dec A
      cp E     ; did C already reach E?
    jr nz, .inner_loop

    pop BC

    inc B    ; move to the next row
    ld A, B
    dec A
    cp D     ; did B already reach D?
  jr nz, .outer_loop

  ret

