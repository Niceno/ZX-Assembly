  ifndef __PRINT_VER_STRING__
  define __PRINT_VER_STRING__

;===============================================================================
; Print_Ver_String
;-------------------------------------------------------------------------------
; Purpose:
; - Prints a vertical character box by calling Print_Character for each char
;
; Parameters (passed via registers)
; - HL: address of the null-terminated string
; - BC: starting row (B) and column (C) for the first character
;
; Calls:
; - Print_Character
;
; Clobbers:
; - AF, BC, HL
;-------------------------------------------------------------------------------
Print_Ver_String:

.character_loop

    ld A, (HL)  ; get the next character from the string
    or A        ; check if it's the null terminator (0)
    ret z       ; if it is, return.

    push HL     ; save the string pointer
    push BC     ; save the current coordinates

    call Print_Character  ; print this character

    pop BC      ; restore coordinates
    pop HL      ; restore string pointer

    inc HL      ; move to next character in the string
    inc B       ; move to next row on the screen

  jr .character_loop  ; loop for next character

  ret

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   SHARED SUBROUTINES
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  include "Shared/Print_Character.asm"

  endif

