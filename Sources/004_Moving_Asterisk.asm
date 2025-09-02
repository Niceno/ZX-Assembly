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
  ld A, 21          ; row 21 = bottom of screen.
  ld (text_row), A  ; set initial text row

  ;----------------------
  ; Move the asterisk up
  ;----------------------
Main_Loop:
  call Set_Text_Coords_Sub  ; set up our row/column coords

  ; Print asterisk
  ld A, CHAR_ASTERISK   ; want an asterisk here
  rst ROM_PRINT_A_1     ; display it

  call Delay_Sub        ; want a delay

  ; Delete the asterisk (print space over it)
  call Set_Text_Coords_Sub  ; set up our row/column coords
  ld A, CHAR_SPACE          ; ASCII code for space
  rst ROM_PRINT_A_1         ; delete old asterisk

  ; Decrease text row -> move asterisk position up
  ld HL, text_row   ; vertical position
  dec (HL)          ; move it up one line
  ld A, (HL)        ; where is it now?
  cp 255            ; past top of screen yet?
  jr nz, Main_Loop  ; no, carry on

  ret  ; end of the main program

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   SUBROUTINES
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  include "Subs/Open_Upper_Screen_Sub.asm"
  include "Subs/Delay_Sub.asm"
  include "Subs/Set_Text_Coords_Sub.asm"

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   DATA
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
text_row:
  defb 0

text_column:
  defb 15

;-------------------------------------------------------------------------------
; Save a snapshot that starts execution at the address marked with Main_Sub
;-------------------------------------------------------------------------------
  savesna "bojan.sna", Main_Sub
