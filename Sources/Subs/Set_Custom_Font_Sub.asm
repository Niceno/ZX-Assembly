;===============================================================================
; Set_Custom_Font_Sub
;-------------------------------------------------------------------------------
; Purpose:
; - Sets the custom font in assembled programs
;
; Parameters:
; - none
;
; Clobbers:
; - A
; - HL
;
; Notes:
; - Can work only when fonts are at memory addresses aligned to 256 bytes.
; - Was tested only for MEM_CUSTOM_FONT_START == 64000.
;-------------------------------------------------------------------------------
Set_Custom_Font_Sub:

  ld HL, MEM_CUSTOM_FONT_START  ; this is where custom font starts
  ld A, H                       ; divide it by 256 ...
  dec A                         ; ... and the subtract 1 ...
  ld (MEM_CHARS), A             ; ... to get the value needed at MEM_CHARS

  ret
