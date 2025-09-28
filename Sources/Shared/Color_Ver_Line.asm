;===============================================================================
; Color_Ver_Line
;-------------------------------------------------------------------------------
; Purpose:
; - Colors a vertical line of cells defined by upper left corner and height
;
; Parameters (passed via registers)
; - A:  color
; - BC: starting row (B) and column (C) - upper left corner
; - D:  height of the color strip (in rows)
;
; Calls:
; - Calculate_Screen_Attribute_Address
;
; Clobbers:
; - AF, AF', BC, DE, HL ... but should be double checked
;-------------------------------------------------------------------------------
Color_Ver_Line

  ;--------------------------------------
  ; Calculate screen attributes' address
  ;--------------------------------------
  push DE       ; store the length (E)
  ex   AF, AF'  ; use the shadow registers for calculations

  call Calculate_Screen_Attribute_Address

  pop DE       ; restore the column
  ex  AF, AF'  ; get the value of the color back

  ld BC, CELL_COLS  ; avoid ghost number 32

  ;----------------------
  ; Color along the line
  ;----------------------
.loop
    ld (HL), A
    dec D
    add HL, BC
  jr nz, .loop

  ret

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   SHARED SUBROUTINES
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  include "Shared/Calculate_Screen_Attribute_Address.asm"

