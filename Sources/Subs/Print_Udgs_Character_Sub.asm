;===============================================================================
; Print_Udgs_Character_Sub
;-------------------------------------------------------------------------------
; Purpose:
; - Prints a single user defined character by directly addressing screen memory
;
; Parameters (passed via memory locations):
; - text_row
; - text_column
;
; Constant array
; - screen_row_offset
;-------------------------------------------------------------------------------
Print_Udgs_Character_Sub:

  ld IX, (udgs_address)

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
Print_Udgs_Character_Loop:
  ld A, (IX)
  ld(HL), A
  inc H                ; increase position at the screen (HL = HL + 256)
  inc IX               ; increase position in the memory
  djnz Print_Udgs_Character_Loop

  ret

