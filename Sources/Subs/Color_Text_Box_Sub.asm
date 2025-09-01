;===============================================================================
; Color_Text_Box_Sub
;-------------------------------------------------------------------------------
; Purpose:
; - Colors a box of text with specified length and height
;
; Parameters (passed via memory locations):
; - text_row
; - text_column
; - text_length
; - text_height
; - text_color
;-------------------------------------------------------------------------------
Color_Text_Box_Sub:

  ;------------------------------------------------------------------------
  ; Set initial value of HL to point to the beginning of screen attributes
  ;------------------------------------------------------------------------
  ld HL, MEM_SCREEN_COLORS  ; load HL with the address of screen color

  ;------------------------------------------------------------------
  ; Increase HL text_column times, to shift it to the desired column
  ;------------------------------------------------------------------
  ld A, (text_column)  ; prepare B as loop counter
  ld B, A              ; ld B, (text_column) wouldn't work
Color_Text_Box_Loop_Columns:
  inc HL                            ; increase HL text_row times
  djnz Color_Text_Box_Loop_Columns  ; decrease B and jump if nonzero

  ;-----------------------------------------------------------------
  ; Increase HL text_row * 32 times, to shift it to the desired row
  ;-----------------------------------------------------------------
  ld A, (text_row)  ; prepare B as loop counter
  ld B, A           ; ld B, (text_column) wouldn't work
  ld DE, 32         ; there are 32 columns, this is not space character
Color_Text_Box_Loop_Rows:
  add HL, DE                     ; increase HL by 32
  djnz Color_Text_Box_Loop_Rows  ; decrease B and repeat the loop if nonzero

  ;---------------------------------------------------------------
  ; Now the HL holds the correct position of the screen attribute
  ; perfrom a double loop throug rows and columns to color a box
  ;---------------------------------------------------------------
  ld A, (text_color)   ; prepare the color
  ld C, A              ; store the color in C
  ld A, (text_height)  ; A stores height, will be the outer loop

Color_Text_Box_Loop_Height:  ; loop over A, outer loop

  ; Store HL at the first row position
  push HL

  ; Set (and re-set) B to text length, inner counter
  ; You have to preserve (push/pop) in order to keep the outer counter value
  push AF              ; A stores text height, store it before using A to fill B
  ld A, (text_length)  ; prepare B as loop counter
  ld B, A              ; B stores the lengt, will be inner loop
  pop AF               ; restore A

Color_Text_Box_Loop_Length:  ; loop over B, inner loop
  ld (HL), C                 ; set the color at position pointed by HL registers
  inc HL                     ; go to the next horizontal position
  djnz Color_Text_Box_Loop_Length

  pop HL             ; retreive the first positin in the row
  add HL, DE         ; go to the next row

  dec A                              ; decrease A, outer loop counter
  jr nz, Color_Text_Box_Loop_Height  ; repeat if A is nonzero

  ret

