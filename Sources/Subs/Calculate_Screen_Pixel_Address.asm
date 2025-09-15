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

