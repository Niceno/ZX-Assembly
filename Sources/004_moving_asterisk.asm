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

  ld a, 21        ; row 21 = bottom of screen.
  ld (xcoord), a  ; set initial x coordinate.

Loop:
  call SetCoords     ; set up our x/y coords.
  ld a, '*'          ; want an asterisk here.
  rst ROM_PRINT_A_1  ; display it.
  call Delay         ; want a delay.
  call SetCoords     ; set up our x/y coords.
  ld a, 32           ; ASCII code for space.
  rst ROM_PRINT_A_1  ; delete old asterisk.
  ld hl, xcoord      ; vertical position.
  dec (hl)           ; move it up one line.
  ld a, (hl)         ; where is it now?
  cp 255             ; past top of screen yet?
  jr nz, Loop        ; no, carry on.

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

;-------------------------------------------------------------------------------
; Save a snapshot that starts execution at the address marked with Main
;-------------------------------------------------------------------------------
  savesna "bojan.sna", Main
