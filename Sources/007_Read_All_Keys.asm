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

  ;---------------------
  ; Color that asterisk
  ;---------------------
  ld A, RED_INK + YELLOW_PAPER  ; color of the string
  ld BC, $0C10                  ; row and column
  ld DE, $0101                  ; length and height
  call Color_Text_Box_Reg_Sub

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
  ld HL, IX     ; address of the character to print
  ld BC, $0C10  ; row (B) and column (C)
  call Print_Character_Reg_Sub

  jp Main_Read_Next_Key

  ret

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   SUBROUTINES
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  include "Subs/Open_Upper_Screen_Sub.asm"
  include "Subs/Color_Text_Box_Reg_Sub.asm"
  include "Subs/Print_Character_Reg_Sub.asm"

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
