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
  ld B, (ix+0)  ; B holds row
  ld C, (ix+1)  ; C holds column
  call Increase_Row_For_2nd_Call
  call Set_Text_Coords_Sub

  ;----------------
  ; Register labes
  ;----------------
  ld L, (ix+2)  ; notice little endian, lower byte first
  ld H, (ix+3)  ; higher byte second
  call Print_Null_Terminated_String_Sub

  ;-------------------------------------------------------------
  ; Print hex number from new_ptr (which is always the current)
  ;-------------------------------------------------------------
  ld   L, (ix+4)  ; little ...
  ld   H, (ix+5)  ; ... endian
  inc  HL
  ld   A, (HL)
  call Print_Hex_Byte_Sub
  dec  HL
  ld   A, (HL)
  call Print_Hex_Byte_Sub

  ;---------------------------------
  ; Colour (maybe flash) vs old_ptr
  ;---------------------------------
  ld A, (ix+8)  ; color
  ld E, (ix+6)
  ld D, (ix+7)  ; old_ptr
  call Compare_Registers
  ld   DE, $0801
  call Color_Text_Box_Sub

  ld DE, REG_ROW_SIZE
  add ix, DE

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
; This is sort of a local function, called only from
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
  push BC
  push HL

  ; Print high nibble first
  ld B, A                   ; save original byte
  rra                       ; shift right 4 bits
  rra
  rra
  rra
  and $0F                   ; mask lower 4 bits
  call Print_Hex_Digit_Sub

  ; Print low nibble
  ld A, B                   ; restore original byte
  and $0F                   ; mask lower 4 bits
  call Print_Hex_Digit_Sub

  pop HL
  pop BC
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
  ld H, 0
  ld L, A                   ; HL = digit (0-15)
  add HL, HL                ; HL = digit * 2 (each string pointer is 2 bytes)

  ld DE, hex_string_table   ; DE = start of string pointer table
  add HL, DE                ; HL = address of string pointer

  ; Load the string address
  ld E, (HL)
  inc HL
  ld D, (HL)                ; DE = address of the string (e.g., string_A)

  ; Print the string
  ld HL, DE
  call Print_Null_Terminated_String_Sub

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

; Null-terminated hex digits
string_0: defb "0", 0
string_1: defb "1", 0
string_2: defb "2", 0
string_3: defb "3", 0
string_4: defb "4", 0
string_5: defb "5", 0
string_6: defb "6", 0
string_7: defb "7", 0
string_8: defb "8", 0
string_9: defb "9", 0
string_A: defb "A", 0
string_B: defb "B", 0
string_C: defb "C", 0
string_D: defb "D", 0
string_E: defb "E", 0
string_F: defb "F", 0

; Table of pointers to hex digit strings
hex_string_table:
  defw string_0, string_1, string_2, string_3
  defw string_4, string_5, string_6, string_7
  defw string_8, string_9, string_A, string_B
  defw string_C, string_D, string_E, string_F

