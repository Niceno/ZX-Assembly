;===============================================================================
; Viewport_Scroll_Pixels_Right
;-------------------------------------------------------------------------------
; Purpose:
; - Scrolls the pixels inside the viewport right
;
; Parameters:
; - none, it uses global variables to know which portion of the screen to scroll
;
; Global variables used:
; - viewport_pixel_metadata
; - viewport_row_pixel_addresses_left_column
;
; Clobbers:
; - AF, BC, DE, HL, IX
;-------------------------------------------------------------------------------
Viewport_Scroll_Pixels_Right

  ;-------------------------------------------------------------------------
  ; Fetch the number of columns from viewport_*_metadata and store it in
  ; the BC pair.  (BC pair is convenient because used in ldir command below
  ;-------------------------------------------------------------------------
  ld IX, viewport_pixel_metadata

  ld C, (IX+1)  ; let BC hold the number of bytes to transfer
  dec C         ; you will shift one column less
  ld B, 0       ; high byte is zero

  ;--------------------------------------------
  ; Use A as the loop counter through the rows
  ;--------------------------------------------
  ld A, (IX+0)  ; number of rows inside the viewport

  ;-----------------------------
  ; Main loop for pixel copying
  ;-----------------------------
  ld IX, viewport_row_pixel_addresses_right_column

.loop_rows
    ld E, (IX+0)  ; target address goes into DE
    ld D, (IX+1)
    ld L, (IX+0)  ; source address goes into HL
    ld H, (IX+1)
    dec HL

    ; Perform the copy
    ex AF, AF'
    ld A, 8
.loop_pixels
      push BC  ; store the number of columns
      push DE  ; store target
      push HL  ; store source
      lddr     ; copy BC bytes from (HL) to (DE)
      pop HL   ; restore source
      pop DE   ; restore target
      pop BC   ; restore the number of columns
      inc H
      inc D
      dec A
    jr nz, .loop_pixels
    ex AF, AF'

    inc IX
    inc IX
    dec A
  jr nz, .loop_rows

  ret
