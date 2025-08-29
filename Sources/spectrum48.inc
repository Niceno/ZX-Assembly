;-------------------------------------------------------------------------------
; ZX Spectrum ROM Routines
;
; (https://skoolkid.github.io/rom/dec/maps/routines.html
;-------------------------------------------------------------------------------
ROM_PRINT_A_1     equ     16  ; print a character in A
ROM_CLEAR_SCREEN  equ   3503  ; clear screen
ROM_CHAN_OPEN     equ   5633  ; channel (1 or 2) in A
ROM_PR_STRING     equ   8252  ; address in DE, length in BC
ROM_STACK_BC      equ  11563  ; store the floating-point form for the absolute
                              ; binary value currently held in the BC registers
                              ; in the calculator stack
ROM_PRINT_FP      equ  11747  ; print the number on the calculator stack

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
MEM_ROM_START              equ  $0000
MEM_SCREEN_PIXELS          equ  $4000
MEM_SCREEN_COLORS          equ  $5800
MEM_PRINTER_BUFFER         equ  $5B00
MEM_SYSTEM_VARS            equ  $5C00
MEM_USER_DEFINED_GRAPHICS  equ  $5C7B  ; holds the address where UDG starts
MEM_STORE_SCREEN_COLOR     equ  $5C8D  ; holds the screen color
MEM_AVAILABLE_RAM_START    equ  $5CCB
MEM_PROGRAM_START          equ  $8000

;-------------------------------------------------------------------------------
; ZX Spectrum colors
;
; To get the color you want, add codes for ink, paper color, bright and flash
;-------------------------------------------------------------------------------
BLACK_INK      equ   0
BLUE_INK       equ   1
RED_INK        equ   2
MAGENTA_INK    equ   3
GREEN_INK      equ   4
CYAN_INK       equ   5
YELLOW_INK     equ   6
WHITE_INK      equ   7
BLACK_PAPER    equ   0
BLUE_PAPER     equ   8
RED_PAPER      equ  16
MAGENTA_PAPER  equ  24
GREEN_PAPER    equ  32
CYAN_PAPER     equ  40
YELLOW_PAPER   equ  48
WHITE_PAPER    equ  56
BRIGHT         equ  64
FLASH          equ 128

;-------------------------------------------------------------------------------
; ZX Spectrum character set
;
; (https://worldofspectrum.net/ZXBasicManual/zxmanappa.html)
;-------------------------------------------------------------------------------
CHAR_ENTER             equ  13
CHAR_AT_CONTROL        equ  22
CHAR_SPACE             equ  32
CHAR_EXCLAMATION_MARK  equ  33
CHAR_AND_SYMBOL        equ  38
CHAR_ASTERISK          equ  42
CHAR_0                 equ  48
CHAR_1                 equ  49
CHAR_2                 equ  50
CHAR_3                 equ  51
CHAR_4                 equ  52
CHAR_5                 equ  53
CHAR_6                 equ  54
CHAR_7                 equ  55
CHAR_8                 equ  56
CHAR_9                 equ  57
CHAR_QUESTION_MARK     equ  63
CHAR_AT                equ  64
CHAR_A_UPP             equ  65
CHAR_B_UPP             equ  66

