" Vim syntax file
" Language:	sjasm
"
" ==============================================================================
" I had to comment line 54 in /usr/share/vim/vim82/autoload/dist/ft.vim in order
" to over-ride the default detection of assembly language
"---------------------------------------------------------------------[T-Flows]-

" ==============================================================================
" The lines starting with "hi" are essential, they tell vim how to color
" certain groups. Common highlight groups you can link to:
" Comment - for comments
" Constant - for constants, numbers
" Identifier - for variable names, labels
" Statement - for instructions, keywords
" PreProc - for preprocessor directives
" Type - for types, registers
" Special - for special characters
" String - for strings
" Number - for numbers
"---------------------------------------------------------------------[T-Flows]-

" Remove any old syntax stuff hanging around
set tabstop=2
set shiftwidth=2
set expandtab
syn clear

" Define Z80 instruction set (I used small case on purpose)
syn keyword sjasmInstruction adc add and bit call ccf cp cpd cpdr cpi cpir cpl
syn keyword sjasmInstruction daa dec di djnz ei ex exx halt im in inc ind indr
syn keyword sjasmInstruction ini inir jp jr ld ldd lddr ldi ldir neg nop or
syn keyword sjasmInstruction otdr otir out outd outi pop push res ret reti retn
syn keyword sjasmInstruction rl rla rlc rlca rld rr rra rrc rrca rrd rst sbc
syn keyword sjasmInstruction scf set sla sra srl sub xor
hi link sjasmInstruction Statement

" Sjasm-specific directives (I use small case on purpose)
syn keyword sjasmDirective module endmodule org equ db dw ds defb defw defs
syn keyword sjasmDirective include bin macro endm if ifdef ifndef define
syn keyword sjasmDirective else endif rept endr align phase dephase
syn keyword sjasmDirective disp ent disp end device high
syn keyword sjasmDirective savesna savebin
hi link sjasmDirective Define

" Simple strings without complex escaping
syn region sjasmString start=+"+ end=+"+ oneline
hi link sjasmString String

" Registers
syn keyword sjasmRegister A B C D E F H L AF BC DE HL IX IY SP
hi link sjasmRegister Type

" Comments - sjasm uses semicolon for comments
syn match sjasmComment ";.*$"
hi link sjasmComment Comment

" Numbers (add this near your constants section)
syn match sjasmNumber "\$[0-9A-F]\+" " hex numbers ($ prefix)
syn match sjasmNumber "\<\d\+\>"     " decimal numbers
syn match sjasmNumber "%[01]\+"      " binary numbers (% prefix)
hi link sjasmNumber Number

" Some constants I have introduced
syn keyword sjasmConstant ROM_CLEAR_SCREEN  ROM_CHAN_OPEN  ROM_SET_BORDER_COLOR

syn keyword sjasmConstant MEM_ROM_START           MEM_FONT_START
syn keyword sjasmConstant MEM_SCREEN_PIXELS       MEM_SCREEN_COLORS
syn keyword sjasmConstant MEM_PRINTER_BUFFER      MEM_SYSTEM_VARS
syn keyword sjasmConstant MEM_CHARS               MEM_USER_DEFINED_GRAPHICS
syn keyword sjasmConstant MEM_STORE_SCREEN_COLOR  MEM_AVAILABLE_RAM_START
syn keyword sjasmConstant MEM_PROGRAM_START       MEM_CUSTOM_FONT_START
syn keyword sjasmConstant MEM_SHADOW_PIXELS       MEM_SHADOW_COLORS
syn keyword sjasmConstant MEM_BROWSER_START

syn keyword sjasmConstant MEM_A_UPP  MEM_B_UPP  MEM_C_UPP  MEM_D_UPP  MEM_E_UPP
syn keyword sjasmConstant MEM_F_UPP  MEM_G_UPP  MEM_H_UPP  MEM_I_UPP  MEM_J_UPP
syn keyword sjasmConstant MEM_K_UPP  MEM_L_UPP  MEM_M_UPP  MEM_N_UPP  MEM_O_UPP
syn keyword sjasmConstant MEM_P_UPP  MEM_Q_UPP  MEM_R_UPP  MEM_S_UPP  MEM_T_UPP
syn keyword sjasmConstant MEM_U_UPP  MEM_V_UPP  MEM_W_UPP  MEM_X_UPP  MEM_Y_UPP
syn keyword sjasmConstant MEM_Z_UPP

syn keyword sjasmConstant MEM_0  MEM_1  MEM_2  MEM_3  MEM_4
syn keyword sjasmConstant MEM_5  MEM_6  MEM_7  MEM_8  MEM_9

syn keyword sjasmConstant KEY_1     KEY_0     KEY_Q     KEY_P     KEY_A
syn keyword sjasmConstant KEY_ente  KEY_caps  KEY_spac  KEY_2     KEY_9
syn keyword sjasmConstant KEY_W     KEY_O     KEY_S     KEY_L     KEY_Z
syn keyword sjasmConstant KEY_symb  KEY_3     KEY_8     KEY_E     KEY_I
syn keyword sjasmConstant KEY_D     KEY_K     KEY_X     KEY_M     KEY_4
syn keyword sjasmConstant KEY_7     KEY_R     KEY_U     KEY_F     KEY_J
syn keyword sjasmConstant KEY_C     KEY_N     KEY_5     KEY_6     KEY_T
syn keyword sjasmConstant KEY_Y     KEY_G     KEY_H     KEY_V     KEY_B

syn keyword sjasmConstant CELL_ROWS          CELL_COLS
syn keyword sjasmConstant CELL_ROW_VIEW_MIN  CELL_COL_VIEW_MIN
syn keyword sjasmConstant CELL_ROW_VIEW_MAX  CELL_COL_VIEW_MAX
syn keyword sjasmConstant HERO_SCREEN_ROW    HERO_SCREEN_COL

syn keyword sjasmConstant WORLD_CELL_ROWS       WORLD_CELL_COLS
syn keyword sjasmConstant WORLD_TILE_ROWS       WORLD_TILE_COLS
syn keyword sjasmConstant WORLD_ROW_MIN_OFFSET  WORLD_COL_MIN_OFFSET
syn keyword sjasmConstant WORLD_ROW_MAX_OFFSET  WORLD_COL_MAX_OFFSET
syn keyword sjasmConstant HERO_START_ROW        HERO_START_COL

syn keyword sjasmConstant WORLD_TILE  LOCAL_SPRITE  LOCAL_TILE  WORLD_END
syn keyword sjasmConstant WORLD_ENTRY_SIZE

syn keyword sjasmConstant BLACK_INK      BLUE_INK     RED_INK
syn keyword sjasmConstant MAGENTA_INK    GREEN_INK    CYAN_INK
syn keyword sjasmConstant YELLOW_INK     WHITE_INK
syn keyword sjasmConstant BLACK_PAPER    BLUE_PAPER   RED_PAPER
syn keyword sjasmConstant MAGENTA_PAPER  GREEN_PAPER  CYAN_PAPER
syn keyword sjasmConstant YELLOW_PAPER   WHITE_PAPER
syn keyword sjasmConstant BRIGHT         FLASH

syn keyword sjasmConstant KEYS_12345     KEYS_67890
syn keyword sjasmConstant KEYS_QWERT     KEYS_YUIOP
syn keyword sjasmConstant KEYS_ASDFG     KEYS_HJKLENTER
syn keyword sjasmConstant KEYS_CAPSZXCV  KEYS_BNMSYMSPC

syn keyword sjasmConstant CHAR_SPACE
syn keyword sjasmConstant CHAR_ASTERISK
syn keyword sjasmConstant CHAR_0

hi link sjasmConstant Constant

" Macros ... maybe I could define some other type for them
syn keyword sjasmMacro PUSH_ALL_REGISTERS  POP_ALL_REGISTERS

hi link sjasmMacro Macro

let b:current_syntax = "sjasm"

