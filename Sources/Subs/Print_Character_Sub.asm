;===============================================================================
; Print_Character_Sub
;-------------------------------------------------------------------------------
; Purpose:
; - Prints a single character by directly addressing screen memory
;
; Parameters (passed via memory locations):
; - text_column
; - text_to_print
;
; Constant array
; - screen_row_address
; - screen_row_offset
;-------------------------------------------------------------------------------
Print_Character_Sub:

  ld HL, (text_to_print)  ; point to the beginning of the string
  ld A, (HL)              ; store the character into A
  sub CHAR_SPACE          ; subtract the first character (space)
  ld H, 0                 ; copy A to HL ...
  ld L, A
  add HL, HL              ; ... and multiply it with 8
  add HL, HL
  add HL, HL
  ld D, H                 ; copy HL to DE
  ld E, L

  ld IX, MEM_FONT_START
  add IX, DE              ; point to the memory where the character is defined

  ld HL, MEM_SCREEN_PIXELS  ; upper left corner of the screen

  ld A, (text_column)
  ld D, 0     ; hight byte
  ld E, A     ; low byte
  add HL, DE  ; move to proper column

  ld B, 8              ; characters are eight lines high
Print_Character_Loop:
  ld A, (IX)
  ld(HL), A
  inc H                ; increase position at the screen (HL = HL + 256)
  inc IX               ; increase position in the memory
  djnz Print_Character_Loop

  ret

