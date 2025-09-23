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


  macro POP_ALL_REGISTERS

  pop IY : pop IX
  ex AF, AF' : exx
  pop HL : pop DE : pop BC : pop AF
  ex AF, AF' : exx
  pop HL : pop DE : pop BC : pop AF

  endm

