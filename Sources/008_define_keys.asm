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

  ;--------------------------------------------
  ; Print text "Press a key for" at 3, 3
  ;--------------------------------------------
  ld A, 3                                        ; row
  ld (text_row), A                               ; store row coordinate
  ld A, 3                                        ; column
  ld (text_column), A                            ; store column coordinate
  ld A, text_press_a_key_end - text_press_a_key  ; length of the string
  ld (text_length), A                            ; store the length of the string
  ld A,  1                                       ; height
  ld (text_height), A                            ; store the height
  call Set_Text_Coords                           ; set up our row/col coords.

  ; Use ROM routine to print (this too over-rides the colors)
  ld DE, text_press_a_key                         ; address of the string
  ld BC, text_press_a_key_end - text_press_a_key  ; length of string to print
  call ROM_PR_STRING                              ; print the string

  ; Color the text box
  ld A, BLUE_INK + WHITE_PAPER  ; color of the string
  ld (text_color), A            ; store the color
  call Color_Text_Box

  ;--------------------------
  ;
  ; Loop to define five keys
  ;
  ;--------------------------
  ld B, 5  ; you will define five keys

AskAgain:
  push BC  ; store the counter

  ;--------------------------------------------------
  ; Print a little yellow flashing box for the entry
  ;--------------------------------------------------
  ld A, (text_row)                      ; current row
  inc A                                 ; icrease it ...
  inc A                                 ; .. by two
  ld (text_row), A                      ; store row coordinate
  ld A,  5                              ; column
  ld (text_column), A                   ; store column coordinate
  ld A,  1                              ; length of the string
  ld (text_length), A                   ; store the length
  ld A,  1                              ; height
  ld (text_height), A                   ; store the height
  ld A, RED_INK + YELLOW_PAPER + FLASH  ; color of the string
  ld (text_color), A                    ; store the color
  call Set_Text_Coords                  ; set up our row/column coords

  ; Color that little box
  call Color_Text_Box

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

  ; Character array
  ld HL, all_characters
  dec HL                 ; make sure first inc points to all_characters

  ; Keyboard row
  ld BC, KEYS_12345

  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 0, A        ; bit 0 = key "1"
  inc HL
  jp z, PrintOne
  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 1, A        ; bit 1 = key "2"
  inc HL
  jp z, PrintOne
  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 2, A        ; bit 2 = key "3"
  inc HL
  jp z, PrintOne
  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 3, A        ; bit 3 = key "4"
  inc HL
  jp z, PrintOne
  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 4, A        ; bit 4 = key "5"
  inc HL
  jp z, PrintOne

  ; Keyboard row
  ld BC, KEYS_67890

  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 4, A        ; bit 4 = key "6"
  inc HL
  jp z, PrintOne
  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 3, A        ; bit 3 = key "7"
  inc HL
  jp z, PrintOne
  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 2, A        ; bit 2 = key "8"
  inc HL
  jp z, PrintOne
  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 1, A        ; bit 1 = key "9"
  inc HL
  jp z, PrintOne
  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 0, A        ; bit 0 = key "0"
  inc HL
  jp z, PrintOne

  ; Keyboard row
  ld BC, KEYS_QWERT

  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 0, A        ; bit 0 = key "Q"
  inc HL
  jp z, PrintOne
  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 1, A        ; bit 1 = key "W"
  inc HL
  jp z, PrintOne
  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 2, A        ; bit 2 = key "E"
  inc HL
  jp z, PrintOne
  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 3, A        ; bit 3 = key "R"
  inc HL
  jp z, PrintOne
  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 4, A        ; bit 4 = key "T"
  inc HL
  jp z, PrintOne

  ; Keyboard row
  ld BC, KEYS_YUIOP

  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 4, A        ; bit 4 = key "Y"
  inc HL
  jp z, PrintOne
  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 3, A        ; bit 3 = key "U"
  inc HL
  jp z, PrintOne
  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 2, A        ; bit 2 = key "I"
  inc HL
  jp z, PrintOne
  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 1, A        ; bit 1 = key "O"
  inc HL
  jp z, PrintOne
  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 0, A        ; bit 0 = key "P"
  inc HL
  jp z, PrintOne

  ; Keyboard row
  ld BC, KEYS_ASDFG

  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 0, A        ; bit 0 = key "A"
  inc HL
  jp z, PrintOne
  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 1, A        ; bit 1 = key "S"
  inc HL
  jp z, PrintOne
  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 2, A        ; bit 2 = key "D"
  inc HL
  jp z, PrintOne
  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 3, A        ; bit 3 = key "F"
  inc HL
  jp z, PrintOne
  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 4, A        ; bit 4 = key "G"
  inc HL
  jp z, PrintOne

  ; Keyboard row
  ld BC, KEYS_HJKLENTER

  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 4, A        ; bit 4 = key "H"
  inc HL
  jp z, PrintOne
  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 3, A        ; bit 3 = key "J"
  inc HL
  jp z, PrintOne
  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 2, A        ; bit 2 = key "K"
  inc HL
  jp z, PrintOne
  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 1, A        ; bit 1 = key "L"
  inc HL
  jp z, PrintOne
  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 0, A        ; bit 0 = key "ENTER"
  inc HL
  jp z, PrintOne

  ; Keyboard row
  ld BC, KEYS_CAPSZXCV

  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 0, A        ; bit 0 = key "CAPS SHIFT"
  inc HL
  jp z, PrintOne
  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 1, A        ; bit 1 = key "Z"
  inc HL
  jp z, PrintOne
  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 2, A        ; bit 2 = key "X"
  inc HL
  jp z, PrintOne
  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 3, A        ; bit 3 = key "C"
  inc HL
  jp z, PrintOne
  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 4, A        ; bit 4 = key "V"
  inc HL
  jp z, PrintOne

  ; Keyboard row
  ld BC, KEYS_BNMSYMSPC

  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 4, A        ; bit 4 = key "B"
  inc HL
  jp z, PrintOne
  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 3, A        ; bit 3 = key "N"
  inc HL
  jp z, PrintOne
  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 2, A        ; bit 2 = key "M"
  inc HL
  jp z, PrintOne
  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 1, A        ; bit 1 = key "SYMBOL SHIFT"
  inc HL
  jp z, PrintOne
  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 0, A        ; bit 0 = key "SPACE"
  inc HL
  jp z, PrintOne

  jp ReadNextKey    ; if not pressed, repeat loop

  ;----------------------------
  ; Print the proper character
  ;----------------------------
PrintOne:
  ld A, (HL)
  rst ROM_PRINT_A_1     ; display it

  ld A, RED_INK + YELLOW_PAPER  ; color of the string
  ld (text_color), A            ; store the color
  call Color_Text_Box           ; this seems to be needed
                                ; after calling ROM routines

  ;--------------------------------------
  ; Loop until all the keys are released
  ;--------------------------------------
  call Unpress

  ;--------------------------
  ; Retreive the key counter
  ;--------------------------
  pop BC

  dec B
  jp nz, AskAgain

  ;----------------------------------------------------------
  ; End the program with a message that all keys are defined
  ;----------------------------------------------------------
  ld A, 21                                         ; row
  ld (text_row), A                                 ; store row coordinate
  ld A,  3                                         ; column
  ld (text_column), A                              ; store column coordinate
  ld A, text_keys_defined_end - text_keys_defined  ; length of the string
  ld (text_length), A                              ; store length of the string
  ld A,  1                                         ; height
  ld (text_height), A                              ; store the height
  call Set_Text_Coords                             ; set up our row/col coords.

  ld DE, text_keys_defined                          ; address of the string
  ld BC, text_keys_defined_end - text_keys_defined  ; length of string
  call ROM_PR_STRING                                ; print the string

  ret  ; end of the main program

;===============================================================================
; Unpress
;-------------------------------------------------------------------------------
; Purpose:
; - Waits until all keys are unpressed
;
; Parameters (passed via memory locations)
; - all_key_ports
;-------------------------------------------------------------------------------
Unpress:

  ;-------------------------------------------------------------
  ; Set the HL to point to the beginning of array all_key_ports
  ;-------------------------------------------------------------
  ld HL, all_key_ports

  ;------------------------------
  ; There are eight rows of keys
  ;------------------------------
  ld D, 8              ; there are eight rows of keys

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

  ret  ; end of the subroutine

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

;-----------------------------------
; Variables which define text boxes
;-----------------------------------
text_row:      defb  0  ; defb = define byte
text_column:   defb 15
text_length:   defb  1
text_height:   defb 10
text_color:    defb  0

;---------------------
; Texts to be written
;---------------------
text_press_a_key:      defb "Press a key for "
text_press_a_key_end   equ $
text_keys_defined:     defb "All keys defined"
text_keys_defined_end  equ $
text_up:               defb "up"
text_up_end            equ $
text_down:             defb "down"
text_down_end          equ $
text_left:             defb "left"
text_left_end          equ $
text_right:            defb "down"
text_right_end         equ $
text_fire:             defb "fire"
text_fire_end          equ $

;---------------------------------------------------------------------------
; All key ports; used only in Unpressed now, maybe it can be defined there?
;---------------------------------------------------------------------------
all_key_ports:          ; this is like first array I created!
  defw KEYS_12345
  defw KEYS_67890
  defw KEYS_QWERT
  defw KEYS_YUIOP
  defw KEYS_ASDFG
  defw KEYS_HJKLENTER
  defw KEYS_CAPSZXCV
  defw KEYS_BNMSYMSPC

all_characters:
  defb CHAR_1,     CHAR_2,     CHAR_3,     CHAR_4,     CHAR_5
  defb CHAR_6,     CHAR_7,     CHAR_8,     CHAR_9,     CHAR_0
  defb CHAR_Q_UPP, CHAR_W_UPP, CHAR_E_UPP, CHAR_R_UPP, CHAR_T_UPP
  defb CHAR_Y_UPP, CHAR_U_UPP, CHAR_I_UPP, CHAR_O_UPP, CHAR_P_UPP
  defb CHAR_A_UPP, CHAR_S_UPP, CHAR_D_UPP, CHAR_F_UPP, CHAR_G_UPP
  defb CHAR_H_UPP, CHAR_J_UPP, CHAR_K_UPP, CHAR_L_UPP, $90
  defb $91,        CHAR_Z_UPP, CHAR_X_UPP, CHAR_C_UPP, CHAR_V_UPP
  defb CHAR_B_UPP, CHAR_N_UPP, CHAR_M_UPP, $92,        $93

number: defw  9999  ; defw = define word  <---=

;-----------------------------------------------------------
; User defined graphics (start at $90, then go $91, $92 ...
;-----------------------------------------------------------
udgs:

enter:         defb $00, $02, $12, $32, $7E, $30, $10, $00  ; $90
caps_shift:    defb $00, $10, $38, $7C, $10, $10, $10, $00  ; $91
symbol_shift:  defb $00, $7E, $4E, $4E, $72, $72, $7E, $00  ; $92
space:         defb $00, $00, $00, $00, $00, $42, $7E, $00  ; $93

;-------------------------------------------------------------------------------
; Save a snapshot that starts execution at the address marked with Main
;-------------------------------------------------------------------------------
  savesna "bojan.sna", Main
