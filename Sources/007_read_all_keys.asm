  include "spectrum48.inc"

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
;   CODE
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

;===============================================================================
; Main subroutine begins here
;-------------------------------------------------------------------------------
Main_Sub:

  ;----------------------------------
  ; Open the channel to upper screen
  ;----------------------------------
  ld A, 2             ; upper screen is 2
  call ROM_CHAN_OPEN  ; open channel

  ;------------------------------
  ; Specify the beginning of UDG
  ;------------------------------
  ld hl, udgs                         ; user defined graphics (UDGs)
  ld (MEM_USER_DEFINED_GRAPHICS), hl  ; set up UDG system variable.

  ;-------------------------------------------------
  ; Set coordinates to 5, 5, length and height to 1
  ;-------------------------------------------------
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

  ;---------------------
  ; Color that asterisk
  ;---------------------
  call Color_Text_Box_Sub

  ;--------------------------------------------------------------------
  ; Wait until a key is pressed
  ;
  ; Just to make sure these constructs are clear:
  ; - We load the contents of a "KEYS_....." port into BC register
  ; - Then we read from the port addressed by BC, and stores the
  ;   result in A (this is what "in" command does.
  ; - Then we compare a particular bit of A using the bit command
  ;   (The bit command only modifies the Zero (Z) flag.
  ;    > If the tested bit is 1, the Z flag is reset to 0.
  ;    > If the tested bit is 0, the Z flag is set to 1.
  ; - When the zero flag is zero (i.e., key is pressed), we jump to
  ;   the label that handles printing that key.
  ;
  ; (It would be better to use "jr z, Address" here, but there
  ;  are simply too many keys now.  When it gets smaller again.)
  ;--------------------------------------------------------------------
Main_Read_Next_Key:

  ; Keyboard row
  ld BC, KEYS_12345

  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 0, A        ; bit 0 = key "1"
  jp z, Main_Print_1
  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 1, A        ; bit 1 = key "2"
  jp z, Main_Print_2
  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 2, A        ; bit 2 = key "3"
  jp z, Main_Print_3
  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 3, A        ; bit 3 = key "4"
  jp z, Main_Print_4
  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 4, A        ; bit 4 = key "5"
  jp z, Main_Print_5

  ; Keyboard row
  ld BC, KEYS_67890

  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 4, A        ; bit 4 = key "6"
  jp z, Main_Print_6
  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 3, A        ; bit 3 = key "7"
  jp z, Main_Print_7
  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 2, A        ; bit 2 = key "8"
  jp z, Main_Print_8
  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 1, A        ; bit 1 = key "9"
  jp z, Main_Print_9
  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 0, A        ; bit 0 = key "0"
  jp z, Main_Print_0

  ; Keyboard row
  ld BC, KEYS_QWERT

  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 0, A        ; bit 0 = key "Q"
  jp z, Main_Print_Q
  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 1, A        ; bit 1 = key "W"
  jp z, Main_Print_W
  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 2, A        ; bit 2 = key "E"
  jp z, Main_Print_E
  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 3, A        ; bit 3 = key "R"
  jp z, Main_Print_R
  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 4, A        ; bit 4 = key "T"
  jp z, Main_Print_T

  ; Keyboard row
  ld BC, KEYS_YUIOP

  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 4, A        ; bit 4 = key "Y"
  jp z, Main_Print_Y
  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 3, A        ; bit 3 = key "U"
  jp z, Main_Print_U
  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 2, A        ; bit 2 = key "I"
  jp z, Main_Print_I
  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 1, A        ; bit 1 = key "O"
  jp z, Main_Print_O
  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 0, A        ; bit 0 = key "P"
  jp z, Main_Print_P

  ; Keyboard row
  ld BC, KEYS_ASDFG

  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 0, A        ; bit 0 = key "A"
  jp z, Main_Print_A
  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 1, A        ; bit 1 = key "S"
  jp z, Main_Print_S
  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 2, A        ; bit 2 = key "D"
  jp z, Main_Print_D
  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 3, A        ; bit 3 = key "F"
  jp z, Main_Print_F
  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 4, A        ; bit 4 = key "G"
  jp z, Main_Print_G

  ; Keyboard row
  ld BC, KEYS_HJKLENTER

  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 4, A        ; bit 4 = key "H"
  jp z, Main_Print_H
  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 3, A        ; bit 3 = key "J"
  jp z, Main_Print_J
  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 2, A        ; bit 2 = key "K"
  jp z, Main_Print_K
  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 1, A        ; bit 1 = key "L"
  jp z, Main_Print_L
  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 0, A        ; bit 0 = key "ENTER"
  jp z, Main_Print_Enter

  ; Keyboard row
  ld BC, KEYS_CAPSZXCV

  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 0, A        ; bit 0 = key "CAPS SHIFT"
  jp z, Main_Print_Caps
  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 1, A        ; bit 1 = key "Z"
  jp z, Main_Print_Z
  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 2, A        ; bit 2 = key "X"
  jp z, Main_Print_X
  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 3, A        ; bit 3 = key "C"
  jp z, Main_Print_C
  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 4, A        ; bit 4 = key "V"
  jp z, Main_Print_V

  ; Keyboard row
  ld BC, KEYS_BNMSYMSPC

  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 4, A        ; bit 4 = key "B"
  jp z, Main_Print_B
  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 3, A        ; bit 3 = key "N"
  jp z, Main_Print_N
  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 2, A        ; bit 2 = key "M"
  jp z, Main_Print_M
  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 1, A        ; bit 1 = key "SYMBOL SHIFT"
  jp z, Main_Print_Symb
  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 0, A        ; bit 0 = key "SPACE"
  jp z, Main_Print_Space

  jp Main_Read_Next_Key    ; if not pressed, repeat loop

  ;--------------------------
  ; Set the proper character
  ;--------------------------
Main_Print_1:
  ld A, CHAR_1
  jp Main_Done_Setting

Main_Print_2:
  ld A, CHAR_2
  jp Main_Done_Setting

Main_Print_3:
  ld A, CHAR_3
  jp Main_Done_Setting

Main_Print_4:
  ld A, CHAR_4
  jp Main_Done_Setting

Main_Print_5:
  ld A, CHAR_5
  jp Main_Done_Setting

Main_Print_6:
  ld A, CHAR_6
  jp Main_Done_Setting

Main_Print_7:
  ld A, CHAR_7
  jp Main_Done_Setting

Main_Print_8:
  ld A, CHAR_8
  jp Main_Done_Setting

Main_Print_9:
  ld A, CHAR_9
  jp Main_Done_Setting

Main_Print_0:
  ld A, CHAR_0
  jp Main_Done_Setting

Main_Print_Q:
  ld A, CHAR_Q_UPP
  jp Main_Done_Setting

Main_Print_W:
  ld A, CHAR_W_UPP
  jp Main_Done_Setting

Main_Print_E:
  ld A, CHAR_E_UPP
  jp Main_Done_Setting

Main_Print_R:
  ld A, CHAR_R_UPP
  jp Main_Done_Setting

Main_Print_T:
  ld A, CHAR_T_UPP
  jp Main_Done_Setting

Main_Print_Y:
  ld A, CHAR_Y_UPP
  jp Main_Done_Setting

Main_Print_U:
  ld A, CHAR_U_UPP
  jp Main_Done_Setting

Main_Print_I:
  ld A, CHAR_I_UPP
  jp Main_Done_Setting

Main_Print_O:
  ld A, CHAR_O_UPP
  jp Main_Done_Setting

Main_Print_P:
  ld A, CHAR_P_UPP
  jp Main_Done_Setting

Main_Print_A:
  ld A, CHAR_A_UPP
  jp Main_Done_Setting

Main_Print_S:
  ld A, CHAR_S_UPP
  jp Main_Done_Setting

Main_Print_D:
  ld A, CHAR_D_UPP
  jp Main_Done_Setting

Main_Print_F:
  ld A, CHAR_F_UPP
  jp Main_Done_Setting

Main_Print_G:
  ld A, CHAR_G_UPP
  jp Main_Done_Setting

Main_Print_H:
  ld A, CHAR_H_UPP
  jp Main_Done_Setting

Main_Print_J:
  ld A, CHAR_J_UPP
  jp Main_Done_Setting

Main_Print_K:
  ld A, CHAR_K_UPP
  jp Main_Done_Setting

Main_Print_L:
  ld A, CHAR_L_UPP
  jp Main_Done_Setting

Main_Print_Enter:
  ld A, $90
  jp Main_Done_Setting

Main_Print_Caps:
  ld A, $91
  jp Main_Done_Setting

Main_Print_Z:
  ld A, CHAR_Z_UPP
  jp Main_Done_Setting

Main_Print_X:
  ld A, CHAR_X_UPP
  jp Main_Done_Setting

Main_Print_C:
  ld A, CHAR_C_UPP
  jp Main_Done_Setting

Main_Print_V:
  ld A, CHAR_V_UPP
  jp Main_Done_Setting

Main_Print_B:
  ld A, CHAR_B_UPP
  jp Main_Done_Setting

Main_Print_N:
  ld A, CHAR_N_UPP
  jp Main_Done_Setting

Main_Print_M:
  ld A, CHAR_M_UPP
  jp Main_Done_Setting

Main_Print_Symb:
  ld A, $92
  jp Main_Done_Setting

Main_Print_Space:
  ld A, $93
  jp Main_Done_Setting

  ;--------------------------------------------------
  ; Done setting the character, you can print it now
  ;--------------------------------------------------
Main_Done_Setting:
  rst ROM_PRINT_A_1         ; display it
  call Color_Text_Box_Sub   ; this seems to be needed every time
  call Set_Text_Coords_Sub  ; set up our row/column coords

  jp Main_Read_Next_Key

  ret

;===============================================================================
; Set_Text_Coords_Sub
;-------------------------------------------------------------------------------
; Purpose:
; - Set coordinates for printing text
;
; Parameters (passed via memory locations):
; - text_row
; - text_column
;-------------------------------------------------------------------------------
Set_Text_Coords_Sub:

  ld A, CHAR_AT_CONTROL  ; ASCII control code for "at"
                         ; should be followed by row and column entries
  rst ROM_PRINT_A_1      ; "print" it

  ld A, (text_row)       ; row
  rst ROM_PRINT_A_1      ; "print" it

  ld A, (text_column)    ; column
  rst ROM_PRINT_A_1      ; "print" it

  ret

;===============================================================================
; Color_Text_Box_Sub
;-------------------------------------------------------------------------------
; Purpose:
; - Colors a box of text with specified length and height
;
; Parameters (passed via memory locations):
; - text_row
; - text_column
; - text_length
; - text_height
;-------------------------------------------------------------------------------
Color_Text_Box_Sub:

  ;------------------------------------------------------------------------
  ; Set initial value of HL to point to the beginning of screen attributes
  ;------------------------------------------------------------------------
  ld HL, MEM_SCREEN_COLORS  ; load HL with the address of screen color

  ;------------------------------------------------------------------
  ; Increase HL text_column times, to shift it to the desired column
  ;------------------------------------------------------------------
  ld A, (text_column)  ; prepare B as loop counter
  ld B, A              ; ld B, (text_column) wouldn't work
Color_Text_Box_Loop_Columns:
  inc HL                            ; increase HL text_row times
  djnz Color_Text_Box_Loop_Columns  ; decrease B and jump if nonzero

  ;-----------------------------------------------------------------
  ; Increase HL text_row * 32 times, to shift it to the desired row
  ;-----------------------------------------------------------------
  ld A, (text_row)  ; prepare B as loop counter
  ld B, A           ; ld B, (text_column) wouldn't work
  ld DE, 32         ; there are 32 columns, this is not space character
Color_Text_Box_Loop_Rows:
  add HL, DE                     ; increase HL by 32
  djnz Color_Text_Box_Loop_Rows  ; decrease B and repeat the loop if nonzero

  ;---------------------------------------------------------------
  ; Now the HL holds the correct position of the screen attribute
  ; perfrom a double loop throug rows and columns to color a box
  ;---------------------------------------------------------------
  ld A, (text_color)   ; prepare the color
  ld C, A              ; store the color in C
  ld A, (text_height)  ; A stores height, will be the outer loop

Color_Text_Box_Loop_Height:  ; loop over A, outer loop

  ; Store HL at the first row position
  push HL

  ; Set (and re-set) B to text length, inner counter
  ; You have to preserve (push/pop) in order to keep the outer counter value
  push AF              ; A stores text height, store it before using A to fill B
  ld A, (text_length)  ; prepare B as loop counter
  ld B, A              ; B stores the lengt, will be inner loop
  pop AF               ; restore A

Color_Text_Box_Loop_Length:  ; loop over B, inner loop
  ld (HL), C                 ; set the color at position pointed by HL registers
  inc HL                     ; go to the next horizontal position
  djnz Color_Text_Box_Loop_Length

  pop HL             ; retreive the first positin in the row
  add HL, DE         ; go to the next row

  dec A                              ; decrease A, outer loop counter
  jr nz, Color_Text_Box_Loop_Height  ; repeat if A is nonzero

  ret

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   DATA
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
text_row:
  defb 0                 ; defb = define byte

text_column:
  defb 15                ; defb = define byte

text_length:
  defb  1                ; defb = define byte

text_height:
  defb  10               ; defb = define byte

text_color:
  defb  0                ; defb = define byte

bojan_string:
  defb "Bojan is cool!"  ; defb = define byte
bojan_string_end equ $

number:
  defw  9999             ; defw = define word  <---=

udgs:

enter: ; symbol for enter; starts at $90  why?
  defb $00, $02, $12, $32, $7E, $30, $10, $00

caps_shift: ; symbol for caps shift starts at $91 why?
  defb $00, $10, $38, $7C, $10, $10, $10, $00

symbol_shift: ; symbol for symbol shift starts at $92
  defb $00, $7E, $4E, $4E, $72, $72, $7E, $00

space: ; symbol for space starts at $93
  defb $00, $00, $00, $00, $00, $42, $7E, $00

;-------------------------------------------------------------------------------
; Save a snapshot that starts execution at the address marked with Main_Sub
;-------------------------------------------------------------------------------
  savesna "bojan.sna", Main_Sub
