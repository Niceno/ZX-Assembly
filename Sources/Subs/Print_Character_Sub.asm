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

  ; Calculate screen address from row and column
  ld A, (text_row)        ; get row number (0-23)
  add A, A                ; multiply by 2 (each offset is 2 bytes)
  ld E, A
  ld D, 0
  ld HL, screen_row_offset
  add HL, DE              ; HL points to the offset for this row

  ; Load offset into BC
  ld C, (HL)              ; get low byte of offset
  inc HL
  ld B, (HL)              ; get high byte of offset
  ; Now BC = row offset

  ld HL, MEM_SCREEN_PIXELS
  add HL, BC              ; HL = screen start + row offset

  ; Now add column offset
  ld A, (text_column)
  ld C, A
  ld B, 0
  add HL, BC              ; HL now points to correct screen position


  ld B, 8              ; characters are eight lines high
Print_Character_Loop:
  ld A, (IX)
  ld(HL), A
  inc H                ; increase position at the screen (HL = HL + 256)
  inc IX               ; increase position in the memory
  djnz Print_Character_Loop

  ret

