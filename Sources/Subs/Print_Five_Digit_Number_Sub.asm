;===============================================================================
; Print_Five_Digit_Number_Sub
;-------------------------------------------------------------------------------
; Purpose:
; - Prints right-aligned, five digit number
;
; Parameters (passed via memory locations):
; - number
;-------------------------------------------------------------------------------
Print_Five_Digit_Number_Sub:

  ; Check if it has 5 digits
  ld  HL, (number)                               ; store number in HL
  ld  DE, 10000                                  ; store dividend in DE
  or A                                           ; clear the c flag
  sbc HL, DE                                     ; HL = HL - DE
  jr nc, Print_Five_Digits_Number_Done_Padding   ; HL > 10000
  ld A, CHAR_SPACE                               ; print an underscore
  rst ROM_PRINT_A_1                              ; display it

  ; Check if it has 4 digits
  ld  HL, (number)                               ; store number in HL
  ld  DE, 1000                                   ; store dividend in DE
  or A                                           ; clear the c flag
  sbc HL, DE                                     ; HL = HL - DE
  jr nc, Print_Five_Digits_Number_Done_Padding   ; HL > 1000
  ld A, CHAR_SPACE                               ; print an underscore
  rst ROM_PRINT_A_1                              ; display it

  ; Check if it has 3 digits
  ld  HL, (number)                               ; store number in HL
  ld  DE, 100                                    ; store dividend in DE
  or A                                           ; clear the c flag
  sbc HL, DE                                     ; HL = HL - DE
  jr nc, Print_Five_Digits_Number_Done_Padding   ; HL > 1000
  ld A, CHAR_SPACE                               ; print an underscore
  rst ROM_PRINT_A_1                              ; display it

  ; Check if it has 2 digits
  ld  HL, (number)                               ; store number in HL
  ld  DE, 10                                     ; store dividend in DE
  or A                                           ; clear the c flag
  sbc HL, DE                                     ; HL = HL - DE
  jr nc, Print_Five_Digits_Number_Done_Padding   ; HL > 1000
  ld A, CHAR_SPACE                               ; print an underscore
  rst ROM_PRINT_A_1                              ; display it

Print_Five_Digits_Number_Done_Padding:
  ld BC, (number)
  call ROM_STACK_BC  ; transform the number in BC register to floating point
  call ROM_PRINT_FP  ; print the floating point number in the calculator stack

  ret

