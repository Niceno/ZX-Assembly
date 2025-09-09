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
syn keyword sjasmDirective include inc bin macro endm if else endif rept endr
syn keyword sjasmDirective align phase dephase disp ent disp end device
syn keyword sjasmDirective savesna savebin
hi link sjasmDirective Define

" Simple strings without complex escaping
syn region sjasmString start=+"+ end=+"+ oneline
syn region sjasmString start=+'+ end=+'+ oneline
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
syn match sjasmNumber "\<%[01]\+\>"  " binary numbers (% prefix)
hi link sjasmNumber Number

" Some constants I have introduced
syn keyword sjasmConstant ROM_PRINT_A_1  ROM_CLEAR_SCREEN  ROM_CHAN_OPEN
syn keyword sjasmConstant ROM_OUT_NUM_1  ROM_STACK_BC      ROM_PRINT_FP

syn keyword sjasmConstant MEM_ROM_START           MEM_FONT_START
syn keyword sjasmConstant MEM_SCREEN_PIXELS       MEM_SCREEN_COLORS
syn keyword sjasmConstant MEM_PRINTER_BUFFER      MEM_SYSTEM_VARS
syn keyword sjasmConstant MEM_CHARS               MEM_USER_DEFINED_GRAPHICS
syn keyword sjasmConstant MEM_STORE_SCREEN_COLOR  MEM_AVAILABLE_RAM_START
syn keyword sjasmConstant MEM_PROGRAM_START       MEM_CUSTOM_FONT_START

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

syn keyword sjasmConstant CHAR_ENTER             CHAR_AT_CONTROL
syn keyword sjasmConstant CHAR_SPACE             CHAR_EXCLAMATION_MARK
syn keyword sjasmConstant CHAR_AND_SYMBOL        CHAR_ASTERISK
syn keyword sjasmConstant CHAR_0  CHAR_1  CHAR_2  CHAR_3  CHAR_4
syn keyword sjasmConstant CHAR_5  CHAR_6  CHAR_7  CHAR_8  CHAR_9
syn keyword sjasmConstant CHAR_QUESTION_MARK     CHAR_AT
syn keyword sjasmConstant CHAR_A_UPP  CHAR_B_UPP  CHAR_C_UPP  CHAR_D_UPP
syn keyword sjasmConstant CHAR_E_UPP  CHAR_F_UPP  CHAR_G_UPP  CHAR_H_UPP
syn keyword sjasmConstant CHAR_I_UPP  CHAR_J_UPP  CHAR_K_UPP  CHAR_L_UPP
syn keyword sjasmConstant CHAR_M_UPP  CHAR_N_UPP  CHAR_O_UPP  CHAR_P_UPP
syn keyword sjasmConstant CHAR_Q_UPP  CHAR_R_UPP  CHAR_S_UPP  CHAR_T_UPP
syn keyword sjasmConstant CHAR_U_UPP  CHAR_V_UPP  CHAR_W_UPP  CHAR_X_UPP
syn keyword sjasmConstant CHAR_Y_UPP  CHAR_Z_UPP

hi link sjasmConstant Constant

let b:current_syntax = "sjasm"

