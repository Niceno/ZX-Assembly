  include "Spectrum_Constants.inc"

;--------------------------------------
; Set the architecture you'll be using
;--------------------------------------
  device zxspectrum48

;-----------------------------------------------
; Memory address at which the program will load
;-----------------------------------------------
  org MEM_PROGRAM_START

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   MAIN SUBROUTINE
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

;===============================================================================
; Main subroutine begins here
;-------------------------------------------------------------------------------
Main_Sub:

  ;----------------------------------
  ; Open the channel to upper screen
  ;----------------------------------
  call Open_Upper_Screen_Sub

  ;--------------
  ;
  ; AF registers
  ;
  ;--------------

  ;---------------------
  ; Print the AF string
  ;---------------------
  ld BC, $0019                  ; row and column
  call Set_Text_Coords_Reg_Sub  ; set up up row/col coords.

  ld HL, af_string
  call Print_Null_Terminated_String_Sub

  ;----------------------------------
  ; Now print AF register in hex
  ;----------------------------------
  call Print_Hex_Byte_Sub  ; just print A as it is

  ; Print F register
  push HL                  ; save HL because we're going to use it
  push AF                  ; push AF onto the stack (AF is now on top of stack)
  pop  HL                  ; pop the word into HL (now L = F, H = A)
  ld   A, L                ; now A contains the F register value
  call Print_Hex_Byte_Sub  ; print the flags byte
  pop  HL                  ; restore the original HL value

  ;------------------------
  ; Color the AF registers
  ;------------------------
  ld A, WHITE_INK + BLACK_PAPER  ; color
  ld BC, $0019                   ; row and column
  ld DE, $0701                   ; length and height
  call Color_Text_Box_Reg_Sub

  ;--------------
  ;
  ; BC registers
  ;
  ;--------------

  ;---------------------
  ; Print the BC string
  ;---------------------
  ld BC, $0119                  ; row and column
  call Set_Text_Coords_Reg_Sub  ; set up up row/col coords.

  ld HL, bc_string
  call Print_Null_Terminated_String_Sub

  ;----------------------------------
  ; Now print BC register in hex
  ;----------------------------------
  ; Set BC to some test value
  ld BC, $F7FE              ; example value - keyboard port

  ; Print B register (high byte) first
  ld A, B                   ; A = high byte ($F7)
  call Print_Hex_Byte_Sub

  ; Print C register (low byte)
  ld A, C                   ; A = low byte ($FE)
  call Print_Hex_Byte_Sub

  ;------------------------
  ; Color the BC registers
  ;------------------------
  ld A, WHITE_INK + BLUE_PAPER  ; color
  ld BC, $0119                  ; row and column
  ld DE, $0701                  ; length and height
  call Color_Text_Box_Reg_Sub

  ;--------------
  ;
  ; DE registers
  ;
  ;--------------

  ;---------------------
  ; Print the DE string
  ;---------------------
  ld BC, $0219                  ; row and column
  call Set_Text_Coords_Reg_Sub  ; set up up row/col coords.

  ld HL, de_string
  call Print_Null_Terminated_String_Sub

  ;----------------------------------
  ; Now print DE register in hex
  ;----------------------------------
  ; Set DE to some test value
  ld DE, $3344              ; Example value

  ; Print D register (high byte) first
  ld A, D                   ; A = high byte
  call Print_Hex_Byte_Sub

  ; Print E register (low byte)
  ld A, E                   ; A = low byte
  call Print_Hex_Byte_Sub

  ;------------------------
  ; Color the DE registers
  ;------------------------
  ld A, WHITE_INK + MAGENTA_PAPER  ; color
  ld BC, $0219                     ; row and column
  ld DE, $0701                     ; length and height
  call Color_Text_Box_Reg_Sub

  ;--------------
  ;
  ; HL registers
  ;
  ;--------------

  ;---------------------
  ; Print the HL string
  ;---------------------
  ld BC, $0319                  ; row and column
  call Set_Text_Coords_Reg_Sub  ; set up up row/col coords.

  ld HL, hl_string
  call Print_Null_Terminated_String_Sub

  ;----------------------------------
  ; Now print HL register in hex
  ;----------------------------------
  ; Set HL to some test value
  ld HL, $ABCD              ; Example value

  ; Print H register (high byte) first
  ld A, H                   ; A = high byte
  call Print_Hex_Byte_Sub

  ; Print E register (low byte)
  ld A, L                   ; A = low byte
  call Print_Hex_Byte_Sub

  ;------------------------
  ; Color the HL registers
  ;------------------------
  ld A, WHITE_INK + RED_PAPER  ; color
  ld BC, $0319                 ; row and column
  ld DE, $0701                 ; length and height
  call Color_Text_Box_Reg_Sub

  ei  ; <--= (re)enable interrupts if you want to return to OS/BASIC

  ret

;===============================================================================
; Print_Hex_Byte_Sub
;-------------------------------------------------------------------------------
; Input: A = byte to print as hexadecimal
; Uses your predefined strings: string_0 to string_F
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
; Input: A = digit (0-15) to print as hexadecimal
; Uses your predefined strings: string_0 to string_F
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
;   SUBROUTINES
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  include "Subs/Open_Upper_Screen_Sub.asm"
  include "Subs/Set_Text_Coords_Reg_Sub.asm"
  include "Subs/Color_Text_Box_Reg_Sub.asm"
  include "Subs/Print_Null_Terminated_String_Sub.asm"

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   DATA
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

;---------------------------------
; Null-terminated string to print
;---------------------------------
af_string: defb "AF:", 0
bc_string: defb "BC:", 0
de_string: defb "DE:", 0
hl_string: defb "HL:", 0

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

;-------------------------------------------------------------------------------
; Save a snapshot that starts execution at the address marked with Main_Sub
;-------------------------------------------------------------------------------
  savesna "bojan.sna", Main_Sub
  savebin "bojan.bin", Main_Sub, $ - Main_Sub
