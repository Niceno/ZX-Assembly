;===============================================================================
; Print_Registers_Sub
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
Print_Registers_Sub:

  ;--------------------------
  ;
  ; Save the registers first
  ;
  ;--------------------------
  push AF
  push BC
  push DE
  push HL
  push IX
  push IY

  ;---------------------------
  ; Increase the loop counter
  ;---------------------------
  push AF
  ld A, (call_count)
  inc A               ; at this point, A is 1 or 2
  ld (call_count), A
  pop AF

  ;------------------------------------------
  ; Save registers in the "new" memory slots
  ;------------------------------------------
  ; (Bear in mind that the system is little endian,
  ;  so L will be saved first in memory, H second.)
  ld (new_hl), HL  ; save HL first, you will use it to save others
  push AF          ; save AF through HL
  pop  HL
  ld (new_af), HL
  push BC          ; save BC through HL
  pop  HL
  ld (new_bc), HL
  push DE          ; save DE through HL
  pop  HL
  ld (new_de), HL
  push IX          ; save IX through HL
  pop HL
  ld (new_ix), HL
  push IY          ; save IY through HL
  pop HL
  ld (new_iy), HL

  ;------------------------------
  ;
  ; Browse through all registers
  ;
  ;------------------------------
  ld IX, reg_table
  ld B, REG_ENTRIES

Print_Registers_Loop:
  push bc

  ;------------------
  ; Text coordinates
  ;------------------
  ld B, (IX+0)  ; B holds row
  ld C, (IX+1)  ; C holds column
  call Increase_Row_For_2nd_Call  ; add 10 to B for the 2nd call
  call Set_Text_Coords_Sub        ; uses BC to set coordinates in ROM

  ;-----------------
  ; Register labels
  ;-----------------
  ld L, (IX+2)  ; notice little endian: lower byte first ...
  ld H, (IX+3)  ; ... higher byte second
  call Print_Null_Terminated_String_Sub  ; uses ROM routine to print

  ;-------------------------------------------------------------
  ; Print hex number from new_ptr (which is always the current)
  ;-------------------------------------------------------------
  ld   L, (IX+4)  ; little ...
  ld   H, (IX+5)  ; ... endian
  inc  HL
  ld   A, (HL)
  ld   E, 4
  call Print_Hex_Byte_Sub
  dec  HL
  ld   A, (HL)
  ld   E, 6
  call Print_Hex_Byte_Sub

  ;---------------------------------
  ; Colour (maybe flash) vs old_ptr
  ;---------------------------------
  ld A, (IX+8)  ; color
  ld E, (IX+6)
  ld D, (IX+7)  ; old_ptr
  call Compare_Registers
  ld   DE, $0801
  call Color_Text_Box_Sub

  ld DE, REG_ROW_SIZE
  add IX, DE

  pop BC

  djnz Print_Registers_Loop

  ;----------------------------------
  ; On first call, copy the register
  ; contents to separate memory area
  ;----------------------------------
  push AF
  ld A, (call_count)

  cp 1     ; if A is 1, the first call, jump to Print_Registers_First_Call
  jr z, Print_Registers_First_Call
  jr Print_Registers_End   ; if A is not 1, go to the Print_Registers_End

Print_Registers_First_Call:
  ld HL, new_af
  ld DE, old_af
  ld BC, 12
  ldir

Print_Registers_End:
  pop AF

  ;----------------------------
  ;
  ; Restore the registers last
  ;
  ;----------------------------
  pop IY
  pop IX
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
  jr z, Increase_Row_For_2nd_Call_Increase

  pop AF

  ret

Increase_Row_For_2nd_Call_Increase:
  ld A, B
  add A, 10
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
; - This is a "local function", called only from Print_Registers_Sub,
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
  jr z, Compare_Registers_Jump

  pop BC
  pop AF

  ret

Compare_Registers_Jump:

  push AF  ; push AF for comparison

  ; Compare all bytes (why only two?)
  ld A, (DE)
  cp (HL)
  jr nz, Add_Flashing
  inc HL
  inc DE
  ld A, (DE)
  cp (HL)
  jr nz, Add_Flashing

  pop AF  ; comparison done, restore AF

  pop BC
  pop AF  ; restore AF from the beginning of this sub, the one with color

  ret

Add_Flashing:

  pop AF  ; comparison done, restore AF

  pop BC
  pop AF  ; restore AF from the beginning of this sub, the one with color

  add FLASH

  ret

;===============================================================================
; Print_Hex_Byte_Sub
;-------------------------------------------------------------------------------
; Parameters:
; - A: byte to print as two hexadecimal digits (from $00 to $FF)
;
; Clobbers:
; - nothing
;
; Note:
; - This is a "local function", called only from Print_Registers_Sub,
;   that's why it is not in a separate file
;-------------------------------------------------------------------------------
Print_Hex_Byte_Sub:

  push AF
; push DE
  push HL
  push BC

  ld D, A  ; save original byte

  ; Work out the coordinates of the hex byte
  ld B, (IX+0)  ; B holds row
  ld C, (IX+1)  ; C holds column
  call Increase_Row_For_2nd_Call  ; add 10 to B for the 2nd call
  ld A, E  ; load the shift
  add C    ; add shift to the column
  ld C, A  ; put the result back in C

  ; Print high nibble first
  ld A, D                   ; restore the original byte
  rra                       ; shift right 4 bits
  rra
  rra
  rra
  and $0F                   ; mask lower 4 bits
  call Print_Hex_Digit_Sub

  inc C
  ; Print low nibble
  ld A, D                   ; restore original byte
  and $0F                   ; mask lower 4 bits
  call Print_Hex_Digit_Sub

  pop BC
  pop HL
; pop DE
  pop AF

  ret

;===============================================================================
; Print_Hex_Digit_Sub
;-------------------------------------------------------------------------------
; Purpose:
; - Prints a digit as a hexadecial number (from 0 to F)
;
; Parameters:
; - A: digit (0-15) to print as hexadecimal
; - Uses predefined strings in hex_string_table
;
; Clobbers:
; - nothing
;
; Note:
; - This is a "local function", called only from Print_Registers_Sub,
;   that's why it is not in a separate file
;-------------------------------------------------------------------------------
Print_Hex_Digit_Sub:

  push HL
  push DE
  push BC

  ; Calculate address of the string (string_0 to string_F)
  ld HL, hex_char_table  ; point to the start of character table
  ld D, 0
  ld E, A                ; DE = digit value (0-15)
  add HL, DE             ; now point to the right character in the table
; ld A, (HL)             ; A holds the character code to print

  ; Print the string
  call Print_Character_Sub

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

; Saved on the current call, be it first or second
new_af:  defw  $0000
new_bc:  defw  $0000
new_de:  defw  $0000
new_hl:  defw  $0000
new_ix:  defw  $0000
new_iy:  defw  $0000

; Saved on the first call, become old at the second call
old_af:  defw  $00
old_bc:  defw  $00
old_de:  defw  $00
old_hl:  defw  $00
old_ix:  defw  $00
old_iy:  defw  $00

; Null-terminated register names to print
af_string: defb "AF :", 0
bc_string: defb "BC :", 0
de_string: defb "DE :", 0
hl_string: defb "HL :", 0
ix_string: defb "IX :", 0
iy_string: defb "IY :", 0

;    row,col,    str_ptr,    new_ptr,  old_ptr,   color
;    0   1       2-3         4-5       6-7        8
reg_table:
  db 0,  24 : dw af_string,  new_af,   old_af   : db WHITE_INK + BLACK_PAPER
  db 1,  24 : dw bc_string,  new_bc,   old_bc   : db WHITE_INK + BLUE_PAPER
  db 2,  24 : dw de_string,  new_de,   old_de   : db WHITE_INK + MAGENTA_PAPER
  db 3,  24 : dw hl_string,  new_hl,   old_hl   : db WHITE_INK + RED_PAPER
  db 4,  24 : dw ix_string,  new_ix,   old_ix   : db BLACK_INK + GREEN_PAPER
  db 5,  24 : dw iy_string,  new_iy,   old_iy   : db BLACK_INK + YELLOW_PAPER
reg_table_end:
REG_ROW_SIZE  equ  9
REG_ENTRIES   equ  6

hex_char_table:
  defb "01234567890ABCDEF"
