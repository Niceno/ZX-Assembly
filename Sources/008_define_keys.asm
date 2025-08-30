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
Main:

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
  ld A,  5                      ; row
  ld (text_row), A              ; store row coordinate
  ld A,  5                      ; column
  ld (text_column), A           ; store column coordinate
  ld A,  1                      ; length of the string
  ld (text_length), A           ; store the length
  ld A,  1                      ; height
  ld (text_height), A           ; store the height
  ld A, RED_INK + YELLOW_PAPER  ; color of the string
  ld (text_color), A            ; store the color
  call Set_Text_Coords          ; set up our row/column coords

  ;---------------------
  ; Color that asterisk
  ;---------------------
  call Color_Text_Box

  ;--------------------------
  ;
  ; Loop to define five keys
  ;
  ;--------------------------
  ld A, 5  ; you will define five keys

AskAgain:
  push AF

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
ReadNextKey:

  ; Keyboard row
  ld BC, KEYS_12345

  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 0, A        ; bit 0 = key "1"
  jp z, Print1
  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 1, A        ; bit 1 = key "2"
  jp z, Print2
  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 2, A        ; bit 2 = key "3"
  jp z, Print3
  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 3, A        ; bit 3 = key "4"
  jp z, Print4
  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 4, A        ; bit 4 = key "5"
  jp z, Print5

  ; Keyboard row
  ld BC, KEYS_67890

  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 4, A        ; bit 4 = key "6"
  jp z, Print6
  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 3, A        ; bit 3 = key "7"
  jp z, Print7
  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 2, A        ; bit 2 = key "8"
  jp z, Print8
  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 1, A        ; bit 1 = key "9"
  jp z, Print9
  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 0, A        ; bit 0 = key "0"
  jp z, Print0

  ; Keyboard row
  ld BC, KEYS_QWERT

  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 0, A        ; bit 0 = key "Q"
  jp z, PrintQ
  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 1, A        ; bit 1 = key "W"
  jp z, PrintW
  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 2, A        ; bit 2 = key "E"
  jp z, PrintE
  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 3, A        ; bit 3 = key "R"
  jp z, PrintR
  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 4, A        ; bit 4 = key "T"
  jp z, PrintT

  ; Keyboard row
  ld BC, KEYS_YUIOP

  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 4, A        ; bit 4 = key "Y"
  jp z, PrintY
  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 3, A        ; bit 3 = key "U"
  jp z, PrintU
  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 2, A        ; bit 2 = key "I"
  jp z, PrintI
  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 1, A        ; bit 1 = key "O"
  jp z, PrintO
  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 0, A        ; bit 0 = key "P"
  jp z, PrintP

  ; Keyboard row
  ld BC, KEYS_ASDFG

  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 0, A        ; bit 0 = key "A"
  jp z, PrintA
  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 1, A        ; bit 1 = key "S"
  jp z, PrintS
  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 2, A        ; bit 2 = key "D"
  jp z, PrintD
  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 3, A        ; bit 3 = key "F"
  jp z, PrintF
  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 4, A        ; bit 4 = key "G"
  jp z, PrintG

  ; Keyboard row
  ld BC, KEYS_HJKLENTER

  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 4, A        ; bit 4 = key "H"
  jp z, PrintH
  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 3, A        ; bit 3 = key "J"
  jp z, PrintJ
  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 2, A        ; bit 2 = key "K"
  jp z, PrintK
  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 1, A        ; bit 1 = key "L"
  jp z, PrintL
  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 0, A        ; bit 0 = key "ENTER"
  jp z, PrintEnter

  ; Keyboard row
  ld BC, KEYS_CAPSZXCV

  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 0, A        ; bit 0 = key "CAPS SHIFT"
  jp z, PrintCaps
  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 1, A        ; bit 1 = key "Z"
  jp z, PrintZ
  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 2, A        ; bit 2 = key "X"
  jp z, PrintX
  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 3, A        ; bit 3 = key "C"
  jp z, PrintC
  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 4, A        ; bit 4 = key "V"
  jp z, PrintV

  ; Keyboard row
  ld BC, KEYS_BNMSYMSPC

  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 4, A        ; bit 4 = key "B"
  jp z, PrintB
  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 3, A        ; bit 3 = key "N"
  jp z, PrintN
  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 2, A        ; bit 2 = key "M"
  jp z, PrintM
  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 1, A        ; bit 1 = key "SYMBOL SHIFT"
  jp z, PrintSymb
  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 0, A        ; bit 0 = key "SPACE"
  jp z, PrintSpace

  jp ReadNextKey    ; if not pressed, repeat loop

  ;--------------------------
  ; Set the proper character
  ;--------------------------
Print1:
  ld A, CHAR_1
  jp DoneSetting

Print2:
  ld A, CHAR_2
  jp DoneSetting

Print3:
  ld A, CHAR_3
  jp DoneSetting

Print4:
  ld A, CHAR_4
  jp DoneSetting

Print5:
  ld A, CHAR_5
  jp DoneSetting

Print6:
  ld A, CHAR_6
  jp DoneSetting

Print7:
  ld A, CHAR_7
  jp DoneSetting

Print8:
  ld A, CHAR_8
  jp DoneSetting

Print9:
  ld A, CHAR_9
  jp DoneSetting

Print0:
  ld A, CHAR_0
  jp DoneSetting

PrintQ:
  ld A, CHAR_Q_UPP
  jp DoneSetting

PrintW:
  ld A, CHAR_W_UPP
  jp DoneSetting

PrintE:
  ld A, CHAR_E_UPP
  jp DoneSetting

PrintR:
  ld A, CHAR_R_UPP
  jp DoneSetting

PrintT:
  ld A, CHAR_T_UPP
  jp DoneSetting

PrintY:
  ld A, CHAR_Y_UPP
  jp DoneSetting

PrintU:
  ld A, CHAR_U_UPP
  jp DoneSetting

PrintI:
  ld A, CHAR_I_UPP
  jp DoneSetting

PrintO:
  ld A, CHAR_O_UPP
  jp DoneSetting

PrintP:
  ld A, CHAR_P_UPP
  jp DoneSetting

PrintA:
  ld A, CHAR_A_UPP
  jp DoneSetting

PrintS:
  ld A, CHAR_S_UPP
  jp DoneSetting

PrintD:
  ld A, CHAR_D_UPP
  jp DoneSetting

PrintF:
  ld A, CHAR_F_UPP
  jp DoneSetting

PrintG:
  ld A, CHAR_G_UPP
  jp DoneSetting

PrintH:
  ld A, CHAR_H_UPP
  jp DoneSetting

PrintJ:
  ld A, CHAR_J_UPP
  jp DoneSetting

PrintK:
  ld A, CHAR_K_UPP
  jp DoneSetting

PrintL:
  ld A, CHAR_L_UPP
  jp DoneSetting

PrintEnter:
  ld A, $90
  jp DoneSetting

PrintCaps:
  ld A, $91
  jp DoneSetting

PrintZ:
  ld A, CHAR_Z_UPP
  jp DoneSetting

PrintX:
  ld A, CHAR_X_UPP
  jp DoneSetting

PrintC:
  ld A, CHAR_C_UPP
  jp DoneSetting

PrintV:
  ld A, CHAR_V_UPP
  jp DoneSetting

PrintB:
  ld A, CHAR_B_UPP
  jp DoneSetting

PrintN:
  ld A, CHAR_N_UPP
  jp DoneSetting

PrintM:
  ld A, CHAR_M_UPP
  jp DoneSetting

PrintSymb:
  ld A, $92
  jp DoneSetting

PrintSpace:
  ld A, $93
  jp DoneSetting

  ;--------------------------------------------------
  ; Done setting the character, you can print it now
  ;--------------------------------------------------
DoneSetting:
  rst ROM_PRINT_A_1     ; display it
  call Color_Text_Box   ; this seems to be needed every time
  call Set_Text_Coords  ; set up our row/column coords

  ;--------------------------------------
  ; Loop until all the keys are released
  ;--------------------------------------
Unpress:

  ; Set the HL to point to the beginning of array all_key_ports
  ld HL, all_key_ports

  ld D, 8  ; there are eight rows of keys
BrowseKeyRows:

  ; Load the port number into BC indirectly through HL
  ld C, (HL)      ; low byte into C
  inc HL
  ld B, (HL)      ; high byte into B
  inc HL
  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  and  %00011111  ; mask out upper three bits, keep lower five
  cp   %00011111  ; compare with all ones in lower five bits
  jr nz, Unpress  ; if not all are 1, go back an read the keyboar again

  dec D
  jr nz, BrowseKeyRows

  ;--------------------------
  ; Retreive the key counter
  ;--------------------------
  pop AF
  dec A

  jp nz, AskAgain

  ; End the program by printing Z without background
  ld A, CHAR_Z_UPP
  rst ROM_PRINT_A_1     ; display it

  ret  ; end of the main program

;===============================================================================
; Set_Text_Coords
;-------------------------------------------------------------------------------
; Purpose:
; - Set coordinates for printing text
;
; Parameters (passed via memory locations):
; - text_row
; - text_column
;-------------------------------------------------------------------------------
Set_Text_Coords:

 ld A, CHAR_AT_CONTROL  ; ASCII control code for AT.
 rst ROM_PRINT_A_1      ; print it.

 ld A, (text_row)       ; vertical position.
 rst ROM_PRINT_A_1      ; print it.

 ld A, (text_column)    ; y coordinate.
 rst ROM_PRINT_A_1      ; print it.

 ret  ; end of subroutine

;===============================================================================
; Color_Text_Box
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
Color_Text_Box:

  ;------------------------------------------------------------------------
  ; Set initial value of HL to point to the beginning of screen attributes
  ;------------------------------------------------------------------------
  ld HL, MEM_SCREEN_COLORS  ; load HL with the address of screen color

  ;------------------------------------------------------------------
  ; Increase HL text_column times, to shift it to the desired column
  ;------------------------------------------------------------------
  ld A, (text_column)  ; prepare B as loop counter
  ld B, A              ; ld B, (text_column) wouldn't work
LoopColumns:
  inc HL               ; increase HL text_row times
  djnz LoopColumns     ; decrease B and jump if nonzero

  ;-----------------------------------------------------------------
  ; Increase HL text_row * 32 times, to shift it to the desired row
  ;-----------------------------------------------------------------
  ld A, (text_row)  ; prepare B as loop counter
  ld B, A           ; ld B, (text_column) wouldn't work
  ld DE, 32         ; there are 32 columns, this is not space character
LoopRows:
  add HL, DE        ; increase HL by 32
  djnz LoopRows     ; decrease B and repeat the loop if nonzero

  ;---------------------------------------------------------------
  ; Now the HL holds the correct position of the screen attribute
  ; perfrom a double loop throug rows and columns to color a box
  ;---------------------------------------------------------------
  ld A, (text_color)   ; prepare the color
  ld C, A              ; store the color in C
  ld A, (text_height)  ; A stores height, will be the outer loop

LoopHeight:  ; loop over A, outer loop

  ; Store HL at the first row position
  push HL

  ; Set (and re-set) B to text length, inner counter
  ; You have to preserve (push/pop) in order to keep the outer counter value
  push AF              ; A stores text height, store it before using A to fill B
  ld A, (text_length)  ; prepare B as loop counter
  ld B, A              ; B stores the lengt, will be inner loop
  pop AF               ; restore A

LoopLength:          ; loop over B, inner loop
  ld (HL), C         ; set the color at position pointed by HL registers
  inc HL             ; go to the next horizontal position
  djnz LoopLength

  pop HL             ; retreive the first positin in the row
  add HL, DE         ; go to the next row

  dec A              ; decrease A, outer loop counter
  jr nz, LoopHeight  ; repeat if A is nonzero

  ret  ; end of subroutine

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

all_key_ports:          ; this is like first array I created!
  defw KEYS_12345
  defw KEYS_67890
  defw KEYS_QWERT
  defw KEYS_YUIOP
  defw KEYS_ASDFG
  defw KEYS_HJKLENTER
  defw KEYS_CAPSZXCV
  defw KEYS_BNMSYMSPC

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
; Save a snapshot that starts execution at the address marked with Main
;-------------------------------------------------------------------------------
  savesna "bojan.sna", Main
