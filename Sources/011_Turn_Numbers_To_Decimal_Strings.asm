  include "Spectrum_Constants.inc"

;--------------------------------------
; Set the architecture you'll be using
;--------------------------------------
  device zxspectrum48

;-----------------------------------------------
; Memory address at which the program will load
;-----------------------------------------------
  org MEM_PROGRAM_START

;===============================================================================
; Main subroutine begins here
;-------------------------------------------------------------------------------
Main_Sub:  ; If the adress is that of a subroutine, end it up with _Sub suffix

  ;----------------------------------
  ; Open the channel to upper screen
  ;----------------------------------
  call Open_Upper_Screen_Sub

  ;------------------------------
  ; Specify the beginning of UDG
  ;------------------------------
  ld HL, udgs                         ; user defined graphics (UDGs)
  ld (MEM_USER_DEFINED_GRAPHICS), HL  ; set up UDG system variable.

  ;--------------------------------
  ;
  ; Turn a 16-bit number to string
  ;
  ;--------------------------------
  ld HL, $3039
  ld DE, number_16_ascii
  call Turn_16_Bit_Number_To_Ascii_Sub

  ld BC, $0909              ; row and column
  call Set_Text_Coords_Sub  ; set up our row/col coords
  ld HL, number_16_ascii
  call Print_String_Sub

  ld A, WHITE_INK + BLUE_PAPER  ; color of the string
  ld BC, $0909                  ; row and column
  ld DE, $0501                  ; length and height
  call Color_Text_Box_Sub

  ;--------------------------------
  ;
  ; Turn an 8-bit number to string
  ;
  ;--------------------------------
  ld HL, $0039
  ld DE, number_08_ascii
  call Turn_08_Bit_Number_To_Ascii_Sub

  ld BC, $0B0B              ; row and column
  call Set_Text_Coords_Sub  ; set up our row/col coords
  ld HL, number_08_ascii
  call Print_String_Sub

  ld A, WHITE_INK + RED_PAPER  ; color of the string
  ld BC, $0B0B                 ; row and column
  ld DE, $0301                 ; length and height
  call Color_Text_Box_Sub

  ei  ; <--= (re)enable interrupts if you want to return to OS/BASIC

  ret

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   SUBROUTINES
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  include "Subs/Open_Upper_Screen_Sub.asm"
  include "Subs/Merge_Udgs_Character_Sub.asm"
  include "Subs/Set_Text_Coords_Sub.asm"
  include "Subs/Color_Text_Box_Sub.asm"
  include "Subs/Print_Character_Sub.asm"
  include "Subs/Print_String_Sub.asm"
  include "Subs/Print_Null_Terminated_String_Sub.asm"
  include "Subs/Print_Registers_Sub.asm"
  include "Subs/Turn_08_Bit_Number_To_Ascii_Sub.asm"
  include "Subs/Turn_16_Bit_Number_To_Ascii_Sub.asm"

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   DATA
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  include "Global_Data.inc"

number_source:
  defw 12345    ; define word or two bytes, 16 bits, 2^16 = 65536

number_16_ascii:  ; leave space for five digits, plus a trailing zero
  defb "00000", 0

debug_0:
  defb ">>>>>>>>>>>>>>>>"
number_08_ascii:  ; leave space for three digits, plus a trailing zero
  defb "000", 0
debug_1:
  defb "<<<<<<<<<<<<<<<<"

;-------------------------------------------------------------------------------
; Save a snapshot that starts execution at the address marked with Main_Sub
;-------------------------------------------------------------------------------
  savesna "bojan.sna", Main_Sub
  savebin "bojan.bin", Main_Sub, $ - Main_Sub
