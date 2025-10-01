;===============================================================================
; Flicker_Border
;-------------------------------------------------------------------------------
; Purpose:
; - Flicker the border by browsing through all the ink colors, and setting
;   them as border one after another.
; - Restores the original border color which was stored in border_color.
;
; Parameters:
; - none
;
; Global variables used:
; - border_color
;
; Clobbers:
; - nothing
;-------------------------------------------------------------------------------
Flicker_Border:

  ei

  push AF
  push BC

  ld B, 1
.flicker
    ld A, BLACK_INK   : out ($FE), A : halt
    ld A, BLUE_INK    : out ($FE), A : halt
    ld A, RED_INK     : out ($FE), A : halt
    ld A, MAGENTA_INK : out ($FE), A : halt
    ld A, GREEN_INK   : out ($FE), A : halt
    ld A, YELLOW_INK  : out ($FE), A : halt
    ld A, WHITE_INK   : out ($FE), A : halt
  djnz .flicker

  ld A, (border_color) : out($FE), A

  pop BC
  pop AF

  di

  ret

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   DATA
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  include "Shared/Set_Border_Color.asm"

