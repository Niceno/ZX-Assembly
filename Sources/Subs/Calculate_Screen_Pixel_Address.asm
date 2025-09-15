;===============================================================================
; Calculate_Screen_Pixel_Address
;-------------------------------------------------------------------------------
; Purpose:
; - Based on the row and column cell coordinates, passed via BC, calculate the
;   corresponding screen pixel address and store it in HL pair.
;
; Parameters
; - BC: row and column
;
; Output
; - HL: screen pixel address
;
; Clobbers:
; - AF, BC
;
; Note:
; - To see why this works, scroll down!
;-------------------------------------------------------------------------------
Calculate_Screen_Pixel_Address

  ld A, B        ; B holds the row
  and %00000111  ; keep only three lower bits ...
  sla A          ; ... and multiply with 32 ...
  sla A          ; ... since there are 32 ...
  sla A          ; ... columns on Speccy's ...
  sla A          ; ... screen.
  sla A          ; five additions is multiplying with 32
  ld L, A        ; store the result in lower part of the HL pair

  ; Now take care of the Speccy's screen sectioning in thirds, 2nd section
  ; starts at the offset of 2048, third section at the offset of 4096
  ld   A, B       ; load row into A
  and  %00011000  ; Delete bits 0..2 and keep 3..4.  Thus if row is bigger than
                  ; 7, A will hold bit 3 which is 2048 when in H.  If the row
                  ; is bigger than 15, A will hold bit 4, which is 4096 in H
                  ; Since there are only 24 rows (from 0 to 23), row number
                  ; will never hold both bits 3 and 4 (16+8=24)
  or   $40        ; add 16384 (MEM_SCREEN_PIXELS = $4000) to HL
  ld   H, A

  ; Add column
  ld  B,  0
  add HL, BC  ; HL = (row, col) byte  add HL, BC

  ret

;-------------------------------------------------------------------------------
; Note:
; - The algorithm here works because:
;
; - Screen pixels start at:
;
;   16384 = $4000 = % 01000000 00000000
;   (Note that lower eight bits (lower byte) is zero)
;
; - Cell (character if you will) rows go from 0 - 23 (24 lines), and they are
;   are arranged in thirds.  They start at:
;     > 1st third: 16384 (= $4000 = % 01000000 00000000)
;     > 2nd third: 18432 (= $4800 = % 01001000 00000000)
;     > 3rd third: 20480 (= $5000 = % 01010000 00000000)
;
; - Rows of cells start at offsets:
;
;   row    binary       screen pixel offset
;
;    0  |  00000000  |  00000000 00000000
;    1  |  00000001  |  00000000 00100000  ( 32)
;    2  |  00000010  |  00000000 01000000  ( 64)
;    3  |  00000011  |  00000000 01100000  ( 92)
;    4  |  00000100  |  00000000 10000000  (128)
;    5  |  00000101  |  00000000 10100000  (160)
;    6  |  00000110  |  00000000 11000000  (192)
;    7  |  00000111  |  00000000 11100000  (224)
;
;   (Note that these can be directly rotated to the left and then
;    safely OR-ed with 16384, no collision here)
;
;   row    binary       screen pixel offset
;
;    8  |  00001000  |  00001000 00000000  (2048)
;    9  |  00001001  |  00001000 00100000  (2080)
;   10  |  00001010  |  00001000 01000000  (2112)
;   11  |  00001011  |  00001000 01100000  (2144)
;   12  |  00001100  |  00001000 10000000  (2176)
;   13  |  00001101  |  00001000 10100000  (2208)
;   14  |  00001110  |  00001000 11000000  (2240)
;   15  |  00001111  |  00001000 11100000  (2272)
;              ^            ^
;   (Here, lower three bits of the row number can be simlply coppied
;    to the upper byte and have one additional position set (position s
;    which tells we are in the 2nd third.)
;
;   line   binary       screen pixel offset
;
;   16  |  00010000  |  00010000 00000000  (4096)
;   17  |  00010001  |  00010000 00100000  (4128)
;   18  |  00010010  |  00010000 01000000  (4160)
;   19  |  00010011  |  00010000 01100000  (4192)
;   20  |  00010100  |  00010000 10000000  (4224)
;   21  |  00010101  |  00010000 10100000  (4256)
;   22  |  00010110  |  00010000 11000000  (4288)
;   23  |  00010111  |  00010000 11100000  (4320)
;             ^            ^
;   (Here too, lower three bits can be rotated to the left, but you also
;    have one additional bit (position 4) which tells we are in the 3rd third
;
; - So, in order to compute the address of attributes, we can rotate the row
;   number to the right for the lower byte and do the trick with and %00011000
;   for the higher byte and ... things work
;-------------------------------------------------------------------------------
