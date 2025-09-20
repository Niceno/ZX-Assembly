;-------------------------------------------------------------------------------
; ZX Spectrum ROM Routines
;
; https://skoolkid.github.io/rom/dec/maps/routines.html
;-------------------------------------------------------------------------------
ROM_CLEAR_SCREEN      equ  3503  ; clear screen
ROM_CHAN_OPEN         equ  5633  ; channel (1 or 2) in A
ROM_SET_BORDER_COLOR  equ  8859

;-------------------------------------------------------------------------------
; ZX Spectrum 48 K Memory Map:
;
; $0000 – $3FFF  ( 16 KB)  ROM
; $4000 – $57FF  (  6 KB)  Screen bitmap (pixels, 256*192)
; $5800 – $5AFF  (768  B)  Screen attributes (color, 32x24)
; $5B00 – $5BFF  (256  B)  Printer buffer
; $5C00 – $5CBF  (192  B)  System variables
; $5CC0 – $5CCA  ( 11  B)  Reserved
; $5CCB – $FF57  (~39 KB)  Available RAM (between PROG and RAMTOP)
; $FF58 – $FFFF  (168  B)  Reserved
;-------------------------------------------------------------------------------
MEM_ROM_START              equ  $0000
MEM_FONT_START             equ  $3D00  ; 15616
MEM_SCREEN_PIXELS          equ  $4000  ; 16384
MEM_SCREEN_COLORS          equ  $5800  ; 22528
MEM_PRINTER_BUFFER         equ  $5B00
MEM_SYSTEM_VARS            equ  $5C00
MEM_CHARS                  equ  $5C37  ; 23607  higher byte of custom font def.
MEM_USER_DEFINED_GRAPHICS  equ  $5C7B  ; holds the address where UDG starts
MEM_STORE_SCREEN_COLOR     equ  $5C8D  ; holds the screen color
MEM_AVAILABLE_RAM_START    equ  $5CCB
MEM_PROGRAM_START          equ  $8000  ; 32768
MEM_CUSTOM_FONT_START      equ  $FA00  ; 64000

;-------------------------------------------------------------------------------
; Screen attributes (for the 8x8 cell grid)
;-------------------------------------------------------------------------------
CELL_ROWS          equ  24  ; total number of cell rows on the screen
CELL_COLS          equ  32  ; total number of cell columns on the screen
CELL_ROW_VIEW_MIN  equ   1  ; first row of the viewport
CELL_COL_VIEW_MIN  equ   1  ; first column of the viewport
CELL_ROW_VIEW_MAX  equ  22  ; last row of the viewport
CELL_COL_VIEW_MAX  equ  26  ; last column of the viewport

; Hero's row and column on the screen
; Hero is always in the middle of the screen
HERO_SCREEN_ROW  equ  (CELL_ROW_VIEW_MIN + CELL_ROW_VIEW_MAX) / 2
HERO_SCREEN_COL  equ  (CELL_COL_VIEW_MIN + CELL_COL_VIEW_MAX) / 2

;-------------------------------------------------------------------------------
; World's attributes
;-------------------------------------------------------------------------------
WORLD_ROWS  equ  256  ; total number of rows in the world
WORLD_COLS  equ  256  ; total number of cols in the world

WORLD_ROW_MIN_OFFSET  equ  CELL_ROW_VIEW_MIN - HERO_SCREEN_ROW
WORLD_COL_MIN_OFFSET  equ  CELL_COL_VIEW_MIN - HERO_SCREEN_COL
WORLD_ROW_MAX_OFFSET  equ  CELL_ROW_VIEW_MAX - HERO_SCREEN_ROW
WORLD_COL_MAX_OFFSET  equ  CELL_COL_VIEW_MAX - HERO_SCREEN_COL

; Hero;s starting position in rows and cols
; (Is it compatible with HERO_SCREEN_ROW and HERO_SCREEN_COL?  Does it matter?)
HERO_START_ROW  equ  WORLD_ROWS / 2 - 1
HERO_START_COL  equ  WORLD_COLS / 2 - 1

;-------------------------------------------------------------------------------
; ZX Spectrum colors
;
; To get the color you want, add codes for ink, paper color, bright and flash
;-------------------------------------------------------------------------------
BLACK_INK      equ   0
BLUE_INK       equ   1
RED_INK        equ   2
MAGENTA_INK    equ   3
GREEN_INK      equ   4
CYAN_INK       equ   5
YELLOW_INK     equ   6
WHITE_INK      equ   7
BLACK_PAPER    equ   0
BLUE_PAPER     equ   8
RED_PAPER      equ  16
MAGENTA_PAPER  equ  24
GREEN_PAPER    equ  32
CYAN_PAPER     equ  40
YELLOW_PAPER   equ  48
WHITE_PAPER    equ  56
BRIGHT         equ  64
FLASH          equ 128

;-------------------------------------------------------------------------------
; Try to map the key codes; ports and bits
;
; http://www.breakintoprogram.co.uk/hardware/computers/zx-spectrum/keyboard
;-------------------------------------------------------------------------------
KEYS_12345      equ  $F7FE  ; 63486
KEYS_67890      equ  $EFFE  ; 61438
KEYS_QWERT      equ  $FBFE  ; 64510
KEYS_YUIOP      equ  $DFFE  ; 57342
KEYS_ASDFG      equ  $FDFE  ; 65022
KEYS_HJKLENTER  equ  $BFFE  ; 49150
KEYS_CAPSZXCV   equ  $FEFE  ; 65278
KEYS_BNMSYMSPC  equ  $7FFE  ; 32766

;-------------------------------------------------------------------------------
; ZX Spectrum character set
;
; (https://worldofspectrum.net/ZXBasicManual/zxmanappa.html)
;-------------------------------------------------------------------------------
CHAR_ENTER             equ  13
CHAR_AT_CONTROL        equ  22
CHAR_SPACE             equ  32
CHAR_EXCLAMATION_MARK  equ  33
CHAR_AND_SYMBOL        equ  38
CHAR_ASTERISK          equ  42
CHAR_0                 equ  48
CHAR_1                 equ  49
CHAR_2                 equ  50
CHAR_3                 equ  51
CHAR_4                 equ  52
CHAR_5                 equ  53
CHAR_6                 equ  54
CHAR_7                 equ  55
CHAR_8                 equ  56
CHAR_9                 equ  57
CHAR_QUESTION_MARK     equ  63
CHAR_AT                equ  64
CHAR_A_UPP             equ  65
CHAR_B_UPP             equ  66
CHAR_C_UPP             equ  67
CHAR_D_UPP             equ  68
CHAR_E_UPP             equ  69
CHAR_F_UPP             equ  70
CHAR_G_UPP             equ  71
CHAR_H_UPP             equ  72
CHAR_I_UPP             equ  73
CHAR_J_UPP             equ  74
CHAR_K_UPP             equ  75
CHAR_L_UPP             equ  76
CHAR_M_UPP             equ  77
CHAR_N_UPP             equ  78
CHAR_O_UPP             equ  79
CHAR_P_UPP             equ  80
CHAR_Q_UPP             equ  81
CHAR_R_UPP             equ  82
CHAR_S_UPP             equ  83
CHAR_T_UPP             equ  84
CHAR_U_UPP             equ  85
CHAR_V_UPP             equ  86
CHAR_W_UPP             equ  87
CHAR_X_UPP             equ  88
CHAR_Y_UPP             equ  89
CHAR_Z_UPP             equ  90

;---------------------------------------------------------
; Addresses, in ROM, at which the characters are defined
; Obviously, these define Speccy's standard character set
;---------------------------------------------------------
MEM_A_UPP  equ  MEM_FONT_START + $108
MEM_B_UPP  equ  MEM_A_UPP + 8
MEM_C_UPP  equ  MEM_B_UPP + 8
MEM_D_UPP  equ  MEM_C_UPP + 8
MEM_E_UPP  equ  MEM_D_UPP + 8
MEM_F_UPP  equ  MEM_E_UPP + 8
MEM_G_UPP  equ  MEM_F_UPP + 8
MEM_H_UPP  equ  MEM_G_UPP + 8
MEM_I_UPP  equ  MEM_H_UPP + 8
MEM_J_UPP  equ  MEM_I_UPP + 8
MEM_K_UPP  equ  MEM_J_UPP + 8
MEM_L_UPP  equ  MEM_K_UPP + 8
MEM_M_UPP  equ  MEM_L_UPP + 8
MEM_N_UPP  equ  MEM_M_UPP + 8
MEM_O_UPP  equ  MEM_N_UPP + 8
MEM_P_UPP  equ  MEM_O_UPP + 8
MEM_Q_UPP  equ  MEM_P_UPP + 8
MEM_R_UPP  equ  MEM_Q_UPP + 8
MEM_S_UPP  equ  MEM_R_UPP + 8
MEM_T_UPP  equ  MEM_S_UPP + 8
MEM_U_UPP  equ  MEM_T_UPP + 8
MEM_V_UPP  equ  MEM_U_UPP + 8
MEM_W_UPP  equ  MEM_V_UPP + 8
MEM_X_UPP  equ  MEM_W_UPP + 8
MEM_Y_UPP  equ  MEM_X_UPP + 8
MEM_Z_UPP  equ  MEM_Y_UPP + 8

MEM_0  equ  MEM_FONT_START + $80
MEM_1  equ  MEM_0 + 8
MEM_2  equ  MEM_1 + 8
MEM_3  equ  MEM_2 + 8
MEM_4  equ  MEM_3 + 8
MEM_5  equ  MEM_4 + 8
MEM_6  equ  MEM_5 + 8
MEM_7  equ  MEM_6 + 8
MEM_8  equ  MEM_7 + 8
MEM_9  equ  MEM_8 + 8

;---------------------------------------------------------------------
; Unique key codes 0..39 produced by Browse_Key_Rows sorted ascending
; This unique key code is obtained as: (row_index) | (bit_index <<< 3)
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

