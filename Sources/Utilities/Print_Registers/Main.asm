;===============================================================================
; Print_Registers_Main
;-------------------------------------------------------------------------------
; Purpose:
; - Prints the contents of the registers
;
; Parameters (passed via registers)
; - none
;
; Clobbers:
; - nothing, should examine registers, not alter them
;
; Note:
; - This source includes three other routines which are only called from here
;   I am not sure this is the best practice, but ... seems OK at the moment.
;-------------------------------------------------------------------------------
Print_Registers_Main:

  ;--------------------------
  ;
  ; Save the registers first
  ;
  ;--------------------------
  PUSH_ALL_REGISTERS

  ;----------------------------
  ;
  ;  Increase the loop counter
  ;  & print the proper header
  ;
  ;----------------------------
  PUSH_ALL_REGISTERS  ; this is an overkill here, but I do it for kicks

  ;---------------------
  ; Increase call count
  ;---------------------
  ld A, (call_count)
  inc A               ; at this point, A is 1 or 2
  ld (call_count), A

  ;-----------------------------
  ; Print line for the 1st call
  ;-----------------------------
  ld B, 0 : ld C, 24
  ld HL, text_1st_call
  call Print_Hor_String
  ld A, BLUE_PAPER + WHITE_INK
  ld B, 0 : ld C, 24 : ld E, 6
  call Color_Hor_Line

  ; Is this the first call?
  ld A, (call_count)
  cp 1  ; checks A - 1
  jr z, .first_call

  ;-----------------------------
  ; Print line for the 2nd call
  ;-----------------------------
  ld B, 0 : ld C, 24
  call Increase_Row_For_2nd_Call  ; add 10 to B for the 2nd call
  ld HL, text_2nd_call
  call Print_Hor_String
  ld A, BLUE_PAPER + WHITE_INK
  ld B, 0 : ld C, 24 : ld E, 6
  call Increase_Row_For_2nd_Call  ; add 10 to B for the 2nd call
  call Color_Hor_Line

.first_call

  POP_ALL_REGISTERS  ; this is an overkill here, but I do it for kicks

  ;------------------------------------------
  ; Save registers in the "new" memory slots
  ;------------------------------------------
  ; (Bear in mind that the system is little endian,
  ;  so L will be saved first in memory, H second.)
  ld (new_ix), IX  ; save IX first, you will use it to save others
  push IY : pop IX : ld (new_iy), IX  ; save IY through IX

  push AF : pop IX : ld (new_af), IX  ; save AF through IX
  push BC : pop IX : ld (new_bc), IX  ; save BC through IX
  push DE : pop IX : ld (new_de), IX  ; save DE through IX
  push HL : pop IX : ld (new_hl), IX  ; save HL through IX

  ex AF, AF'
  exx
  push AF : pop IX : ld (new_af_p), IX  ; save AF' through IX
  push BC : pop IX : ld (new_bc_p), IX  ; save BC' through IX
  push DE : pop IX : ld (new_de_p), IX  ; save DE' through IX
  push HL : pop IX : ld (new_hl_p), IX  ; save HL' through IX
  ex AF, AF'
  exx

  ;------------------------------
  ;
  ; Browse through all registers
  ;
  ;------------------------------
  ld IX, reg_record
  ld B, REG_ENTRIES

.loop:
    push bc

    ;------------------
    ; Text coordinates
    ;------------------
    ld B, (IX+0)  ; B holds row
    ld C, (IX+1)  ; C holds column
    call Increase_Row_For_2nd_Call  ; add 10 to B for the 2nd call

    ;---------------------------------------
    ; Register labels ("AF", "BC", ... "IY"
    ;---------------------------------------
    ld L, (IX+2)  ; notice little endian: lower byte first ...
    ld H, (IX+3)  ; ... higher byte second
    call Print_Udgs_Character

    ;------------------------------------------------------------------------
    ; Text coordinates again (they got clobbered in Print_Udgs_Character
    ;------------------------------------------------------------------------
    ld B, (IX+0)  ; B holds row
    ld C, (IX+1)  ; C holds column
    inc C         ; increase column for the equal sign
    call Increase_Row_For_2nd_Call  ; add 10 to B for the 2nd call

    ;-----------------
    ; Register labels
    ;-----------------
    ld L, (IX+4)  ; notice little endian: lower byte first ...
    ld H, (IX+5)  ; ... higher byte second
    call Print_Udgs_Character

    ;-------------------------------------------------------------
    ; Print hex number from new_ptr (which is always the current)
    ;-------------------------------------------------------------
    ld   B, (IX+0)  ; B holds row
    ld   C, (IX+1)  ; C holds column
    call Increase_Row_For_2nd_Call  ; add 10 to B for the 2nd call
    ld   L, (IX+6)  ; little ...
    ld   H, (IX+7)  ; ... endian
    inc  HL
    ld   A, (HL)
    inc  C
    inc  C
    call Print_Hex_Byte
    dec  HL
    ld   A, (HL)
    inc  C
    call Print_Hex_Byte

    ;---------------------------------
    ; Colour (maybe flash) vs old_ptr
    ;---------------------------------
    ld B, (IX +0)  ; B holds row
    ld C, (IX +1)  ; C holds column
    call Increase_Row_For_2nd_Call  ; add 10 to B for the 2nd call
    ld E, (IX+ 8)
    ld D, (IX+ 9)  ; old_ptr
    ld A, (IX+10)  ; color
    call Compare_Registers

    ld E, 4
    call Color_Hor_Line

    ld DE, REG_ROW_SIZE
    add IX, DE

    pop BC

  djnz .loop

  ;----------------------------------
  ; On first call, copy the register
  ; contents to separate memory area
  ;----------------------------------
  push AF
  ld A, (call_count)

  cp 1     ; if A is 1, the first call, jump to .this_is_the_first_call
  jr z, .this_is_the_first_call
  jr .not_the_first_call   ; if A is not 1, go to the .not_the_first_call

.this_is_the_first_call:
  ld HL, new_register_values
  ld DE, old_register_values
  ld BC, REG_VALUES
  ldir

.not_the_first_call:
  pop AF

  ;----------------------------
  ;
  ; Restore the registers last
  ;
  ;----------------------------
  POP_ALL_REGISTERS

  ret

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   LOCAL SUBROUTINES
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  include "Increase_Row_For_2nd_Call.asm"
  include "Compare_Registers.asm"

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   SHARED SUBROUTINES
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  include "Shared/Color_Hor_Line.asm"
  include "Shared/Print_Hor_String.asm"
  include "Shared/Udgs/Print_Character.asm"
  include "Shared/Udgs/Merge_Character.asm"
  include "Shared/Print_Hex_Byte.asm"

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   GLOBAL DATA
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  include "Include/Global_Data.inc"

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   LOCAL DATA
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
call_count:  defb  $0

text_1st_call:  defb  "CALL 1", 0
text_2nd_call:  defb  "CALL 2", 0

; Saved on the current call, be it first or second
new_register_values:
new_af:    defw  $0000
new_bc:    defw  $0000
new_de:    defw  $0000
new_hl:    defw  $0000
new_af_p:  defw  $0000
new_bc_p:  defw  $0000
new_de_p:  defw  $0000
new_hl_p:  defw  $0000
new_ix:    defw  $0000
new_iy:    defw  $0000

; Saved on the first call, become old at the second call
old_register_values:
old_af:    defw  $0000
old_bc:    defw  $0000
old_de:    defw  $0000
old_hl:    defw  $0000
old_af_p:  defw  $0000
old_bc_p:  defw  $0000
old_de_p:  defw  $0000
old_hl_p:  defw  $0000
old_ix:    defw  $0000
old_iy:    defw  $0000

REG_VALUES  equ  20

;    row,col,    str_ptr,  reg(')=,   new_ptr,   old_ptr,    color
;    0   1       2-3       4-5        6-7        8-9         10
reg_record:
  db 2,  22 : dw reg_af,   reg_eq,    new_af,    old_af   : db BLACK_INK + YELLOW_PAPER
  db 3,  22 : dw reg_bc,   reg_eq,    new_bc,    old_bc   : db BLACK_INK + GREEN_PAPER
  db 4,  22 : dw reg_de,   reg_eq,    new_de,    old_de   : db BLACK_INK + GREEN_PAPER
  db 5,  22 : dw reg_hl,   reg_eq,    new_hl,    old_hl   : db BLACK_INK + GREEN_PAPER   + BRIGHT
  db 2,  28 : dw reg_af,   reg_p_eq,  new_af_p,  old_af_p : db BLACK_INK + YELLOW_PAPER
  db 3,  28 : dw reg_bc,   reg_p_eq,  new_bc_p,  old_bc_p : db BLACK_INK + GREEN_PAPER
  db 4,  28 : dw reg_de,   reg_p_eq,  new_de_p,  old_de_p : db BLACK_INK + GREEN_PAPER
  db 5,  28 : dw reg_hl,   reg_p_eq,  new_hl_p,  old_hl_p : db BLACK_INK + GREEN_PAPER   + BRIGHT
  db 6,  25 : dw reg_ix,   reg_eq,    new_ix,    old_ix   : db BLACK_INK + CYAN_PAPER
  db 7,  25 : dw reg_iy,   reg_eq,    new_iy,    old_iy   : db BLACK_INK + CYAN_PAPER

REG_ROW_SIZE  equ  11
REG_ENTRIES   equ  10  ; (AX, BC, DE, HL) x 2 + IX and IY = 10

; Registers are accesses as classical UDGs
reg_af:     defb $00, $27, $54, $56, $74, $54, $54, $00 ;
reg_bc:     defb $00, $63, $54, $64, $54, $54, $63, $00 ;
reg_de:     defb $00, $67, $54, $56, $54, $54, $67, $00 ;
reg_hl:     defb $00, $54, $54, $74, $54, $54, $57, $00 ;
reg_ix:     defb $00, $2A, $2A, $24, $24, $2A, $2A, $00 ;
reg_iy:     defb $00, $2A, $2A, $2A, $24, $24, $24, $00 ;
reg_eq:     defb $00, $00, $00, $1E, $00, $1E, $00, $00 ;
reg_p_eq:   defb $00, $40, $40, $1E, $00, $1E, $00, $00 ;

