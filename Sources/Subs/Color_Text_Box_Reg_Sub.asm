;===============================================================================
; Color_Text_Box_Reg_Sub
;-------------------------------------------------------------------------------
; Purpose:
; - Colors a box of text with specified length and height
;
; Parameters (passed via memory locations):
; - A:  color
; - BC: text box row and column
; - DE: text box length and height
;
; Clobbers:
; - AF
; - BC
; - DE
;-------------------------------------------------------------------------------
Color_Text_Box_Reg_Sub:

  push DE  ; length (D) and height (E)
  push AF  ; color (A)
  push BC  ; row (B) and column (C)

  ;------------------------------------------------------------------------
  ; Set initial value of HL to point to the beginning of screen attributes
  ;------------------------------------------------------------------------
  ld HL, MEM_SCREEN_COLORS  ; load HL with the address of screen color

  ;------------------------------------------------------------------
  ; Increase HL text_column times, to shift it to the desired column
  ;------------------------------------------------------------------
  ld A, C
  cp 0                                        ; is A equal to zero?
  jr z, Color_Text_Box_Reg_Skip_Zero_Columns  ; if so, skip this loop
  ld B, C                                     ; use B as the counter
Color_Text_Box_Reg_Loop_Columns:
  inc HL                                ; increase HL text_row times
  djnz Color_Text_Box_Reg_Loop_Columns  ; decrease B and jump if nonzero
Color_Text_Box_Reg_Skip_Zero_Columns:   ; get here if column count is zero
  pop BC                                ; retreive (refresh) row and column

  ;-----------------------------------------------------------------
  ; Increase HL text_row * 32 times, to shift it to the desired row
  ;-----------------------------------------------------------------
  ld DE, 32                                ; 32 columns, this is not a space!!!
  ld A, B                                  ; fetch the row
  cp 0                                     ; is A equal to zero?
  jr z, Color_Text_Box_Reg_Skip_Zero_Rows  ; if so, skip this loop
Color_Text_Box_Reg_Loop_Rows:
  add HL, DE                         ; increase HL by 32
  djnz Color_Text_Box_Reg_Loop_Rows  ; decrease B and repeat the loop if nonzero
Color_Text_Box_Reg_Skip_Zero_Rows:   ; get here if row count is zero

  ;---------------------------------------------------------------
  ; Now the HL holds the correct position of the screen attribute
  ; perfrom a double loop throug rows and columns to color a box
  ;---------------------------------------------------------------
  pop AF               ; retreive the color
  ld C, A              ; store the color in C
  pop DE               ; retreive lenght (D) and height (E) again
  ld A, E              ; A stores height, will be the outer loop

Color_Text_Box_Reg_Loop_Height:  ; loop over A, outer loop

  push DE  ; store DE which holds length (D) and height
  push HL  ; store HL at the first row position

  ld B, D    ; B stores the lengt, will be inner loop
  ld DE, 32  ; number of columns now, to be added to HL
Color_Text_Box_Reg_Loop_Length:  ; loop over B, inner loop
  ld (HL), C                     ; set color at position pointed by HL registers
  inc HL                         ; go to the next horizontal position
  djnz Color_Text_Box_Reg_Loop_Length

  pop HL      ; retreive the first positin in the row
  add HL, DE  ; add the number of columns -> go to the next row
  pop DE      ; retreive length (D) and height (E)

  dec A                                  ; decrease A, outer loop counter
  jr nz, Color_Text_Box_Reg_Loop_Height  ; repeat if A is nonzero

  ret

