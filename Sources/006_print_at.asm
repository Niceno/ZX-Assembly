  include "spectrum48.inc"

;--------------------------------------
; Set the architecture you'll be using
;--------------------------------------
  device zxspectrum48

;-----------------------------------------------
; Memory address at which the program will load
;-----------------------------------------------
  org MEM_PROGRAM_START

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   CODE
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

;===============================================================================
; Main subroutine begins here
;-------------------------------------------------------------------------------
Main:

  ;----------------------------------
  ; Open the channel to upper screen
  ;----------------------------------
  ld A, 2             ; upper screen is 2
  call ROM_CHAN_OPEN  ; open channel

  ;------------------------------------------------------------
  ; Set coordinates to 5, 5, length to 1 and print an asterisk
  ;------------------------------------------------------------
  ld A, 15                      ; row
  ld (text_row), A              ; store row coordinate
  ld A,  5                      ; column
  ld (text_column), A           ; store column coordinate
  ld A, 1                       ; length of the string
  ld (text_length), A           ; store text length
  ld A, RED_INK + YELLOW_PAPER  ; color of the string
  ld (text_color), A            ; store color

  call Set_Text_Coords  ; set up our row/column coords
  ld A, CHAR_ASTERISK   ; print an asterisk
  rst ROM_PRINT_A_1     ; display it

  ;---------------------
  ; Color that asterisk
  ;---------------------
  call Color_Text_Row

  ;--------------------------------------------
  ; Set coordinates to 9, 9 and print a string
  ;--------------------------------------------
  ld A, 9                                ; row
  ld (text_row), A                       ; set initial row
  ld A, 9                                ; column
  ld (text_column), A                    ; set initial column
  ld A, bojan_string_end - bojan_string  ; length of the string
  ld (text_length), A                    ; set the length of the string
  call Set_Text_Coords                   ; set up our x/y coords.

  ld DE, bojan_string                     ; address of string
  ld bc, bojan_string_end - bojan_string  ; length of string to print
  call ROM_PR_STRING                      ; print the string

  ;-------------------------
  ; Color that line of text
  ;-------------------------
  call Color_Text_Row

  ;---------------------------------------------------------
  ; Set coordinates to 13, 13 and print a five digit number
  ;---------------------------------------------------------
  ld A, 13              ; row
  ld (text_row), A      ; store row coordinate
  ld A, 13              ; column
  ld (text_column), A   ; store column coordinate
  call Set_Text_Coords  ; set up our row/column coords

  ;-----------------------------
  ; Print the five digit number
  ;-----------------------------
  call Print_Five_Digit_Number

  ;-------------------
  ; Color that number
  ;-------------------
  ld A, 5                     ; number is five digits long
  ld (text_length), A         ; store the length of the string
  ld A, RED_INK + CYAN_PAPER  ; color of the string
  ld (text_color), A          ; store the text color

  call Color_Text_Row

  ;---------------
  ; Make a column
  ;---------------
  ld A,  8
  ld (text_row), A      ; store row
  ld A, 24
  ld (text_column), A   ; store column coordinate
  ld A, WHITE_INK + RED_PAPER
  ld (text_color), A    ; store color

  call Color_Text_Column

  ;------------
  ; Make a box
  ;------------
  ld A, 10
  ld (text_row), A      ; store row
  ld A, 26
  ld (text_column), A   ; store column coordinate
  ld A, 3
  ld (text_length), A   ; store box length
  ld A, 3
  ld (text_height), A   ; store box height
  ld A, WHITE_INK + BLUE_PAPER
  ld (text_color), A    ; store color

  call Color_Text_Box

  ret  ; end of the main program

;===============================================================================
; Print_Five_Digit_Number
;-------------------------------------------------------------------------------
; Purpose:
; - Prints right-aligned, five digit number
;
; Parameters (passed via memory locations):
; - text_row
; - text_column
;-------------------------------------------------------------------------------
Print_Five_Digit_Number:

  ; Check if it has 5 digits
  ld  HL, (number)        ; store number in HL
  ld  DE, 10000           ; store dividend in DE
  or A                    ; clear the c flag
  sbc HL, DE              ; HL = HL - DE
  jr nc, NoMorePadding    ; HL > 10000
  ld A, CHAR_SPACE        ; print an underscore
  rst ROM_PRINT_A_1       ; display it

  ; Check if it has 4 digits
  ld  HL, (number)        ; store number in HL
  ld  DE, 1000            ; store dividend in DE
  or A                    ; clear the c flag
  sbc HL, DE              ; HL = HL - DE
  jr nc, NoMorePadding    ; HL > 1000
  ld A, CHAR_SPACE        ; print an underscore
  rst ROM_PRINT_A_1       ; display it

  ; Check if it has 3 digits
  ld  HL, (number)        ; store number in HL
  ld  DE, 100             ; store dividend in DE
  or A                    ; clear the c flag
  sbc HL, DE              ; HL = HL - DE
  jr nc, NoMorePadding    ; HL > 1000
  ld A, CHAR_SPACE        ; print an underscore
  rst ROM_PRINT_A_1       ; display it

  ; Check if it has 2 digits
  ld  HL, (number)        ; store number in HL
  ld  DE, 10              ; store dividend in DE
  or A                    ; clear the c flag
  sbc HL, DE              ; HL = HL - DE
  jr nc, NoMorePadding    ; HL > 1000
  ld A, CHAR_SPACE        ; print an underscore
  rst ROM_PRINT_A_1       ; display it

NoMorePadding:
  ld bc, (number)
  call ROM_STACK_BC  ; transform the number in BC register to floating point
  call ROM_PRINT_FP  ; print the floating point number in the calculator stack

  ret  ; end of subroutine

;===============================================================================
; Set_Text_Coords
;-------------------------------------------------------------------------------
; Purpose:
; - Set coordinates for printing text
;
; Parameters (passed via memory locations):
; - text_row
; - text_column
;-------------------------------------------------------------------------------
Set_Text_Coords:

 ld A, CHAR_AT_CONTROL  ; ASCII control code for AT.
 rst ROM_PRINT_A_1      ; print it.

 ld A, (text_row)       ; vertical position.
 rst ROM_PRINT_A_1      ; print it.

 ld A, (text_column)    ; y coordinate.
 rst ROM_PRINT_A_1      ; print it.

 ret  ; end of subroutine

;===============================================================================
; Color_Tex_Box
;-------------------------------------------------------------------------------
; Purpose:
; - Colors a box of text with specified length and height
;
; Parameters (passed via memory locations):
; - text_row
; - text_column
; - text_length
; - text_height
;-------------------------------------------------------------------------------
Color_Text_Box:

  ;------------------------------------------------------------------------
  ; Set initial value of HL to point to the beginning of screen attributes
  ;------------------------------------------------------------------------
  ld HL, MEM_SCREEN_COLORS  ; load HL with the address of screen color

  ;------------------------------------------------------------------
  ; Increase HL text_column times, to shift it to the desired column
  ;------------------------------------------------------------------
  ld A, (text_column)  ; prepare B as loop counter
  ld B, A              ; ld B, (text_column) wouldn't work
LoopColumns:
  inc HL               ; increase HL text_row times
  djnz LoopColumns     ; decrease B and jump if nonzero

  ;-----------------------------------------------------------------
  ; Increase HL text_row * 32 times, to shift it to the desired row
  ;-----------------------------------------------------------------
  ld A, (text_row)  ; prepare B as loop counter
  ld B, A           ; ld B, (text_column) wouldn't work
  ld DE, 32         ; there are 32 columns, this is not space character
LoopRows:
  add HL, DE        ; increase HL by 32
  djnz LoopRows     ; decrease B and repeat the loop if nonzero

  ;---------------------------------------------------------------
  ; Now the HL holds the correct position of the screen attribute
  ; perfrom a double loop throug rows and columns to color a box
  ;---------------------------------------------------------------
  ld A, (text_color)   ; prepare the color
  ld C, A              ; store the color in C
  ld A, (text_height)  ; A stores height, will be the outer loop

LoopHeight:  ; loop over A, outer loop

  ; Store HL at the first row position
  push HL

  ; Set (and re-set) B to text length, inner counter
  ; You have to preserve (push/pop) in order to keep the outer counter value
  push AF              ; A stores text height, store it before using A to fill B
  ld A, (text_length)  ; prepare B as loop counter
  ld B, A              ; B stores the lengt, will be inner loop
  pop AF               ; restore A

LoopLength:          ; loop over B, inner loop
  ld (HL), C         ; set the color at position pointed by HL registers
  inc HL             ; go to the next horizontal position
  djnz LoopLength

  pop HL             ; retreive the first positin in the row
  add HL, DE         ; go to the next row

  dec A              ; decrease A, outer loop counter
  jr nz, LoopHeight  ; repeat if A is nonzero

  ret  ; end of subroutine

;===============================================================================
; Color_Tex_Column
;-------------------------------------------------------------------------------
; Purpose:
; - Colors a column of text with specified height
;
; Parameters (passed via memory locations):
; - text_row
; - text_column
; - text_height
;-------------------------------------------------------------------------------
Color_Text_Column:

  ;------------------------------------------------------------------------
  ; Set initial value of HL to point to the beginning of screen attributes
  ;------------------------------------------------------------------------
  ld HL, MEM_SCREEN_COLORS  ; load HL with the address of screen color

  ;------------------------------------------------------------------
  ; Increase HL text_column times, to shift it to the desired column
  ;------------------------------------------------------------------
  ld A, (text_column)  ; prepare B as loop counter
  ld B, A              ; ld B, (text_column) wouldn't work
LoopColumns_2:
  inc HL               ; increase HL text_row times
  djnz LoopColumns_2   ; decrease B and jump if nonzero

  ;-----------------------------------------------------------------
  ; Increase HL text_row * 32 times, to shift it to the desired row
  ;-----------------------------------------------------------------
  ld A, (text_row)  ; prepare B as loop counter
  ld B, A           ; ld B, (text_column) wouldn't work
  ld DE, 32         ; there are 32 columns, this is not space character
LoopRows_2:
  add HL, DE        ; increase HL by 32
  djnz LoopRows_2   ; decrease B and repeat the loop if nonzero

  ;---------------------------------------------------------------
  ; Now the HL holds the correct position of the screen attribute
  ; memory loop through text_lenght to color and set the color
  ;---------------------------------------------------------------
  ld A, (text_height)  ; prepare B as loop counter
  ld B, A
  ld A, (text_color)
LoopHeight_2:
  ld (HL), A         ; set the color at position pointed by HL registers
  add HL, DE         ; go to the next position
  djnz LoopHeight_2  ; decrease B and repeat if nonzero

  ret  ; end of subroutine

;===============================================================================
; Color_Tex_Row
;-------------------------------------------------------------------------------
; Purpose:
; - Colors a row of text with specified length
;
; Parameters (passed via memory locations):
; - text_row
; - text_column
; - text_length
;-------------------------------------------------------------------------------
Color_Text_Row:

  ;------------------------------------------------------------------------
  ; Set initial value of HL to point to the beginning of screen attributes
  ;------------------------------------------------------------------------
  ld HL, MEM_SCREEN_COLORS  ; load HL with the address of screen color

  ;------------------------------------------------------------------
  ; Increase HL text_column times, to shift it to the desired column
  ;------------------------------------------------------------------
  ld A, (text_column)  ; prepare B as loop counter
  ld B, A              ; ld B, (text_column) wouldn't work
LoopColumns_3:
  inc HL               ; increase HL text_row times
  djnz LoopColumns_3   ; decrease B and jump if nonzero

  ;-----------------------------------------------------------------
  ; Increase HL text_row * 32 times, to shift it to the desired row
  ;-----------------------------------------------------------------
  ld A, (text_row)  ; prepare B as loop counter
  ld B, A           ; ld B, (text_column) wouldn't work
  ld DE, 32         ; there are 32 columns, this is not space character
LoopRows_3:
  add HL, DE        ; increase HL by 32
  djnz LoopRows_3   ; decrease B and repeat the loop if nonzero

  ;---------------------------------------------------------------
  ; Now the HL holds the correct position of the screen attribute
  ; memory loop through text_lenght to color and set the color
  ;---------------------------------------------------------------
  ld A, (text_length)  ; prepare B as loop counter
  ld B, A
  ld A, (text_color)
LoopLength_3:
  ld (HL), A         ; set the color at position pointed by HL registers
  inc HL             ; go to the next position
  djnz LoopLength_3  ; decrease B and repeat if nonzero

  ret  ; end of subroutine

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   DATA
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
text_row:
  defb 0                 ; defb = define byte

text_column:
  defb 15                ; defb = define byte

text_length:
  defb  1                ; defb = define byte

text_height:
  defb  10               ; defb = define byte

text_color:
  defb  0                ; defb = define byte

bojan_string:
  defb "Bojan is cool!"  ; defb = define byte
bojan_string_end equ $

number:
  defw  9999             ; defw = define word  <---=

;-------------------------------------------------------------------------------
; Save a snapshot that starts execution at the address marked with Main
;-------------------------------------------------------------------------------
  savesna "bojan.sna", Main
