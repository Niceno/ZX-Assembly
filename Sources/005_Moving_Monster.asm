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

  ;------------------------------
  ; Specify the beginning of UDG
  ;------------------------------
  ld hl, udgs                         ; user defined graphics (UDGs)
  ld (MEM_USER_DEFINED_GRAPHICS), hl  ; set up UDG system variable.

  ;---------------
  ; Set the color
  ;---------------
  ld A, RED_INK + CYAN_PAPER      ; load A with desired color
  ld (MEM_STORE_SCREEN_COLOR), A  ; set the screen colors
  call ROM_CLEAR_SCREEN           ; clear the screen

  ;---------------------------------------------
  ; Initialize text row in which you will start
  ;---------------------------------------------
  ld B, 21
  ld C, 15

  ;---------------------
  ; Move the monster up
  ;---------------------
Main_Loop:

  ; Print monster
  ld HL, monster_01                  ; ghost_01
  push BC                            ; save the row count
  call Print_Udgs_Character_Reg_Sub  ; this clobbers B

  call Delay_Sub  ; want a delay, also clobbers B
  pop BC          ; get back the row count

  ; Delete the monster
  ; (print space over it)
  ld HL, space_to_print
  push BC                            ; save the row count
  call Print_Udgs_Character_Reg_Sub
  pop BC                             ; get back proper row count

  ; Decrease text row -> move monster position up
  djnz Main_Loop  ; no, carry on

  ret  ; end of the main program

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   SUBROUTINES
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  include "Subs/Open_Upper_Screen_Sub.asm"
  include "Subs/Delay_Sub.asm"
  include "Subs/Print_Udgs_Character_Reg_Sub.asm"

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   DATA
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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

udgs:

; The 8x8 sprites which follow, were created with the command:
; python.exe .\convert_sprite_8x8.py .\[name].8x8 in the directory Figures
ghost_01:
  defb $3C, $7E, $DB, $99, $FF, $FF, $DB, $DB

human_01:
  defb $18, $3C, $18, $FF, $18, $3C, $24, $66

monster_01:
  defb $99, $BD, $5A, $7E, $42, $3C, $DB, $81

monster_02:
  defb $24, $3C, $3C, $5A, $BD, $3C, $66, $42

monster_03:
  defb $24, $7E, $FF, $DB, $7E, $42, $BD, $81

monster_04:
  defb $42, $81, $BD, $5A, $66, $3C, $66, $A5

arrow_up:
  defb $18, $24, $42, $C3, $24, $24, $24, $3C

arrow_down:
  defb $3C, $24, $24, $24, $C3, $42, $24, $18

arrow_left:
  defb $10, $30, $4F, $81, $81, $4F, $30, $10

arrow_right:
  defb $08, $0C, $F2, $81, $81, $F2, $0C, $08

space_to_print:
  defb $00, $00, $00, $00, $00, $00, $00, $00

;-------------------------------------------------------------------------------
; Save a snapshot that starts execution at the address marked with Main_Sub
;-------------------------------------------------------------------------------
  savesna "bojan.sna", Main_Sub
  savebin "bojan.bin", Main_Sub, $ - Main_Sub
