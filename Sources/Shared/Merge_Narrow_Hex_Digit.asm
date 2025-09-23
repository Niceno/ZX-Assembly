;===============================================================================
; Merge_Narrow_Hex_Digit
;-------------------------------------------------------------------------------
; Purpose:
; - Merges a "low" (right aligned) or a "high" (left aligned) digit as a
;   hexadecial number (from 0 to F)
;
; Parameters:
; - A:  digit (0-15) to print as hexadecimal
; - BC: row and column, passed to Merge_Udgs_Character
; - HL: beginning of the memory where characters are defined
;
; Calls:
; - Merge_Udgs_Character
;
; Clobbers:
; - nothing
;-------------------------------------------------------------------------------
Merge_Narrow_Hex_Digit:

  push HL
  push DE
  push BC
  push AF

  ; A is now the digit, multiply it with eight so that it becomes memory offset
  add A, A
  add A, A
  add A, A

  ; Calculate address of the string (string_0 to string_F)
  ld D, 0
  ld E, A                ; DE = digit value (0-15)
  add HL, DE             ; now point to the right character in the table

  ; Print the string
  call Merge_Udgs_Character  ; HL: pnt to character; B and C: row and column

  pop AF
  pop BC
  pop DE
  pop HL

  ret

