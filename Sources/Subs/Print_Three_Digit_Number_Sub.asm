;===============================================================================
; Print_Three_Digit_Number_Sub
;-------------------------------------------------------------------------------
; Purpose:
; - Prints right-aligned, three digit number
;
; Parameters (passed via memory locations):
; - BC: holds the value to be printed
;-------------------------------------------------------------------------------
Print_Three_Digit_Number_Sub:

  ; Check if it has 3 digits
  ld  HL, BC                                      ; store number in HL
  ld  DE, 100                                     ; store dividend in DE
  or A                                            ; clear the c flag
  sbc HL, DE                                      ; HL = HL - DE
  jr nc, Print_Three_Digits_Number_Done_Padding   ; HL > 100
  ld A, CHAR_SPACE                                ; print an underscore
  rst ROM_PRINT_A_1                               ; display it

  ; Check if it has 2 digits
  ld  HL, BC                                      ; store number in HL
  ld  DE, 10                                      ; store dividend in DE
  or A                                            ; clear the c flag
  sbc HL, DE                                      ; HL = HL - DE
  jr nc, Print_Three_Digits_Number_Done_Padding   ; HL > 10
  ld A, CHAR_SPACE                                ; print an underscore
  rst ROM_PRINT_A_1                               ; display it

Print_Three_Digits_Number_Done_Padding:
  call ROM_OUT_NUM_1

  ret

