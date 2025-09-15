;===============================================================================
; Color_Line
;-------------------------------------------------------------------------------
; Purpose:
; - Colors a line of cells defined by upper left corner and the length
;
; Parameters (passed via registers)
; - A:  color
; - BC: starting row (B) and column (C) - upper left corner
; - E:  length of the color strip (in columns)
;
; Clobbers:
; - AF, BC, DE, HL ... but should be double checked
;-------------------------------------------------------------------------------
Color_Line

  push DE  ; store the length (E)

  ;--------------------------------------
  ; Calculate screen attributes' address
  ;--------------------------------------

  ; Set proper row
  ld H, 0
  ld L, B   ; HL now holds the row number
  add HL, HL  ; HL = HL *  2
  add HL, HL  ; HL = HL *  4
  add HL, HL  ; HL = HL *  8
  add HL, HL  ; HL = HL * 16
  add HL, HL  ; HL = HL * 32
  ld DE, MEM_SCREEN_COLORS  ; load DE with the address of screen color
  add HL, DE

  ; Set the proper column
  ld D, 0
  ld E, C
  add HL, DE

  pop DE  ; restore the column

.loop
    ld (HL), A
    dec E
    inc HL  
  jr nz, .loop

  ret

