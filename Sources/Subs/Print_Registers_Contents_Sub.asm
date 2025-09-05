;===============================================================================
; Print_Registers_Contents_Sub
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
Print_Registers_Contents_Sub:

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

  ;--------------
  ;
  ; AF registers
  ;
  ;--------------

  ; Print the AF string
  ld BC, $0019                    ; row and column
  call Increase_Row_For_2nd_Call  ; increase B for the 2nd call
  call Set_Text_Coords_Sub        ; set up up row/col coords.
  ld HL, af_string
  call Print_Null_Terminated_String_Sub

  ; Print AF register
  ld HL, new_af
  inc HL
  ld A, (HL)
  call Print_Hex_Byte_Sub
  dec HL
  ld A, (HL)
  call Print_Hex_Byte_Sub

  ; Color the AF registers
  ld A, WHITE_INK + BLACK_PAPER  ; color
  ld DE, old_af
  call Compare_Registers
  ld DE, $0701                   ; length and height
  call Color_Text_Box_Sub

  ;--------------
  ;
  ; BC registers
  ;
  ;--------------

  ; Print the BC string
  ld BC, $0119                    ; row and column
  call Increase_Row_For_2nd_Call  ; increase B for the 2nd call
  call Set_Text_Coords_Sub        ; set up up row/col coords.
  ld HL, bc_string
  call Print_Null_Terminated_String_Sub

  ; Print BC register
  ld HL, new_bc
  inc HL
  ld A, (HL)
  call Print_Hex_Byte_Sub
  dec HL
  ld A, (HL)
  call Print_Hex_Byte_Sub

  ; Color the BC registers
  ld A, WHITE_INK + BLUE_PAPER  ; color
  ld DE, old_bc
  call Compare_Registers
  ld DE, $0701                  ; length and height
  call Color_Text_Box_Sub

  ;--------------
  ;
  ; DE registers
  ;
  ;--------------

  ; Print the DE string
  ld BC, $0219                    ; row and column
  call Increase_Row_For_2nd_Call  ; increase B for the 2nd call
  call Set_Text_Coords_Sub        ; set up up row/col coords.
  ld HL, de_string
  call Print_Null_Terminated_String_Sub

  ; Print DE register
  ld HL, new_de
  inc HL
  ld A, (HL)
  call Print_Hex_Byte_Sub
  dec HL
  ld A, (HL)
  call Print_Hex_Byte_Sub

  ; Color the DE registers
  ld A, WHITE_INK + MAGENTA_PAPER  ; color
  ld DE, old_de
  call Compare_Registers
  ld DE, $0701                     ; length and height
  call Color_Text_Box_Sub

  ;--------------
  ;
  ; HL registers
  ;
  ;--------------

  ; Print the HL string
  ld BC, $0319                    ; row and column
  call Increase_Row_For_2nd_Call  ; increase B for the 2nd call
  call Set_Text_Coords_Sub        ; set up up row/col coords.
  ld HL, hl_string
  call Print_Null_Terminated_String_Sub

  ; Now print HL register in hex
  ld HL, new_hl
  inc HL
  ld A, (HL)
  call Print_Hex_Byte_Sub
  dec HL
  ld A, (HL)
  call Print_Hex_Byte_Sub

  ; Color the HL registers
  ld A, WHITE_INK + RED_PAPER  ; color
  ld DE, old_hl
  call Compare_Registers
  ld DE, $0701                 ; length and height
  call Color_Text_Box_Sub

  ;----------------------------------
  ; On first call, copy the register
  ; contents to separate memory area
  ;----------------------------------
  push AF
  ld A, (call_count)

  cp 1
  jr z, First_Call  ; if A is 1, the first call, jump to First_Call
  jr End            ; if A is not 1, go to the End

First_Call:
  ld HL, new_af
  ld DE, old_af
  ld BC, 12
  ldir

End:
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
; - This is a "local function", called only from Print_Registers_Contents_Sub,
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
; - This is a "local function", called only from Print_Registers_Contents_Sub,
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
; - This is a "local function", called only from Print_Registers_Contents_Sub,
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

