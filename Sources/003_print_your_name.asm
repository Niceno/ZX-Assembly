;-------------------------------------------------------------------------------
; ZX Spectrum ROM Routines
; (https://skoolkid.github.io/rom/dec/maps/routines.html
;-------------------------------------------------------------------------------
ROM_CHAN_OPEN  equ  5633  ; channel (1 or 2) in A
ROM_PR_STRING  equ  8252  ; address in DE, length in BC

;-------------------------------------------------------------------------------
; ZX Spectrum 48 K Memory Map:
;
; $0000 – $3FFF  ( 16 KB)  ROM
; $4000 – $57FF  (  6 KB)  Screen bitmap (pixels, 256*192)
; $5800 – $5AFF  (768  B)  Screen attributes (color, 32x24)
; $5B00 – $5BFF  (256  B)  Printer buffer
; $5C00 – $5CBF  (192  B)  System variables
; $5CC0 – $5CCA  ( 11  B)  Reserved
; $5CCB – $FF57  (~39 KB)  Available RAM (between PROG and RAMTOP)
; $FF58 – $FFFF  (168  B)  Reserved
;-------------------------------------------------------------------------------
MEM_ROM_START       equ  $0000
MEM_SCREEN_PIXELS   equ  $4000
MEM_SCREEN_ATTRIBS  equ  $5800
MEM_PRINTER_BUFFER  equ  $5B00
MEM_SYS_VARS        equ  $5C00
MEM_AVAILABLE_RAM   equ  $5CCB
MEM_PROGRAM_START   equ  $8000

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

;-------------------------
; Initialize loop counter
;-------------------------
  ld a, (loopcount)  ; you can't do: ld b, (address)
  ld b, a

Loop:
  push bc
  ld de, bojanstring                 ; address of string
  ld bc, bojanstringend-bojanstring  ; length of string to print
  call ROM_PR_STRING                 ; print the string
  pop bc
  djnz Loop                         ; decrease B and jump if non zero

  ret

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   DATA
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

;--------------
; Loop counter
;--------------
loopcount:
  defb 10

;-----------------
; String to print
;-----------------
bojanstring:
  defb "Bojan is cool!"
  defb 13                ; new line
bojanstringend equ $

;-------------------------------------------------------------------------------
; Save a snapshot that starts execution at the address marked with Main
;-------------------------------------------------------------------------------
  savesna "bojan.sna", Main
