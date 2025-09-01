;===============================================================================
; Set_Text_Coords_Sub
;-------------------------------------------------------------------------------
; Purpose:
; - Set coordinates for printing text
;
; Parameters (passed via memory locations):
; - text_row
; - text_column
;-------------------------------------------------------------------------------
Set_Text_Coords_Sub:

  ld A, CHAR_AT_CONTROL  ; ASCII control code for "at"
                         ; should be followed by row and column entries
  rst ROM_PRINT_A_1      ; "print" it

  ld A, (text_row)       ; row
  rst ROM_PRINT_A_1      ; "print" it

  ld A, (text_column)    ; column
  rst ROM_PRINT_A_1      ; "print" it

  ret
