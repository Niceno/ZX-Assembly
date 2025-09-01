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

  ;--------------------------------------------
  ; Print text "Press a key for" at 3, 3
  ;--------------------------------------------
  ld A, 3                   ; row
  ld (text_row), A          ; store row coordinate
  ld A, 3                   ; column
  ld (text_column), A       ; store column coordinate
  ld A, 16                  ; length of the string
  ld (text_length), A       ; store the length of the string
  ld A,  1                  ; height
  ld (text_height), A       ; store the height
  call Set_Text_Coords_Sub  ; set up our row/col coords.

  ; Use ROM routine to print (this too over-rides the colors)
  ld HL, text_press_a_key
  ld (text_to_print), HL
  call Print_Null_Terminated_String_Sub


  ; Color the text box
  ld A, BLUE_INK + WHITE_PAPER  ; color of the string
  ld (text_color), A            ; store the color
  call Color_Text_Box_Sub

  ;--------------------------
  ;
  ; Loop to define five keys
  ;
  ;--------------------------
  ld B, 5  ; you will define five keys

Main_Ask_Again:
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
  call Set_Text_Coords_Sub              ; set up our row/column coords

  ; Color that little box
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

  ;--------------------------------------
  ; Let IX point to all characters array
  ;--------------------------------------
  ld IX, all_characters - 1  ; make sure first inc points to all_characters

  ;-------------------------------------------------------------
  ; Set the HL to point to the beginning of array all_key_ports
  ;-------------------------------------------------------------
  ld HL, all_key_ports

  ;------------------------------
  ; There are eight rows of keys
  ;------------------------------
  ld D, 8              ; there are eight rows of keys

Main_Browse_Key_Rows:

  ; Keyboard row; load the port number into BC indirectly through HL
  ld C, (HL)      ; low byte into C
  inc HL
  ld B, (HL)      ; high byte into B
  inc HL

  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 0, A        ; bit 0
  inc IX
  jp z, Main_Print_One
  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 1, A        ; bit 1
  inc IX
  jp z, Main_Print_One
  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 2, A        ; bit 2
  inc IX
  jp z, Main_Print_One
  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 3, A        ; bit 3
  inc IX
  jp z, Main_Print_One
  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 4, A        ; bit 4
  inc IX
  jp z, Main_Print_One

  dec D

  jr nz, Main_Browse_Key_Rows

  jp Main_Read_Next_Key    ; if not pressed, repeat loop

  ;----------------------------
  ; Print the proper character
  ;----------------------------
Main_Print_One:
  ld A, (IX)
  rst ROM_PRINT_A_1     ; display it

  ld A, RED_INK + YELLOW_PAPER  ; color of the string
  ld (text_color), A            ; store the color
  call Color_Text_Box_Sub       ; this seems to be needed
                                ; after calling ROM routines

  ;--------------------------------------
  ; Loop until all the keys are released
  ;--------------------------------------
  call Unpress_Sub

  ;--------------------------
  ; Retreive the key counter
  ;--------------------------
  pop BC

  dec B
  jp nz, Main_Ask_Again

  ;----------------------------------------------------------
  ; End the program with a message that all keys are defined
  ;----------------------------------------------------------
  ld A, 21                  ; row
  ld (text_row), A          ; store row coordinate
  ld A,  3                  ; column
  ld (text_column), A       ; store column coordinate
  ld A, 16                  ; length of the string
  ld (text_length), A       ; store length of the string
  ld A,  1                  ; height
  ld (text_height), A       ; store the height
  call Set_Text_Coords_Sub  ; set up our row/col coords.

  ld HL, text_keys_defined
  ld (text_to_print), HL
  call Print_Null_Terminated_String_Sub

  ret  ; end of the main program

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   SUBROUTINES
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  include "Subs/Open_Upper_Screen_Sub.asm"
  include "Subs/Set_Text_Coords_Sub.asm"
  include "Subs/Color_Text_Box_Sub.asm"
  include "Subs/Unpress.asm"
  include "Subs/Print_Null_Terminated_String_Sub.asm"

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   DATA
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

;-----------------------------------
; Variables which define text boxes
;-----------------------------------
text_row:       defb  0  ; defb = define byte
text_column:    defb 15
text_length:    defb  1
text_height:    defb 10
text_color:     defb  0
text_to_print:  defw  0

;---------------------
; Texts to be written
;---------------------
text_press_a_key:      defb "Press a key for ", 0
text_keys_defined:     defb "All keys defined", 0
text_up:               defb "up",               0
text_down:             defb "down",             0
text_left:             defb "left",             0
text_right:            defb "down",             0
text_fire:             defb "fire",             0

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

;-----------------------------------------------
; All characters you can get from Spectrum keys
; (Some had to be replaced by UDGs, of course)
;-----------------------------------------------
all_characters:
; Ordered by their bit positions in keyboard ports
  defb CHAR_1,     CHAR_2,     CHAR_3,     CHAR_4,     CHAR_5
  defb CHAR_0,     CHAR_9,     CHAR_8,     CHAR_7,     CHAR_6      ; reversed
  defb CHAR_Q_UPP, CHAR_W_UPP, CHAR_E_UPP, CHAR_R_UPP, CHAR_T_UPP
  defb CHAR_P_UPP, CHAR_O_UPP, CHAR_I_UPP, CHAR_U_UPP, CHAR_Y_UPP  ; reversed
  defb CHAR_A_UPP, CHAR_S_UPP, CHAR_D_UPP, CHAR_F_UPP, CHAR_G_UPP
  defb $90,        CHAR_L_UPP, CHAR_K_UPP, CHAR_J_UPP, CHAR_H_UPP  ; reversed
  defb $91,        CHAR_Z_UPP, CHAR_X_UPP, CHAR_C_UPP, CHAR_V_UPP
  defb $93,        $92,        CHAR_M_UPP, CHAR_N_UPP, CHAR_B_UPP  ; reversed
; Ordered naively, as they appear on the keyboard
; defb CHAR_1,     CHAR_2,     CHAR_3,     CHAR_4,     CHAR_5
; defb CHAR_6,     CHAR_7,     CHAR_8,     CHAR_9,     CHAR_0
; defb CHAR_Q_UPP, CHAR_W_UPP, CHAR_E_UPP, CHAR_R_UPP, CHAR_T_UPP
; defb CHAR_Y_UPP, CHAR_U_UPP, CHAR_I_UPP, CHAR_O_UPP, CHAR_P_UPP
; defb CHAR_A_UPP, CHAR_S_UPP, CHAR_D_UPP, CHAR_F_UPP, CHAR_G_UPP
; defb CHAR_H_UPP, CHAR_J_UPP, CHAR_K_UPP, CHAR_L_UPP, $90
; defb $91,        CHAR_Z_UPP, CHAR_X_UPP, CHAR_C_UPP, CHAR_V_UPP
; defb CHAR_B_UPP, CHAR_N_UPP, CHAR_M_UPP, $92,        $93

;-----------------------------------------------------------
; User defined graphics (start at $90, then go $91, $92 ...
;-----------------------------------------------------------
udgs:

enter:         defb $00, $02, $12, $32, $7E, $30, $10, $00  ; $90
caps_shift:    defb $00, $10, $38, $7C, $10, $10, $10, $00  ; $91
symbol_shift:  defb $00, $7E, $4E, $4E, $72, $72, $7E, $00  ; $92
space:         defb $00, $00, $00, $00, $00, $42, $7E, $00  ; $93

;-------------------------------------------------------------------------------
; Save a snapshot that starts execution at the address marked with Main_Sub
;-------------------------------------------------------------------------------
  savesna "bojan.sna", Main_Sub
