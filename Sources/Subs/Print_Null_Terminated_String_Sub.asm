;===============================================================================
; Print_Null_Terminated_String_Sub
;-------------------------------------------------------------------------------
; Purpose:
; - Prints a string terminated with a null
;
; Parameters (passed via memory locations):
; - text_to_print
;-------------------------------------------------------------------------------
Print_Null_Terminated_String_Sub:

  ld HL, (text_to_print_addr)  ; address of the text to print

Print_Null_Terminated_String_Loop:

  ld A, (HL)
  cp 0                                    ; compare A with zero
  jr z, Print_Null_Terminated_String_Done ; if zero, you are done
  rst ROM_PRINT_A_1                       ; if not zero, print the character ...
  inc HL                                  ; ... move on to the next address ...
  jr Print_Null_Terminated_String_Loop    ; ... and repeat

Print_Null_Terminated_String_Done:

  ret
