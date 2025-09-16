;===============================================================================
; Viewport_Scroll_Pixels_Up
;-------------------------------------------------------------------------------
; Purpose:
; - Scrolls the attributes inside the viewport up
;
; Parameters:
; - viewport_pixel_addresses
;
; Clobbers:
; - AF, BC, DE, HL, IX
;-------------------------------------------------------------------------------
Viewport_Scroll_Pixels_Up

  ld IX, viewport_pixel_metadata

  ld C, (IX+2)  ; let the pair BC hold the number of bytes to transfer
  ld B, 0       ; high byte is zero
  ; At this point, the BC pair holds number of columns (to be coppied)

  ; A will serve as the loop counter
  ld A, (IX+0)  ; number of rows inside the viewport
  dec A         ; copy one less than the dimension

  ld IX, viewport_pixel_addresses

.loop_rows
    ld E, (IX+0)  ; first row (target) goes into DE
    ld D, (IX+1)
    ld L, (IX+2)  ; second row (source) goes into HL
    ld H, (IX+3)

    ; Perform the copy
    ex AF, AF'
    ld A, 8
.loop_pixels
      push BC       ; store the number of columns
      push DE       ; store target
      push HL       ; store source
      ldir          ; copy BC bytes from (HL) to (DE)
      pop HL        ; restore source
      pop DE        ; restore target
      pop BC        ; restore the number of columns
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
