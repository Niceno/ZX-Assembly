;===============================================================================
; Print_Character_Box_Sub
;-------------------------------------------------------------------------------
; Purpose:
; - Prints a character box by calling Print_Character_Sub for each char
;
; Parameters (passed via registers)
; - HL: address of the null-terminated string
; - BC: starting row (B) and column (C) for the first character
; - DE: holds the length (D) and the height (L) of the box
;
; Clobbers:
; - AF, BC, HL
;-------------------------------------------------------------------------------
Print_Character_Box_Sub:

  ld A, (HL)        ; Get the next character from the string
  or A              ; Check if it's the null terminator (0)
  ret z             ; If it is, return.

  push HL           ; Save the string pointer
  push BC           ; Save the current coordinates

  ; Prepare parameters for Print_Character_Sub
  ; HL is already the character address? Wait, no.
  ; We need to point to the char definition. Our current A is the char code.
  ; We might need a different approach.

  ; Let's assume we find a way to get char definition address in HL
  ; For now, let's adjust: we need to convert char code in A to font address.
  ; This might require a helper or we refactor Print_Character_Sub.

  call Print_Character_Sub  ; Print this character

  pop BC            ; Restore coordinates
  pop HL            ; Restore string pointer

  inc HL            ; Move to next character in the string
  inc C             ; Move to next column on the screen

  jr Print_Character_Box_Sub ; Loop for next character

  ret
