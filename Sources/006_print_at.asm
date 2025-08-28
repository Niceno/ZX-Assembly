  include "spectrum48.inc"

;-------------------------------------------------------------------------------
; Set the architecture you'll be using
;-------------------------------------------------------------------------------
  device zxspectrum48

;-------------------------------------------------------------------------------
; Memory address at which the program will load
;-------------------------------------------------------------------------------
  org MEM_PROGRAM_START

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   CODE
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

;-------------------------------------------------------------------------------
; Mark the address where the program will start the execution
;-------------------------------------------------------------------------------
Main:

  ld a, 2             ; upper screen
  call ROM_CHAN_OPEN  ; open channel

  ;-----------------------------------------------
  ; Set coordinates to 5, 5 and print an asterisk
  ;-----------------------------------------------
  ld a, 5         ; row
  ld (xcoord), a  ; set initial x coordinate.
  ld a, 5         ; column
  ld (ycoord), a  ; set initial y coordinate.
  call SetCoords  ; set up our x/y coords.

  ld a, '*'          ; print an asterisk
  rst ROM_PRINT_A_1  ; display it

  ;--------------------------------------------
  ; Set coordinates to 9, 9 and print a string
  ;--------------------------------------------
  ld a, 9         ; row
  ld (xcoord), a  ; set initial x coordinate.
  ld a, 9         ; column
  ld (ycoord), a  ; set initial x coordinate.
  call SetCoords  ; set up our x/y coords.

  ld de, bojanstring                 ; address of string
  ld bc, bojanstringend-bojanstring  ; length of string to print
  call ROM_PR_STRING                 ; print the string

  ;----------------------------------------------
  ; Set coordinates to 13, 13 and print a string
  ;----------------------------------------------
  ld a, 13        ; row
  ld (xcoord), a  ; set initial x coordinate.
  ld a, 13        ; column
  ld (ycoord), a  ; set initial x coordinate.
  call SetCoords  ; set up our x/y coords.

  ; Check if it has 5 digits
  ld  hl, (number)        ; store number in HL
  ld  de, 10000           ; store dividend in DE
  or a                    ; clear the c flag
  sbc hl, de              ; HL = HL - DE
  jr nc, NoMorePadding    ; HL > 10000
  ld a, '_'               ; print an underscore
  rst ROM_PRINT_A_1       ; display it

  ; Check if it has 4 digits
  ld  hl, (number)        ; store number in HL
  ld  de, 1000            ; store dividend in DE
  or a                    ; clear the c flag
  sbc hl, de              ; HL = HL - DE
  jr nc, NoMorePadding    ; HL > 1000
  ld a, '_'               ; print an underscore
  rst ROM_PRINT_A_1       ; display it

  ; Check if it has 3 digits
  ld  hl, (number)        ; store number in HL
  ld  de, 100             ; store dividend in DE
  or a                    ; clear the c flag
  sbc hl, de              ; HL = HL - DE
  jr nc, NoMorePadding    ; HL > 1000
  ld a, '_'               ; print an underscore
  rst ROM_PRINT_A_1       ; display it

  ; Check if it has 2 digits
  ld  hl, (number)        ; store number in HL
  ld  de, 10              ; store dividend in DE
  or a                    ; clear the c flag
  sbc hl, de              ; HL = HL - DE
  jr nc, NoMorePadding    ; HL > 1000
  ld a, '_'               ; print an underscore
  rst ROM_PRINT_A_1       ; display it

NoMorePadding:
  ld bc, (number)
  call ROM_STACK_BC  ; transform the number in BC register to floating point
  call ROM_PRINT_FP  ; print the floating point number in the calculator stack

  ret            ; end of the main program

;-------------------------------------------------------------------------------
; Set coordinates subroutine
;-------------------------------------------------------------------------------
SetCoords:
 ld a, 22            ; ASCII control code for AT.
 rst ROM_PRINT_A_1   ; print it.
 ld a, (xcoord)      ; vertical position.
 rst ROM_PRINT_A_1   ; print it.
 ld a, (ycoord)      ; y coordinate.
 rst ROM_PRINT_A_1   ; print it.
 ret

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   DATA
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
xcoord:
  defb 0                 ; defb = define byte

ycoord:
  defb 15                ; defb = define byte

bojanstring:
  defb "Bojan is cool!"  ; defb = define byte
bojanstringend equ $

number:
  defw 10000             ; defw = define word  <---=

;-------------------------------------------------------------------------------
; Save a snapshot that starts execution at the address marked with Main
;-------------------------------------------------------------------------------
  savesna "bojan.sna", Main
