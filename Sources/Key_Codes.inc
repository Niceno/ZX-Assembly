;---------------------------------------------------------------------
; Unique key codes 0..39 produced by Browse_Key_Rows sorted ascending
;---------------------------------------------------------------------

KEY_1     equ   0
KEY_0     equ   1
KEY_Q     equ   2
KEY_P     equ   3
KEY_A     equ   4
KEY_ente  equ   5
KEY_caps  equ   6
KEY_spac  equ   7

KEY_2     equ   8
KEY_9     equ   9
KEY_W     equ  10
KEY_O     equ  11
KEY_S     equ  12
KEY_L     equ  13
KEY_Z     equ  14
KEY_symb  equ  15

KEY_3     equ  16
KEY_8     equ  17
KEY_E     equ  18
KEY_I     equ  19
KEY_D     equ  20
KEY_K     equ  21
KEY_X     equ  22
KEY_M     equ  23

KEY_4     equ  24
KEY_7     equ  25
KEY_R     equ  26
KEY_U     equ  27
KEY_F     equ  28
KEY_J     equ  29
KEY_C     equ  30
KEY_N     equ  31

KEY_5     equ  32
KEY_6     equ  33
KEY_T     equ  34
KEY_Y     equ  35
KEY_G     equ  36
KEY_H     equ  37
KEY_V     equ  38
KEY_B     equ  39

;----------------------------------------------------------------
; The addresses of all characters you can get from Spectrum keys
; sorted by unique key codes. (Standard ones are taken from ROM,
; but special keys had to be replaced by UDGs, of course)
;----------------------------------------------------------------
all_characters_mem_coded:

  defw  MEM_1
  defw  MEM_0
  defw  MEM_Q_UPP
  defw  MEM_P_UPP
  defw  MEM_A_UPP
  defw  mem_ente
  defw  mem_caps
  defw  mem_spac

  defw  MEM_2
  defw  MEM_9
  defw  MEM_W_UPP
  defw  MEM_O_UPP
  defw  MEM_S_UPP
  defw  MEM_L_UPP
  defw  MEM_Z_UPP
  defw  mem_symb

  defw  MEM_3
  defw  MEM_8
  defw  MEM_E_UPP
  defw  MEM_I_UPP
  defw  MEM_D_UPP
  defw  MEM_K_UPP
  defw  MEM_X_UPP
  defw  MEM_M_UPP

  defw  MEM_4
  defw  MEM_7
  defw  MEM_R_UPP
  defw  MEM_U_UPP
  defw  MEM_F_UPP
  defw  MEM_J_UPP
  defw  MEM_C_UPP
  defw  MEM_N_UPP

  defw  MEM_5
  defw  MEM_6
  defw  MEM_T_UPP
  defw  MEM_Y_UPP
  defw  MEM_G_UPP
  defw  MEM_H_UPP
  defw  MEM_V_UPP
  defw  MEM_B_UPP

;------------------------------------------
; User defined characters for special keys
;------------------------------------------
mem_ente:  defb $00, $02, $12, $32, $7E, $30, $10, $00
mem_caps:  defb $00, $10, $38, $7C, $10, $10, $10, $00
mem_symb:  defb $00, $7E, $4E, $4E, $72, $72, $7E, $00
mem_spac:  defb $00, $00, $00, $00, $00, $42, $7E, $00

