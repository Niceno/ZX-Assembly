;===============================================================================
; Clear_Shadow
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
Clear_Shadow:

  ;------------------
  ; Clear the pixels
  ;------------------
  ld HL, MEM_SHADOW_PIXELS                          ; pixels' memory
  ld DE, MEM_SHADOW_PIXELS + 1                      ; pixels' memory + 1
  ld BC, MEM_SHADOW_COLORS - MEM_SHADOW_PIXELS - 1  ; amount of pixel data
  ld (HL), $00                                      ; set first byte to 0
  ldir                                              ; copy the other BC bytes

  ;-----------------------------
  ; Set the colors (attributes)
  ;-----------------------------
  ld HL, MEM_SHADOW_COLORS          ; pixels' memory
  ld DE, MEM_SHADOW_COLORS + 1      ; pixels' memory + 1
  ld BC, CELL_ROWS * CELL_COLS - 1  ; amount of color data
  ld (HL), A                        ; set first color to whatever is in A
  ldir                              ; copy the remaining BC bytes

  ret
