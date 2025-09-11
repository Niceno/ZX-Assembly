;===============================================================================
; Color_Tile
;-------------------------------------------------------------------------------
; Purpose:
; - Colors a tile defined by upper left and lower right corner
;
; Parameters (passed via registers)
; - A:  color
; - BC: starting row (B) and column (C) - upper left corner
; - DE: ending (and inclusive) row (D) and column (E) - lower right corner
;
; Clobbers:
; - AF, BC, DE, HL ... but should be double checked
;
; Notes:
; - There is a very similar, and older, subroutine called Color_Text_Box.  This
;   one is arguably simpler, maybe even faster, and might superseed the other.
;   Not sure yet.  The other one is doing a descent job when painting text.
; - Parameters are NOT the same as in the call to Color_Text_Box.
;-------------------------------------------------------------------------------
Color_Tile:

  ex AF, AF'  ; keep color in A shadow for the entire routine

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

      ; Set the HL to the proper row in the screen memory
      ld DE, MEM_SCREEN_COLORS  ; load DE with the address of screen color
      ld H, 0
      ld L, B     ; this will place row into HL
      add HL, HL  ; HL = HL *  2
      add HL, HL  ; HL = HL *  4
      add HL, HL  ; HL = HL *  8
      add HL, HL  ; HL = HL * 16
      add HL, HL  ; HL = HL * 32
      add HL, DE

      ; Set the proper column
      ld D, 0
      ld E, C
      add HL, DE

      ; The following line is the central action, really
      ex AF, AF'  ; retreive the color from the shadow
      ld (HL), A
      ex AF, AF'  ; go back to your usual A

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

