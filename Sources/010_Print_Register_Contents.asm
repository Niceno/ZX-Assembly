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
  ; BC registers
  ;
  ;--------------

  ;---------------------
  ; Print the BC string
  ;---------------------
  ld A, 25
  ld (text_column), A       ; store column coordinate
  ld A,  1
  ld (text_row), A          ; store row coordinate
  call Set_Text_Coords_Sub  ; set up up row/col coords.

  ld HL, bc_string          ; set the text_to_print_addr to string to print
  ld (text_to_print_addr), HL
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

  ;--------------
  ;
  ; DE registers
  ;
  ;--------------

  ;---------------------
  ; Print the DE string
  ;---------------------
  ld A, 25
  ld (text_column), A       ; store column coordinate
  ld A,  2
  ld (text_row), A          ; store row coordinate
  call Set_Text_Coords_Sub  ; set up up row/col coords.

  ld HL, de_string          ; set the text_to_print_addr to string to print
  ld (text_to_print_addr), HL
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

  ;--------------
  ;
  ; HL registers
  ;
  ;--------------

  ;---------------------
  ; Print the HL string
  ;---------------------
  ld A, 25
  ld (text_column), A       ; store column coordinate
  ld A,  3                  ; row 2
  ld (text_row), A          ; store row coordinate
  call Set_Text_Coords_Sub  ; set up up row/col coords.

  ld HL, hl_string          ; set the text_to_print_addr to string to print
  ld (text_to_print_addr), HL
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

  ;---------------
  ; Make a column
  ;---------------
  ld A,  0
  ld (text_row), A             ; store row
  ld A, 25
  ld (text_column), A          ; store column coordinate
  ld A,  7
  ld (text_length), A          ; store box length
  ld A,  3
  ld (text_height), A          ; store box height
  ld A, WHITE_INK + BLUE_PAPER
  ld (text_color), A           ; store color

  call Color_Text_Box_Sub

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
  ld (text_to_print_addr), DE
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
  include "Subs/Set_Text_Coords_Sub.asm"
  include "Subs/Color_Text_Box_Sub.asm"
  include "Subs/Print_Null_Terminated_String_Sub.asm"

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   DATA
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

;---------------------------------
; Null-terminated string to print
;---------------------------------
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

;--------------------------------
; Address of the string to print
;--------------------------------
text_to_print_addr: defw bc_string    ; store the address of the string

text_row:     defb  0
text_column:  defb  0
text_length:  defb  0
text_height:  defb  0
text_color:   defb  0

end_of_my_data: defb $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF

;-------------------------------------------------------------------------------
; Save a snapshot that starts execution at the address marked with Main_Sub
;-------------------------------------------------------------------------------
  savesna "bojan.sna", Main_Sub
  savebin "bojan.bin", Main_Sub, $ - Main_Sub
