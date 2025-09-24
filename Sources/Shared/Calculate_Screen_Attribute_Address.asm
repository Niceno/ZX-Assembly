  ifndef __CALCULATE_SCREEN_ATTRIBUTE_ADDRESS__
  define __CALCULATE_SCREEN_ATTRIBUTE_ADDRESS__

;===============================================================================
; Calculate_Screen_Attribute_Address
;-------------------------------------------------------------------------------
; Purpose:
; - Based on the row and column cell coordinates, passed via BC, calculate the
;   corresponding screen attribute address and stores it in HL pair.
;
; Parameters
; - BC: row and column
;
; Output
; - HL: screen attribute address
;
; Clobbers:
; - AF, BC, DE, HL
;
; Note:
; - To see why this works, scroll down!
;-------------------------------------------------------------------------------
Calculate_Screen_Attribute_Address

  ; Set proper row
  ld A, B
  and %00000111                     ; keep only three lower bits
  rlca : rlca : rlca : rlca : rlca  ; multiply row by 32 ...
  ld L, A                           ; ... and put it in L

  ld A, B
  and %00011000
  rrca
  rrca
  rrca
swap_screen_and_shadow_colors_here:
  add A, high MEM_SCREEN_COLORS  ; high byte of MEM_SCREEN_COLORS
  ld  H, A

  ; Set the proper column
  ld B, 0
  add HL, BC

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
;   line   binary       attribute offset    dec    hex    full
;
;    0  |  00000000  |  00000000 00000000  (  0)  $0000  $5800
;    1  |  00000001  |  00000000 00100000  ( 32)  $0020  $5820
;    2  |  00000010  |  00000000 01000000  ( 64)  $0040  $5840
;    3  |  00000011  |  00000000 01100000  ( 96)  $0060  $5860
;    4  |  00000100  |  00000000 10000000  (128)  $0080  $5880
;    5  |  00000101  |  00000000 10100000  (160)  $00A0  $58A0
;    6  |  00000110  |  00000000 11000000  (192)  $00C0  $58C0
;    7  |  00000111  |  00000000 11100000  (224)  $00E0  $58E0
;
;   (Note that these can be directly rotated to the left and then
;    added to the base high byte, no collision here)
;
;   line   binary       attribute offset    dec    hex    full
;
;    8  |  00001000  |  00000001 00000000  (256)  $0100  $5900
;    9  |  00001001  |  00000001 00100000  (288)  $0120  $5920
;   10  |  00001010  |  00000001 01000000  (320)  $0140  $5940
;   11  |  00001011  |  00000001 01100000  (352)  $0160  $5960
;   12  |  00001100  |  00000001 10000000  (384)  $0180  $5980
;   13  |  00001101  |  00000001 10100000  (416)  $01A0  $59A0
;   14  |  00001110  |  00000001 11000000  (448)  $01C0  $59C0
;   15  |  00001111  |  00000001 11100000  (480)  $01E0  $59E0
;              ^               ^
;   (Here too, lower three bits can be rotated to the left, but you also
;    have one additional bit (position 3) which tells we are in the 2nd third
;
;   line   binary       attribute offset    dec    hex    full
;
;   16  |  00010000  |  00000010 00000000  (512)  $0200  $5A00
;   17  |  00010001  |  00000010 00100000  (544)  $0220  $5A20
;   18  |  00010010  |  00000010 01000000  (576)  $0240  $5A40
;   19  |  00010011  |  00000010 01100000  (608)  $0260  $5A60
;   20  |  00010100  |  00000010 10000000  (640)  $0280  $5A80
;   21  |  00010101  |  00000010 10100000  (672)  $02A0  $5AA0
;   22  |  00010110  |  00000010 11000000  (704)  $02C0  $5AC0
;   23  |  00010111  |  00000010 11100000  (736)  $02E0  $5AE0
;             ^               ^
;   (Here too, lower three bits can be rotated to the left, but you also
;    have one additional bit (position 4) which tells we are in the 3rd third
;
; - So, in order to compute the address of attributes, we can rotate the row
;   number to the right for the lower byte and do the trick with and %00011000
;   for the higher byte and ... things work
;-------------------------------------------------------------------------------

  endif
