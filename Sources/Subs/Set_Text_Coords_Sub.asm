;===============================================================================
; Set_Text_Coords_Sub
;-------------------------------------------------------------------------------
; Purpose:
; - Set coordinates for printing text
;
; Parameters (passed via registers):
; - BC: row and column
;
; Clobbers:
; - What not?  Calls ROM routines
;
; Note:
; - I am trying to save BC here because it is often used for storing rows and
;   column in caller subroutines
;-------------------------------------------------------------------------------
Set_Text_Coords_Sub:

  push BC

  ld A, CHAR_AT_CONTROL  ; ASCII control code for "at"
                         ; should be followed by row and column entries
  rst ROM_PRINT_A_1      ; "print" it

  ld A, B                ; row
  rst ROM_PRINT_A_1      ; "print" it

  ld A, C                ; column
  rst ROM_PRINT_A_1      ; "print" it

  pop BC

  ret
