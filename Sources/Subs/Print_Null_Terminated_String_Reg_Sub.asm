;===============================================================================
; Print_Null_Terminated_String_Reg_Sub
;-------------------------------------------------------------------------------
; Purpose:
; - Prints a string terminated with a null
;
; Parameters (passed via registers):
; - HL: holds the address of text to print
;-------------------------------------------------------------------------------
Print_Null_Terminated_String_Reg_Sub:

Print_Null_Terminated_String_Reg_Loop:

  ld A, (HL)
  cp 0                                        ; compare A with zero
  jr z, Print_Null_Terminated_String_Reg_Done ; if zero, you are done
  rst ROM_PRINT_A_1                           ; if not zero, print the character ...
  inc HL                                      ; ... move on to the next address ...
  jr Print_Null_Terminated_String_Reg_Loop    ; ... and repeat

Print_Null_Terminated_String_Reg_Done:

  ret
