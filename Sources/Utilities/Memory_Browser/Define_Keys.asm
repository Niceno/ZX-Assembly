;===============================================================================
; Define_Keys
;-------------------------------------------------------------------------------
; Purpose:
; - Shows prompts, records 5 keys
; - Returns to caller (menu)
;-------------------------------------------------------------------------------
Define_Keys:

  call Unpress  ; unpress first

  ld A, (MEM_STORE_SCREEN_COLOR)  ; set color into A
  call Clear_Screen               ; clear the screen

  ;---------------------
  ;
  ; Loop to define keys
  ;
  ;---------------------
  ld C, 0  ; counter for keys

.define_keys:

    ;------------------------
    ; Print a prompting text
    ;------------------------
    push BC  ; keep the counter safe

    ld L, C : ld H, 0    ; place C (count) in HL pair
    add  HL, HL          ; index * 2 (word table)
    ld   DE, text_current_address_table
    add  HL, DE          ; HL -> defw entry

    ld   E, (HL)  ; load string ptr
    inc  HL
    ld   D, (HL)
    ex   DE, HL   ; HL = prompt string

    ld   A, C          ; compute the row ...
    add  A, A          ; ... as twice the counter
    ld   B, A          ; set row
    ld   C, 1          ; set column
    call Print_String  ; prints zero-terminated string at HL

    pop  BC  ; restore the counter

    ;-----------------------------
    ; Browse through all key rows
    ;-----------------------------
    push BC               ; save the counter in C (through NUMBER_OF_UDKS keys)
    call Browse_Key_Rows  ; A = unique code, C bit0 = 1 if any key pressed
    bit  0, C             ; check C register's zeroth bit
    pop BC                ; retreive the counter in C

    jr z, .define_keys   ; no key pressed -> keep polling

    ;---------------------------------------------------
    ; A key was pressed - wait untill it gets unpressed
    ;---------------------------------------------------
    push AF       ; keep unique code in A safe
    push BC       ; save the counter in C
    call Unpress  ; wait until all keys released
    pop BC        ; restore the counter in C
    pop AF        ; restore the unique code in A

    ;---------------------------
    ; Process the key in A here
    ;---------------------------

    ; Store the defined key ... very important!!!
    ld HL, currently_defined_keys
    ld B, 0     ; with B set to zero, the pair BC will be the offset
    add HL, BC  ; add the offset to NUMBER_OF_UDKS defined keys
    ld (HL), A  ; store the key's unique code

    ; Print the key you just pressed ... quite handy
    ld IX, key_glyphs_address_table  ; point to all key glyphs table
    ld D, 0                          ; create offset from unique key code ...
    ld E, A                          ; ... (stored in A) in the the DE pair
    add IX, DE                       ; add the offset ...
    add IX, DE                       ; ... to IX pair
    ld L, (IX+0)                     ; finally load HL with the address ...
    ld H, (IX+1)                     ; ... pointed to by IX

    push BC                    ; save key counter (in C)
    ld   A, C                  ; compute the row ...
    add  A, A                  ; ... as twice the counter
    ld   B, A                  ; set row
    ld   C, PROMPT_KEY_COLUMN  ; set column
    call Print_Udgs_Character
    pop BC                     ; restore the counter

    ; Check if counter reached NUMBER_OF_UDKS
    inc C
    ld A, C
    cp NUMBER_OF_UDKS

  jp nz, .define_keys          ; loop until we've taken NUMBER_OF_UDKS presses

  call Memory_Browser_Main

  ret

