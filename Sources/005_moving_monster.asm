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

  ld hl, udgs                         ; user defined graphics (UDGs)
  ld (MEM_USER_DEFINED_GRAPHICS), hl  ; set up UDG system variable.

  ld a, 21        ; row 21 = bottom of screen.
  ld (xcoord), a  ; set initial x coordinate.

  ; Set the color
  ld a, RED_INK + CYAN_PAPER        ; load A with desired color
  ld (MEM_STORE_SCREEN_COLOR), a    ; set the screen colors
  call ROM_CLEAR_SCREEN             ; clear the screen

Loop:
  call SetCoords     ; set up our x/y coords
  ld a, $94          ; want an asterisk here
  rst ROM_PRINT_A_1  ; display it
  call Delay         ; want a delay
  call SetCoords     ; set up our x/y coords
  ld a, 32           ; ASCII code for space
  rst ROM_PRINT_A_1  ; delete old asterisk
  ld hl, xcoord      ; vertical position
  dec (hl)           ; move it up one line
  ld a, (hl)         ; where is it now?
  cp 255             ; past top of screen yet?
  jr nz, Loop        ; no, carry on

  ret            ; end of the main program

;-------------------------------------------------------------------------------
; Delay subroutine
;-------------------------------------------------------------------------------
Delay:
  ei         ; enable interrupts, otherwise it gets stuck
             ; Speccy creates ~ 50 interruts per second, or each 0.02 seconds
  ld b, 10   ; length of delay; translates to roughly 0.2 s

Delay0:
  halt         ; wait for an interrupt.
  djnz Delay0  ; loop.

  ret        ; return.

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
  defb 0

ycoord:
  defb 15

udgs:
  ; Little ghost starts at $90 (144)
  defb %00111100
  defb %01111110
  defb %11011011
  defb %10011001
  defb %11111111
  defb %11111111
  defb %11011011
  defb %11011011

  ; Little human starts at $91 (145)
  defb %00011000
  defb %00111100
  defb %00011000
  defb %11111111
  defb %00011000
  defb %00111100
  defb %00100100
  defb %01100110

  ; Monster #1 starts at $92
  defb %10011001
  defb %10111101
  defb %01011010
  defb %01111110
  defb %01000010
  defb %00111100
  defb %11011011
  defb %10000001

  ; Monster #2 starts at $93
  defb %00100100
  defb %00111100
  defb %00111100
  defb %01011010
  defb %10111101
  defb %00111100
  defb %01100110
  defb %01000010

  ; Monster #3 starts at $94
  defb %00100100
  defb %01111110
  defb %11111111
  defb %11011011
  defb %01111110
  defb %01000010
  defb %10111101
  defb %10000001

;-------------------------------------------------------------------------------
; Save a snapshot that starts execution at the address marked with Main
;-------------------------------------------------------------------------------
  savesna "bojan.sna", Main
