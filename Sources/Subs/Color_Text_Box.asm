;===============================================================================
; Color_Text_Box
;-------------------------------------------------------------------------------
; Purpose:
; - Colors a box of text with specified length and height
;
; Parameters (passed via registers)
; - A:  color
; - BC: box row (B) and column (C)
; - DE: box length (D) and height (E)
;
; Clobbers:
; - AF, BC, DE
;
; Notes:
; - There is a very similar subroutine called Color_Tile_Box.  This one might
;   be replaced by the other completelly, or might just stay for coloring
;   static text boxes, it seems to do a decent job at that.
; - Parameters are NOT the same as in the call to Color_Tile_Box.
;-------------------------------------------------------------------------------
Color_Text_Box:

  ;---------------------------------------------
  ; Check if the box fits in the screen
  ; (I call it realizibility, don't ask me why)
  ;---------------------------------------------

  ; Realizability check 1: is C outside of the screen?
  ld H, A              ; store A in H
  ld A, C              ; load the column into A
  cp CELL_COL_MAX + 1  ; compare with "32" (the first invalid column)
  ret nc               ; return immediately if A >= "32" (column > "31")
  ; Realizability check 2: is C + D - 1 outside of the screen?
  add D                ; + length ...
  dec A                ; - 1 gives the last column printed
  cp CELL_COL_MAX + 1
  ret nc               ; return immediately if A >= "32" (column > "31")

  ; Realizability check 3: is B outside of the screen?
  ld A, B              ; load the row into A
  cp CELL_ROW_MAX + 1  ; compare with "24" (the first invalid row)
  ret nc               ; return immediately if A >= 24 (row > 23)
  ; Realizability check 4: is B + E - 1 outside of the screen?
  add E                ; + height ...
  dec A                ; ... - 1 give the last row printed
  cp CELL_ROW_MAX + 1  ; compare with "24" (the first invalid row)
  ret nc               ; return immediately if A >= 24 (row > 23)
  ld A, H              ; recover A from H

  push DE  ; length (D) and height (E)
  push AF  ; color (A)
  push BC  ; row (B) and column (C)

  ;------------------------------------------------------------------------
  ; Set initial value of HL to point to the beginning of screen attributes
  ;------------------------------------------------------------------------
  ld HL, MEM_SCREEN_COLORS  ; load HL with the address of screen color

  ;-------------------------------------------------------------
  ; Increase HL column times, to shift it to the desired column
  ;-------------------------------------------------------------
  ld A, C                        ; load column into A
  cp 0                           ; is A (now column) equal to zero?
  jr z, .skip_if_column_is_zero  ; if so, skip this loop
  ld B, C                        ; use B as the counter

.loop_columns:
    inc HL            ; increase HL text_row times
  djnz .loop_columns  ; decrease B and jump if nonzero

.skip_if_column_is_zero:  ; get here if column number is zero
  pop BC                  ; retreive (refresh) row and column

  ;-------------------------------------------------------------------
  ; Increase HL row * CELL_COLS times, to shift it to the desired row
  ;-------------------------------------------------------------------
  ld DE, CELL_COLS
  ld A, B                     ; fetch the row
  cp 0                        ; is A (now row) equal to zero?
  jr z, .skip_if_row_is_zero  ; if so, skip this loop

.loop_rows:
    add HL, DE     ; increase HL by CELL_COLS (to reach the next row)
  djnz .loop_rows  ; decrease B and repeat the loop if nonzero

.skip_if_row_is_zero:   ; get here if row count is zero

  ;---------------------------------------------------------------
  ; Now the HL holds the correct position of the screen attribute
  ; perfrom a double loop throug rows and columns to color a box
  ;---------------------------------------------------------------
  pop AF   ; retreive the color
  ld C, A  ; store the color in C
  pop DE   ; retreive lenght (D) and height (E) again
  ld A, E  ; A stores height, will be the outer loop

.loop_height:  ; loop over A, outer loop

    push DE  ; store DE which holds length (D) and height
    push HL  ; store HL at the first row position

    ld B, D           ; B stores the lengt, will be inner loop
    ld DE, CELL_COLS  ; number of columns now, to be added to HL

.loop_length:     ; loop over B, inner loop
      ld (HL), C  ; set color at position pointed by HL registers
      inc HL      ; go to the next horizontal position
    djnz .loop_length

    pop HL      ; retreive the first positin in the row
    add HL, DE  ; add the number of columns -> go to the next row
    pop DE      ; retreive length (D) and height (E)

    dec A              ; decrease A, outer loop counter

  jr nz, .loop_height  ; repeat if A is nonzero

  ret

