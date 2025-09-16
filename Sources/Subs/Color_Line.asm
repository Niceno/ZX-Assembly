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
;
; Note:
; - To see why this works, scroll down!
;-------------------------------------------------------------------------------
Color_Line

  ;--------------------------------------
  ; Calculate screen attributes' address
  ;--------------------------------------
  push DE       ; store the length (E)
  ex   AF, AF'  ; use the shadow registers for calculations

  call Calculate_Screen_Attribute_Address

  pop DE      ; restore the column
  ex  AF, AF'  ; get the value of the color back

  ;----------------------
  ; Color along the line
  ;----------------------
.loop
    ld (HL), A
    dec E
    inc HL
  jr nz, .loop

  ret
