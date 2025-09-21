;===============================================================================
; Print_Registers
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
Print_Registers:

  ;--------------------------
  ;
  ; Save the registers first
  ;
  ;--------------------------

  push AF
  push BC
  push DE
  push HL
  ex AF, AF'
  exx
  push AF
  push BC
  push DE
  push HL
  ex AF, AF'
  exx
  push IX
  push IY

  ;-----------------------------
  ;  Increase the loop counter
  ; and print the proper header
  ;-----------------------------
  push AF
  push BC
  push DE
  push HL

  ; Increase call count
  ld A, (call_count)
  inc A               ; at this point, A is 1 or 2
  ld (call_count), A

  ; Print line for the 1st call
  ld B, 0 : ld C, 24
  ld HL, text_1st_call
  call Print_String

  ld A, (call_count)
  cp 1  ; checks A - 1
  jr z, .first_call

  ; Print text for the second call
  ld B, 0 : ld C, 24
  call Increase_Row_For_2nd_Call  ; add 10 to B for the 2nd call
  ld HL, text_2nd_call
  call Print_String

.first_call

  pop HL
  pop DE
  pop BC
  pop AF

  

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
    ld   L, (IX+6)  ; little ...
    ld   H, (IX+7)  ; ... endian
    inc  HL
    ld   A, (HL)
    ld   E, 2
    call Print_Hex_Byte
    dec  HL
    ld   A, (HL)
    ld   E, 3
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
    call Color_Line

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
  pop IY
  pop IX
  ex AF, AF'
  exx
  pop HL
  pop DE
  pop BC
  pop AF
  ex AF, AF'
  exx
  pop HL
  pop DE
  pop BC
  pop AF

  ret

;===============================================================================
; Increase_Row_For_2nd_Call:
;-------------------------------------------------------------------------------
; Purpose:
; - Increases B by 10 for the 2nd call
;
;
;-------------------------------------------------------------------------------
Increase_Row_For_2nd_Call:

  push AF

  ld A, (call_count)
  cp 2
  jr z, .this_is_the_second_call

  pop AF

  ret

.this_is_the_second_call:
  ld A, B
  add A, 9
  ld B, A

  pop AF

  ret

;===============================================================================
; Parameters:
; - HL: address of the first memory address
; - DE: address of the second memory address
;
; Changes:
; - AF: results in increased A and (possibly) clobbered F
;
; Note:
; - This is a "local function", called only from Print_Registers,
;   that's why it is not in a separate file
;-------------------------------------------------------------------------------
Compare_Registers:

  push AF  ; beginning of the sub, store the A which holds the color
  push BC

  ;---------------------------------------------------------
  ; In case this is a second call, do the actual comparison
  ;---------------------------------------------------------
  ld A, (call_count)
  cp 2
  jr z, .this_is_the_second_call

  pop BC
  pop AF

  ret

.this_is_the_second_call:

  push AF  ; push AF for comparison

  ; Compare all bytes (why only two?)
  ld A, (DE)
  cp (HL)
  jr nz, .add_flashing
  inc HL
  inc DE
  ld A, (DE)
  cp (HL)
  jr nz, .add_flashing

  pop AF  ; comparison done, restore AF

  pop BC
  pop AF  ; restore AF from the beginning of this sub, the one with color

  ret

.add_flashing:

  pop AF  ; comparison done, restore AF

  pop BC
  pop AF  ; restore AF from the beginning of this sub, the one with color

  add FLASH

  ret

;===============================================================================
; Print_Hex_Byte
;-------------------------------------------------------------------------------
; Parameters:
; - A: byte to print as two hexadecimal digits (from $00 to $FF)
; - E: holds the horizontal offset to print the byte
;
; Clobbers:
; - nothing
;
; Note:
; - This is a "local function", called only from Print_Registers,
;   that's why it is not in a separate file
;-------------------------------------------------------------------------------
Print_Hex_Byte:

  push AF
  push DE
  push HL
  push BC

  ld D, A  ; save original byte

  ;------------------------------------------
  ; Work out the coordinates of the hex byte
  ;------------------------------------------
  ld B, (IX+0)  ; B holds row
  ld C, (IX+1)  ; C holds column
  call Increase_Row_For_2nd_Call  ; add 10 to B for the 2nd call
  ld A, E  ; load the shift
  add C    ; add shift to the column
  ld C, A  ; put the result back in C

  ;-------------------------
  ; Print high nibble first
  ;-------------------------
  ld A, D                   ; restore the original byte
  rra                       ; shift right 4 bits
  rra
  rra
  rra
  and $0F                   ; mask lower 4 bits
  ld HL, hex_0_high         ; point to the start of character table
  call Merge_Narrow_Hex_Digit

  ;--------------------------
  ; Merge low nibble over it
  ;--------------------------
  ld A, D                   ; restore original byte
  and $0F                   ; mask lower 4 bits
  ld HL, hex_0_low          ; point to the start of character table
  call Merge_Narrow_Hex_Digit

  pop BC
  pop HL
  pop DE
  pop AF

  ret

;===============================================================================
; Merge_Narrow_Hex_Digit
;-------------------------------------------------------------------------------
; Purpose:
; - Merges a "low" (right aligned) or a "high" (left aligned) digit as a
;   hexadecial number (from 0 to F)
;
; Parameters:
; - A:  digit (0-15) to print as hexadecimal
; - HL: beginning of the memory where characters are defined
;
; Clobbers:
; - nothing
;
; Note:
; - This is a "local function", called only from Print_Hex_Byte
;   that's why it is not in a separate file
;-------------------------------------------------------------------------------
Merge_Narrow_Hex_Digit:

  push HL
  push DE
  push BC
  push AF

  ; A is now the digit, multiply it with eight so that it becomes memory offset
  add A, A
  add A, A
  add A, A

  ; Calculate address of the string (string_0 to string_F)
  ld D, 0
  ld E, A                ; DE = digit value (0-15)
  add HL, DE             ; now point to the right character in the table

  ; Print the string
  call Merge_Udgs_Character

  pop AF
  pop BC
  pop DE
  pop HL

  ret

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   LOCAL DATA
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
call_count:  defb  $0

text_1st_call:  defb  "Call 1", 0
text_2nd_call:  defb  "Call 2", 0

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
  db 1,  22 : dw reg_af,   reg_eq,    new_af,    old_af   : db BLACK_INK + YELLOW_PAPER
  db 2,  22 : dw reg_bc,   reg_eq,    new_bc,    old_bc   : db BLACK_INK + GREEN_PAPER
  db 3,  22 : dw reg_de,   reg_eq,    new_de,    old_de   : db BLACK_INK + GREEN_PAPER
  db 4,  22 : dw reg_hl,   reg_eq,    new_hl,    old_hl   : db BLACK_INK + GREEN_PAPER   + BRIGHT
  db 1,  28 : dw reg_af,   reg_p_eq,  new_af_p,  old_af_p : db BLACK_INK + YELLOW_PAPER
  db 2,  28 : dw reg_bc,   reg_p_eq,  new_bc_p,  old_bc_p : db BLACK_INK + GREEN_PAPER
  db 3,  28 : dw reg_de,   reg_p_eq,  new_de_p,  old_de_p : db BLACK_INK + GREEN_PAPER
  db 4,  28 : dw reg_hl,   reg_p_eq,  new_hl_p,  old_hl_p : db BLACK_INK + GREEN_PAPER   + BRIGHT
  db 5,  25 : dw reg_ix,   reg_eq,    new_ix,    old_ix   : db BLACK_INK + CYAN_PAPER
  db 6,  25 : dw reg_iy,   reg_eq,    new_iy,    old_iy   : db BLACK_INK + CYAN_PAPER

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

; But hex numbers, given that there are 32 of them, need a different approah
hex_0_low:  defb $00, $02, $05, $05, $05, $05, $02, $00 ;
hex_1_low:  defb $00, $02, $06, $02, $02, $02, $07, $00 ;
hex_2_low:  defb $00, $06, $01, $01, $02, $04, $07, $00 ;
hex_3_low:  defb $00, $06, $01, $02, $01, $01, $06, $00 ;
hex_4_low:  defb $00, $01, $03, $05, $07, $01, $01, $00 ;
hex_5_low:  defb $00, $07, $04, $06, $01, $01, $06, $00 ;
hex_6_low:  defb $00, $03, $04, $06, $05, $05, $02, $00 ;
hex_7_low:  defb $00, $07, $01, $01, $02, $02, $02, $00 ;
hex_8_low:  defb $00, $02, $05, $02, $05, $05, $02, $00 ;
hex_9_low:  defb $00, $02, $05, $05, $03, $01, $06, $00 ;
hex_a_low:  defb $00, $02, $05, $05, $07, $05, $05, $00 ;
hex_b_low:  defb $00, $06, $05, $06, $05, $05, $06, $00 ;
hex_c_low:  defb $00, $03, $04, $04, $04, $04, $03, $00 ;
hex_d_low:  defb $00, $06, $05, $05, $05, $05, $06, $00 ;
hex_e_low:  defb $00, $07, $04, $06, $04, $04, $07, $00 ;
hex_f_low:  defb $00, $07, $04, $06, $04, $04, $04, $00 ;
hex_0_high: defb $00, $20, $50, $50, $50, $50, $20, $00 ;
hex_1_high: defb $00, $20, $60, $20, $20, $20, $70, $00 ;
hex_2_high: defb $00, $60, $10, $10, $20, $40, $70, $00 ;
hex_3_high: defb $00, $60, $10, $20, $10, $10, $60, $00 ;
hex_4_high: defb $00, $10, $30, $50, $70, $10, $10, $00 ;
hex_5_high: defb $00, $70, $40, $60, $10, $10, $60, $00 ;
hex_6_high: defb $00, $30, $40, $60, $50, $50, $20, $00 ;
hex_7_high: defb $00, $70, $10, $10, $20, $20, $20, $00 ;
hex_8_high: defb $00, $20, $50, $20, $50, $50, $20, $00 ;
hex_9_high: defb $00, $20, $50, $50, $30, $10, $60, $00 ;
hex_a_high: defb $00, $20, $50, $50, $70, $50, $50, $00 ;
hex_b_high: defb $00, $60, $50, $60, $50, $50, $60, $00 ;
hex_c_high: defb $00, $30, $40, $40, $40, $40, $30, $00 ;
hex_d_high: defb $00, $60, $50, $50, $50, $50, $60, $00 ;
hex_e_high: defb $00, $70, $40, $60, $40, $40, $70, $00 ;
hex_f_high: defb $00, $70, $40, $60, $40, $40, $40, $00 ;

