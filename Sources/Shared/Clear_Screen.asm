;===============================================================================
; Clear_Screen
;-------------------------------------------------------------------------------
; Purpose:
; - Clears the screen by directly settning all pixel memory to zero, and cell
;   attributes to color specified in A
;
; Parameters:
; - A: specifies the color
;
; Clobbers:
; - BC, DE, HL
;-------------------------------------------------------------------------------
Clear_Screen:

  ;------------------
  ; Clear the pixels
  ;------------------
  ld HL, MEM_SCREEN_PIXELS                          ; pixels' memory
  ld DE, MEM_SCREEN_PIXELS + 1                      ; pixels' memory + 1
  ld BC, MEM_SCREEN_COLORS - MEM_SCREEN_PIXELS - 1  ; amount of pixel data
  ld (HL), $00                                      ; set first byte to 0
  ldir                                              ; copy the other BC bytes

  ;-----------------------------
  ; Set the colors (attributes)
  ;-----------------------------
  ld HL, MEM_SCREEN_COLORS          ; pixels' memory
  ld DE, MEM_SCREEN_COLORS + 1      ; pixels' memory + 1
  ld BC, CELL_ROWS * CELL_COLS - 1  ; amount of color data
  ld (HL), A                        ; set first color to whatever is in A
  ldir                              ; copy the remaining BC bytes

  ret
