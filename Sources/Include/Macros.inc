;===============================================================================
; PUSH_ALL_REGISTERS
;-------------------------------------------------------------------------------
; Purpose:
; - Pushes all registers (including shadows) to the stack
;
; Note:
; - Order matters a hell of a lot here, it shuold be used in conjuction with
;   POP_ALL_REGISTERS macro
;-------------------------------------------------------------------------------
  macro PUSH_ALL_REGISTERS

  push AF : push BC : push DE : push HL
  ex AF, AF' : exx
  push AF : push BC : push DE : push HL
  ex AF, AF' : exx
  push IX : push IY

  endm

;===============================================================================
; POP_ALL_REGISTERS
;-------------------------------------------------------------------------------
; Purpose:
; - Pops all registers (including shadows) from the stack
;
; Note:
; - Order matters a hell of a lot here, it shuold be used in conjuction with
;   PUSH_ALL_REGISTERS macro
;-------------------------------------------------------------------------------
  macro POP_ALL_REGISTERS

  pop IY : pop IX
  ex AF, AF' : exx
  pop HL : pop DE : pop BC : pop AF
  ex AF, AF' : exx
  pop HL : pop DE : pop BC : pop AF

  endm

;===============================================================================
; PRINT_PIXELS_IN_SHADOW
;-------------------------------------------------------------------------------
; Purpose:
; - Directs printing of pixels to shadows
;-------------------------------------------------------------------------------
  macro PRINT_PIXELS_IN_SHADOW

  ld A, high MEM_SHADOW_PIXELS
  ld (swap_screen_and_shadow_pixels_here + 1), A

  endm

;===============================================================================
; PRINT_COLORS_IN_SHADOW
;-------------------------------------------------------------------------------
; Purpose:
; - Directs printing of colors to shadows
;-------------------------------------------------------------------------------
  macro PRINT_COLORS_IN_SHADOW

  ld A, high MEM_SHADOW_COLORS
  ld (swap_screen_and_shadow_colors_here + 1), A

  endm

;===============================================================================
; PRINT_PIXELS_ON_SCREEN
;-------------------------------------------------------------------------------
; Purpose:
; - Directs printing of pixels to screens
;-------------------------------------------------------------------------------
  macro PRINT_PIXELS_ON_SCREEN

  ld A, high MEM_SCREEN_PIXELS
  ld (swap_screen_and_shadow_pixels_here + 1), A

  endm

;===============================================================================
; PRINT_COLORS_ON_SCREEN
;-------------------------------------------------------------------------------
; Purpose:
; - Directs printing of colors to screens
;-------------------------------------------------------------------------------
  macro PRINT_COLORS_ON_SCREEN

  ld A, high MEM_SCREEN_COLORS
  ld (swap_screen_and_shadow_colors_here + 1), A

  endm

