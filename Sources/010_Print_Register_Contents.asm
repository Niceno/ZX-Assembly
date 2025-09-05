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

  ;--------------------------------------------
  ; Set registers to some test value and print
  ; register contents for the first time
  ;--------------------------------------------
  ld BC, $F7FE  ; example value
  ld DE, $3344  ; example value
  ld HL, $ABCD  ; example value

  call Print_Registers_Contents_Sub

  ;--------------------------------------------
  ; Set registers to some test value and print
  ; register contents for the second time
  ;--------------------------------------------
  ld BC, $FEF7  ; example value
  ld DE, $3344  ; example value
  ld HL, $ABCD  ; example value

  call Print_Registers_Contents_Sub

  ei  ; <--= (re)enable interrupts if you want to return to OS/BASIC

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
  include "Subs/Print_Registers_Contents_Sub.asm"

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   DATA
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
