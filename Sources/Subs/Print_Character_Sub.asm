;===============================================================================
; Print_Character
;-------------------------------------------------------------------------------
; Purpose:
; - Prints a single character by directly addressing screen memory
;
; Parameters (passed via registers)
; - HL: address of the character
; - BC: row and column
;
; Constant array
; - screen_row_offset
;
; Clobber:
; - AF, BC, DE and HL
;-------------------------------------------------------------------------------
Print_Character:

  ld A, (HL)      ; store the character into A
  sub CHAR_SPACE  ; subtract the first character (space)
  ld H, 0         ; copy A to HL ...
  ld L, A
  add HL, HL      ; ... and multiply it with 8
  add HL, HL
  add HL, HL
  ld D, H         ; copy HL to DE
  ld E, L

print_character_memory_patch_start:  ; if I decide to hack it later
  ld HL, (current_font_base)  ; load the address of the font definition ...
                              ; ... stored at memory location called ...
                              ; "current_fotn_base"
print_character_memory_patch_end:
  add HL, DE  ; point to the memory where the character is defined
  push HL     ; store this memory address on stack (will pop as DE later)

  ; Calculate screen address from row and column
  ld A, B                 ; get row number (0-23)
  add A, A                ; multiply by 2 (each offset is 2 bytes)
  ld E, A
  ld D, 0
  ld HL, screen_row_offset
  add HL, DE              ; HL points to the offset for this row

  ; Load offset into DE, so that you can add it to HL
  ld E, (HL)              ; get low byte of offset
  inc HL
  ld D, (HL)              ; get high byte of offset
  ; Now DE = row offset

  ld HL, MEM_SCREEN_PIXELS
  add HL, DE              ; HL = screen start + row offset

  ; Now add column offset
  ld A, C
  ld E, A
  ld D, 0
  add HL, DE  ; HL now points to correct screen position

  ld B, 8  ; characters are eight lines high
  pop DE   ; this was pushed as HL with memory font start

.loop_character_bytes:
    ld A, (DE)
    ld(HL), A
    inc H       ; increase position at the screen (HL = HL + 256)
    inc DE      ; increase position in the memory
  djnz .loop_character_bytes

  ret

