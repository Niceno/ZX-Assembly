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
  ld A, (text_column)  ; loop counter
LoopColumns:
  inc HL               ; increase HL text_row times
  dec A                ; decrease counter
  jr nz, LoopColumns   ; repeat the loop

  ;-----------------------------------------------------------------
  ; Increase HL text_row * 32 times, to shift it to the desired row
  ;-----------------------------------------------------------------
  ld A, (text_row)  ; loop counter
  ld DE, 32         ; there are 32 columns, this is not space character
LoopRows:
  add HL, DE        ; increase HL by 32
  dec A             ; decrease counter
  jr nz, LoopRows   ; repeat the loop


  ;---------------------------------------------------------------
  ; Now the HL holds the correct position of the screen attribute
  ; memory loop through text_lenght to color and set the color
  ;---------------------------------------------------------------
  ld A, (text_color)
  ld B, A
  ld A, (text_length)
LoopLength:
  ld (HL), B  ; set the color at position pointed by HL registers
  inc HL      ; go to the next position
  dec A
  jr nz, LoopLength

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
