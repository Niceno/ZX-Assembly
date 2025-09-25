;===============================================================================
; Viewport_Scroll_Pixels_Down
;-------------------------------------------------------------------------------
; Purpose:
; - Scrolls the pixels inside the viewport down
;
; Parameters:
; - viewport_pixel_addresses
;
; Clobbers:
; - AF, BC, DE, HL, IX
;-------------------------------------------------------------------------------
Viewport_Scroll_Pixels_Down

  ;-------------------------------------------------------------------------
  ; Fetch the number of columns from viewport_*_metadata and store it in
  ; the BC pair.  (BC pair is convenient because used in ldir command below
  ;-------------------------------------------------------------------------
  ld IX, viewport_pixel_metadata

  ld C, (IX+2)  ; let the pair BC hold the number of bytes to transfer
  ld B, 0       ; high byte is zero

  ;--------------------------------------------
  ; Use A as the loop counter through the rows
  ;--------------------------------------------
  ld A, (IX+0)  ; number of rows inside the viewport
  dec A         ; copy one less than the dimension

  ;-----------------------------
  ; Main loop for pixel copying
  ;-----------------------------

  ; This whole contraption is to make IX point to attribute addresses
  ld L, (IX+0)  ; store number of rows in HL
  ld H, (IX+1)
  dec HL        ; not to go beyond the last record
  add HL, HL    ; multiply by two, addresses are stored in two bytes
  ex DE, HL
  ld IX, viewport_pixel_addresses
  add IX, DE

.loop_rows
    ld E, (IX+0)  ; first row (target) goes into DE
    ld D, (IX+1)
    ld L, (IX-2)  ; second row (source) goes into HL
    ld H, (IX-1)

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

    dec IX
    dec IX
    dec A
  jr nz, .loop_rows

  ret
