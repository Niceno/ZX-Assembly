;===============================================================================
; Press_Any_Key
;-------------------------------------------------------------------------------
; Purpose:
; - Runs an infinite loop until any key is pressed
;
; Parameters:
; - none
;
; Calls:
; - Browse_Key_Rows
;
; Clobbers:
; - AF, BC, DE, HL
;-------------------------------------------------------------------------------
Press_Any_Key:

.wait_for_a_key

  call Browse_Key_Rows      ; A = code, C bit0 = 1 if pressed
  bit 0, C
  jr  z, .wait_for_a_key

  ret

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   SHARED SUBROUTINES
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  include "Shared/Browse_Key_Rows.asm"
