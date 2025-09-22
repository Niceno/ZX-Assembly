;===============================================================================
; Merge_Narrow_Hex_Digit
;-------------------------------------------------------------------------------
; Purpose:
; - Merges a "low" (right aligned) or a "high" (left aligned) digit as a
;   hexadecial number (from 0 to F)
;
; Parameters:
; - A:  digit (0-15) to print as hexadecimal
; - HL: beginning of the memory where characters are defined
;
; Clobbers:
; - nothing
;
; Note:
; - This is a "local function", called only from Print_Hex_Byte
;   that's why it is not in a separate file
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
  call Merge_Udgs_Character

  pop AF
  pop BC
  pop DE
  pop HL

  ret

