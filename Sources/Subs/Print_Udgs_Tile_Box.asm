;===============================================================================
; Print_Udgs_Tile_Box
;-------------------------------------------------------------------------------
; Purpose:
; - Prints a box filled up with single UDGs character
;
; Parameters (passed via registers)
; - HL: address of the UDG character to be printed
; - BC: starting row (B) and column (C)
; - DE: ending (and inclusive) row (D) and column (E)
;
; Clobbers:
; - AF, BC, DE, HL ... but should be double checked
;-------------------------------------------------------------------------------
Print_Udgs_Tile_Box:

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
      push BC  ; BC is the input, row and column for Print_Udgs_Character
      push DE
      push HL
      call Print_Udgs_Character  ; this clobbers B
      pop HL
      pop DE
      pop BC
      ;--------------------------------------------------------------
      ; Body (of the called sub), here B holds the row, C the column
      ;--------------------------------------------------------------

      inc C    ; move to the next column
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

