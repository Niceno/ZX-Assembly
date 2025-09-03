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
;   MAIN PROGRAM
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

  ;---------------------------------------------
  ; Initialize text row in which you will start
  ;---------------------------------------------
  ld B, 21
  ld C, 15

  ;----------------------
  ; Move the asterisk up
  ;----------------------
Main_Loop:

  ; Print asterisk
  ld HL, char_to_print
  push BC                       ; save the row count
  call Print_Character_Reg_Sub  ; this clobbers B

  call Delay_Sub  ; want a delay, also clobbers B
  pop BC          ; get back the row count

  ; Delete the asterisk
  ; (print space over it)
  ld HL, space_to_print
  push BC                       ; save the row count
  call Print_Character_Reg_Sub  ; clobbers B
  pop BC                        ; get back proper row count

  ; Decrease text row -> move asterisk position up
  djnz Main_Loop  ; no, carry on

  ret  ; end of the main program

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   SUBROUTINES
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  include "Subs/Open_Upper_Screen_Sub.asm"
  include "Subs/Delay_Sub.asm"
  include "Subs/Print_Character_Reg_Sub.asm"

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   DATA
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
char_to_print:   defb  CHAR_ASTERISK
space_to_print:  defb  CHAR_SPACE

screen_row_offset:  ; 24 words or 48 bytes
  defw     0  ; row  0
  defw    32  ; row  1
  defw    64  ; row  2
  defw    96  ; row  3
  defw   128  ; row  4
  defw   160  ; row  5
  defw   192  ; row  6
  defw   224  ; row  7
  defw  2048  ; row  8 = 32 * 8 * 8
  defw  2080  ; row  9
  defw  2112  ; row 10
  defw  2144  ; row 11
  defw  2176  ; row 12
  defw  2208  ; row 13
  defw  2240  ; row 14
  defw  2272  ; row 15
  defw  4096  ; row 16 = 32 * 8 * 8 * 2
  defw  4128  ; row 17
  defw  4160  ; row 18
  defw  4192  ; row 19
  defw  4224  ; row 20
  defw  4256  ; row 21
  defw  4288  ; row 22
  defw  4320  ; row 23

;-------------------------------------------------------------------------------
; Save a snapshot that starts execution at the address marked with Main_Sub
;-------------------------------------------------------------------------------
  savesna "bojan.sna", Main_Sub
  savebin "bojan.bin", Main_Sub, $ - Main_Sub
