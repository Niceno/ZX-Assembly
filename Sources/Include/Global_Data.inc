;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   GLOBAL DATA
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
current_font_base:
  defw MEM_FONT_START  ; or MEM_CUSTOM_FONT_START

;---------------
; All key ports
;---------------
all_key_ports:
  defw KEYS_12345
  defw KEYS_67890
  defw KEYS_QWERT
  defw KEYS_YUIOP
  defw KEYS_ASDFG
  defw KEYS_HJKLENTER
  defw KEYS_CAPSZXCV
  defw KEYS_BNMSYMSPC

;------------------------------------------------------------------
; This table holds a list of addresses of glyphs which represent
; the pressed keys.  The table holds the addresses where each of
; the glyphs is defined.  For letters and numbers it points to
; the ROM addresses where they are defined, but for special keys
; (such as symbol shift, caps shift, space and enter, I defined
; a special set of glyphs (mem_ente, mem_caps, mem_spac, mem_symb)
;------------------------------------------------------------------
key_glyphs_address_table:

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

;-----------------------------------
; Glyph characters for special keys
;-----------------------------------
mem_ente:  defb $00, $02, $12, $32, $7E, $30, $10, $00
mem_caps:  defb $00, $10, $38, $7C, $10, $10, $10, $00
mem_symb:  defb $00, $7E, $4E, $4E, $72, $72, $7E, $00
mem_spac:  defb $00, $00, $00, $00, $00, $42, $7E, $00

