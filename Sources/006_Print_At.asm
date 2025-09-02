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
;   MAIN PROGRAMAIN PROGRAM
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

  ;------------------------------------------------------------
  ; Set coordinates to 5, 5, length to 1 and print an asterisk
  ;------------------------------------------------------------
  ld A, 15                      ; row
  ld (text_row), A              ; store row coordinate
  ld A,  5                      ; column
  ld (text_column), A           ; store column coordinate
  ld A,  1                      ; length of the string
  ld (text_length), A           ; store the length
  ld A,  1                      ; height
  ld (text_height), A           ; store the height
  ld A, RED_INK + YELLOW_PAPER  ; color of the string
  ld (text_color), A            ; store the color
  call Set_Text_Coords_Sub      ; set up our row/column coords

  ld A, CHAR_ASTERISK   ; print an asterisk
  rst ROM_PRINT_A_1     ; display it

  ;---------------------
  ; Color that asterisk
  ;---------------------
  call Color_Text_Box_Sub

  ;--------------------------------------------
  ; Set coordinates to 9, 9 and print a string
  ;--------------------------------------------
  ld A, 9                   ; row
  ld (text_row), A          ; store row coordinate
  ld A, 9                   ; column
  ld (text_column), A       ; store column coordinate
  ld A, 14                  ; length of the string
  ld (text_length), A       ; store the length of the string
  ld A,  1                  ; height
  ld (text_height), A       ; store the height
  call Set_Text_Coords_Sub  ; set up our row/col coords

  ld HL, bojan_string
  ld (text_to_print_addr), HL
  call Print_Null_Terminated_String_Sub

  ;-------------------------
  ; Color that line of text
  ;-------------------------
  call Color_Text_Box_Sub

  ;---------------------------------------------------------
  ; Set coordinates to 13, 13 and print a five digit number
  ;---------------------------------------------------------
  ld A, 13                  ; row
  ld (text_row), A          ; store row coordinate
  ld A, 13                  ; column
  ld (text_column), A       ; store column coordinate
  ld A,  5                  ; length of the string
  ld (text_length), A       ; store the length
  ld A,  1                  ; height
  ld (text_height), A       ; store the height
  call Set_Text_Coords_Sub  ; set up our row/column coords

  ;-----------------------------
  ; Print the five digit number
  ;-----------------------------
  call Print_Five_Digit_Number_Sub

  ;-------------------
  ; Color that number
  ;-------------------
  ld A, 5                     ; number is five digits long
  ld (text_length), A         ; store the length of the string
  ld A, RED_INK + CYAN_PAPER  ; color of the string
  ld (text_color), A          ; store the text color

  call Color_Text_Box_Sub

  ;---------------
  ; Make a column
  ;---------------
  ld A,  8
  ld (text_row), A             ; store row
  ld A, 24
  ld (text_column), A          ; store column coordinate
  ld A,  1
  ld (text_length), A          ; store box length
  ld A, 10
  ld (text_height), A          ; store box height
  ld A, WHITE_INK + RED_PAPER
  ld (text_color), A           ; store color

  call Color_Text_Box_Sub

  ;------------
  ; Make a box
  ;------------
  ld A, 10
  ld (text_row), A              ; store row
  ld A, 26
  ld (text_column), A           ; store column coordinate
  ld A, 3
  ld (text_length), A           ; store box length
  ld A, 3
  ld (text_height), A           ; store box height
  ld A, WHITE_INK + BLUE_PAPER
  ld (text_color), A            ; store color

  call Color_Text_Box_Sub

  ret

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   SUBROUTINES
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  include "Subs/Open_Upper_Screen_Sub.asm"
  include "Subs/Set_Text_Coords_Sub.asm"
  include "Subs/Color_Text_Box_Sub.asm"
  include "Subs/Print_Five_Digit_Number_Sub.asm"
  include "Subs/Print_Null_Terminated_String_Sub.asm"

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   DATA
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
text_row:     defb  0
text_column:  defb 15
text_length:  defb  1
text_height:  defb 10
text_color:   defb  0

bojan_string: defb "Bojan is cool!", 0
number:       defw  9999         ; defw = define word  <---=

;--------------------------------
; Address od the string to print
;--------------------------------
text_to_print_addr:  defw bojan_string  ; store the address of the string

;-------------------------------------------------------------------------------
; Save a snapshot that starts execution at the address marked with Main_Sub
;-------------------------------------------------------------------------------
  savesna "bojan.sna", Main_Sub
