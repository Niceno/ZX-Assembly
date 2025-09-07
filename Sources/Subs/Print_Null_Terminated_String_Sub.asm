;===============================================================================
; Print_Null_Terminated_String_Sub
;-------------------------------------------------------------------------------
; Purpose:
; - Prints a string terminated with a null
;
; Parameters (passed via registers):
; - HL: holds the address of text to print
;
; Clobbers:
; - What not?  Calls ROM routines
;
; Note:
; - I am trying to save BC here because it is often used for storing rows and
;   column in caller subroutines
;-------------------------------------------------------------------------------
Print_Null_Terminated_String_Sub:

  push BC

Print_Null_Terminated_String_Loop:

  ld A, (HL)
  cp 0                                    ; compare A with zero
  jr z, Print_Null_Terminated_String_Done ; if zero, you are done
  rst ROM_PRINT_A_1                       ; if not zero, print the character ...
  inc HL                                  ; ... move on to the next address ...
  jr Print_Null_Terminated_String_Loop    ; ... and repeat

Print_Null_Terminated_String_Done:

  pop BC

  ret
