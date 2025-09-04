;===============================================================================
; Set_Text_Coords_Sub
;-------------------------------------------------------------------------------
; Purpose:
; - Set coordinates for printing text
;
; Parameters (passed via registers):
; - BC: row and column
;-------------------------------------------------------------------------------
Set_Text_Coords_Sub:

  ld A, CHAR_AT_CONTROL  ; ASCII control code for "at"
                         ; should be followed by row and column entries
  rst ROM_PRINT_A_1      ; "print" it

  ld A, B                ; row
  rst ROM_PRINT_A_1      ; "print" it

  ld A, C                ; column
  rst ROM_PRINT_A_1      ; "print" it

  ret
