  include "Constants.inc"

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
Main:

  ;------------------------------
  ; Specify the beginning of UDG
  ;------------------------------
  ld HL, udgs                         ; user defined graphics (UDGs)
  ld (MEM_USER_DEFINED_GRAPHICS), HL  ; set up UDG system variable.

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
.loop:

    ; Print monster
    ld HL, monster_01              ; ghost_01
    push BC                        ; save the row count
    call Print_Udgs_Character  ; this clobbers B

    ld B, 10        ; cycles for Delay.
    call Delay  ; want a delay, also clobbers B
    pop BC          ; get back the row count

    ; Delete the monster
    ; (print space over it)
    ld HL, space_to_print
    push BC                        ; save the row count
    call Print_Udgs_Character
    pop BC                         ; get back proper row count

  ; Decrease text row -> move monster position up
  djnz .loop  ; no, carry on

  ret  ; end of the main program

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   SUBROUTINES
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  include "Subs/Delay.asm"
  include "Subs/Calculate_Screen_Pixel_Address.asm"
  include "Subs/Udgs/Print_Character.asm"

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   DATA
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  include "Global_Data.inc"

udgs:

; The 8x8 sprites which follow, were created with the command:
; python.exe .\convert_sprite_8x8.py .\[name].8x8 in the directory Figures
ghost_01:        defb $3C, $7E, $DB, $99, $FF, $FF, $DB, $DB
human_01:        defb $18, $3C, $18, $FF, $18, $3C, $24, $66
monster_01:      defb $99, $BD, $5A, $7E, $42, $3C, $DB, $81
monster_02:      defb $24, $3C, $3C, $5A, $BD, $3C, $66, $42
monster_03:      defb $24, $7E, $FF, $DB, $7E, $42, $BD, $81
monster_04:      defb $42, $81, $BD, $5A, $66, $3C, $66, $A5
arrow_up:        defb $18, $24, $42, $C3, $24, $24, $24, $3C
arrow_down:      defb $3C, $24, $24, $24, $C3, $42, $24, $18
arrow_left:      defb $10, $30, $4F, $81, $81, $4F, $30, $10
arrow_right:     defb $08, $0C, $F2, $81, $81, $F2, $0C, $08
space_to_print:  defb $00, $00, $00, $00, $00, $00, $00, $00

;-------------------------------------------------------------------------------
; Save a snapshot that starts execution at the address marked with Main
;-------------------------------------------------------------------------------
  savesna "bojan_005.sna", Main
  savebin "bojan_005.bin", Main, $ - Main
