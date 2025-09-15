;===============================================================================
; Color_Line
;-------------------------------------------------------------------------------
; Purpose:
; - Colors a line of cells defined by upper left corner and the length
;
; Parameters (passed via registers)
; - A:  color
; - BC: starting row (B) and column (C) - upper left corner
; - E:  length of the color strip (in columns)
;
; Clobbers:
; - AF, BC, DE, HL ... but should be double checked
;
; Note:
; - To see why this works, scroll down!
;-------------------------------------------------------------------------------
Color_Line

  push DE  ; store the length (E)

  ;--------------------------------------
  ; Calculate screen attributes' address
  ;--------------------------------------
  ex AF, AF'  ; use the shadow registers for calculations

  ; Set proper row
  ld H, 0
  ld L, B   ; HL now holds the row number
  sla L
  sla L
  sla L
  sla L
  sla L

  ld A, B
  and %00011000
  rrca
  rrca
  rrca
  ld   H, $58
  or   H
  ld   H, A

  ; Set the proper column
  ld D, 0
  ld E, C
  add HL, DE

  pop DE  ; restore the column

  ex AF, AF'  ; get the value of the color back

.loop
    ld (HL), A
    dec E
    inc HL
  jr nz, .loop

  ret

;-------------------------------------------------------------------------------
; Note:
; - The algorithm here works because:
;
; - Attributes start at:
;
;   16384 + 192 * 256 / 8 = 22528
;   22528 = $5800 = % 01011000 00000000
;
;   (Note that lower eight bits (lower byte) is zero
;
; - Attribute rows go from 0 - 23 (24 lines),
;   or if we analyze them third by third
;
;   line   binary       attribute offset
;
;    0  |  00000000  |  00000000
;    1  |  00000001  |  00100000  ( 32)
;    2  |  00000010  |  01000000  ( 64)
;    3  |  00000011  |  01100000  ( 92)
;    4  |  00000100  |  10000000  (128)
;    5  |  00000101  |  10100000  (160)
;    6  |  00000110  |  11000000  (192)
;    7  |  00000111  |  11100000  (224)
;
;   (Note that these can be directly rotated to the left and then
;    safely OR-ed with 22528, no collision here)
;
;   line   binary       attribute offset
;
;    8  |  00001000  |  01 00000000  (256)
;    9  |  00001001  |  01 00100000  (288)
;   10  |  00001010  |  01 01000000  (320)
;   11  |  00001011  |  01 01100000  (352)
;   12  |  00001100  |  01 10000000  (384)
;   13  |  00001101  |  01 10100000  (416)
;   14  |  00001110  |  01 11000000  (448)
;   15  |  00001111  |  01 11100000  (480)
;              ^         ^
;   (Here too, lower three bits can be rotated to the left, but you also
;    have one additional bit (position 3) which tells we are in the 2nd third
;
;   line   binary       attribute offset
;
;   16  |  00010000  |  10 00000000  (256)
;   17  |  00010001  |  10 00100000  (288)
;   18  |  00010010  |  10 01000000  (320)
;   19  |  00010011  |  10 01100000  (352)
;   20  |  00010100  |  10 10000000  (384)
;   21  |  00010101  |  10 10100000  (416)
;   22  |  00010110  |  10 11000000  (448)
;   23  |  00010111  |  10 11100000  (480)
;             ^         ^
;   (Here too, lower three bits can be rotated to the left, but you also
;    have one additional bit (position 4) which tells we are in the 3nd third
;
; - So, in order to compute the address of attributes, we can rotate the row
;   number to the right for the lower byte and do the trick with and %00011000
;   for the higher byte and ... things work
;
; - It would be great if I could also write such a lengthy explanation for the
;   screen pixel addresses
;-------------------------------------------------------------------------------
